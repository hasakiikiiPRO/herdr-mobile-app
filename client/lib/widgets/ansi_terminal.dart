import 'package:flutter/material.dart';

import 'ansi_terminal_parser.dart';

/// Renders terminal output (ANSI SGR colors + `\r` line rewrites) the way a
/// terminal would: `\r` rewinds to the start of the current line and
/// overwrites its cells (so progress bars / spinners don't turn into mush),
/// SGR sequences are turned into styled spans, and every other escape is
/// stripped safely.
///
/// Long lines wrap to the widget width so tail output on a phone stays
/// readable within the screen; the widget scrolls vertically via the
/// optional [controller], so the page can keep a sticky "follow output"
/// scroll.
class AnsiTerminal extends StatefulWidget {
  const AnsiTerminal({
    super.key,
    required this.text,
    this.controller,
    this.style,
    this.backgroundColor = const Color(0xFF0D0D0D),
    this.padding = const EdgeInsets.all(12),
  });

  /// Raw terminal text (may contain ANSI escapes and `\r`).
  final String text;

  /// Vertical scroll controller (owned by the page for sticky scrolling).
  final ScrollController? controller;

  /// Base style for uncolored text. Defaults to a readable dark-terminal look.
  final TextStyle? style;

  /// Terminal backdrop. Defaults to a VS Code style dark gray.
  final Color backgroundColor;

  final EdgeInsetsGeometry padding;

  static const TextStyle defaultStyle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    height: 1.3,
    fontFamilyFallback: ['Menlo', 'RobotoMono', 'Courier New', 'monospace'],
    fontFeatures: [FontFeature.tabularFigures()],
    color: Color(0xFFE8E4DF),
  );

  /// Dark-on-light variant used when no explicit style is given and the app
  /// runs in light mode (audit P2.2: the const default is light-on-dark).
  static const TextStyle lightStyle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    height: 1.3,
    fontFamilyFallback: ['Menlo', 'RobotoMono', 'Courier New', 'monospace'],
    fontFeatures: [FontFeature.tabularFigures()],
    color: Color(0xFF1F1F1F),
  );

  @override
  State<AnsiTerminal> createState() => _AnsiTerminalState();
}

class _AnsiTerminalState extends State<AnsiTerminal> {
  /// Memoization: the parsed [SelectableText.rich] for the last rendered text.
  /// Live updates re-read the whole tail (~500 lines); while the text is
  /// unchanged (e.g. duplicate/status-only rebuilds) we return the identical
  /// widget instance, so Flutter skips both the ANSI reparse and the relayout.
  String? _cacheText;
  TextStyle? _cacheStyle;
  SelectableText? _cacheSelectable;

  int? _cacheCols;

  static final RegExp _ansi = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]|\x1B\][^\x07\x1B]*(\x07|\x1B\\)|\x1B.');
  static final RegExp _ruleRun = RegExp(r'[─━═\-_]{4,}');

  /// Remote TUIs (pi, claude, ...) draw horizontal rules / editor borders at
  /// the host pane width. On a narrow phone each rule soft-wraps into several
  /// rows of bare colored dashes, which looks like a stack of empty colored
  /// bars. Shrink the dash runs of such lines so they fit [cols].
  static final RegExp _ruleOnly =
      RegExp(r'^[\s─━═\-_─│┃╭╮╰╯┌┐└┘├┤┬┴┼╌╍┄┅╴╶╸╺]*$');
  static final RegExp _dashChar = RegExp(r'[─━═\-_╌╍┄┅]');

  /// Drops lines whose visible content is only box-drawing / dash characters
  /// (editor borders, separators). They carry no information and on a phone
  /// show up as stacks of empty colored bars. Their escape sequences are kept
  /// (moved onto the next line) so color state stays consistent.
  static String dropRuleLines(String text) {
    final lines = text.split('\n');
    final out = <String>[];
    var pending = '';
    for (final line in lines) {
      final visible = line.replaceAll(_ansi, '').replaceAll('\r', '');
      final isRule = visible.trim().isNotEmpty &&
          _ruleOnly.hasMatch(visible) &&
          _dashChar.allMatches(visible).length >= 3;
      if (isRule) {
        pending += _ansi.allMatches(line).map((m) => m.group(0)).join();
        continue;
      }
      out.add(pending + line);
      pending = '';
    }
    if (pending.isNotEmpty) out.add(pending);
    return out.join('\n');
  }

  static String fitRules(String text, int cols) {
    text = dropRuleLines(text);
    if (cols <= 0) return text;
    final lines = text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final visible = line.replaceAll(_ansi, '').replaceAll('\r', '');
      var excess = visible.runes.length - cols;
      if (excess <= 0) continue;
      final runs = _ruleRun.allMatches(line).toList();
      final ruleChars = runs.fold<int>(0, (a, m) => a + m.end - m.start);
      if (ruleChars < excess) continue; // real content too long; let it wrap
      final buf = StringBuffer();
      var last = 0;
      // trim from the longest runs first
      runs.sort((a, b) => (b.end - b.start).compareTo(a.end - a.start));
      final cut = <int, int>{};
      for (final m in runs) {
        if (excess <= 0) break;
        final len = m.end - m.start;
        final c = excess < len - 1 ? excess : len - 1;
        cut[m.start] = c;
        excess -= c;
      }
      runs.sort((a, b) => a.start.compareTo(b.start));
      for (final m in runs) {
        buf.write(line.substring(last, m.start));
        buf.write(line.substring(m.start, m.end - (cut[m.start] ?? 0)));
        last = m.end;
      }
      buf.write(line.substring(last));
      lines[i] = buf.toString();
    }
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final base0 = widget.style ??
          (Theme.of(context).brightness == Brightness.light
              ? AnsiTerminal.lightStyle
              : AnsiTerminal.defaultStyle);
      final tp = TextPainter(
        text: TextSpan(text: '─' * 10, style: base0),
        textDirection: TextDirection.ltr,
      )..layout();
      final charW = tp.width / 10;
      final inner = constraints.maxWidth -
          widget.padding.resolve(TextDirection.ltr).horizontal;
      final cols = (constraints.maxWidth.isFinite && charW > 0)
          ? (inner / charW).floor()
          : 0;
      return _build(context, cols);
    });
  }

  Widget _build(BuildContext context, int cols) {
    final theme = Theme.of(context);
    // The default style is a const; make the memoization key theme-aware so a
    // light/dark switch re-parses with readable colors instead of reusing the
    // stale light-on-light const (audit P2.2).
    final base = widget.style ??
        (theme.brightness == Brightness.light
            ? AnsiTerminal.lightStyle
            : AnsiTerminal.defaultStyle);
    if (widget.text != _cacheText || base != _cacheStyle || cols != _cacheCols) {
      final spans =
          AnsiTerminalParser(fitRules(widget.text, cols), baseStyle: base)
              .parse();
      _cacheCols = cols;
      _cacheText = widget.text;
      _cacheStyle = base;
      _cacheSelectable = SelectableText.rich(
        TextSpan(children: spans),
        style: base,
      );
    }
    return Container(
      color: widget.backgroundColor,
      child: SingleChildScrollView(
        controller: widget.controller,
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(),
        child: _cacheSelectable!,
      ),
    );
  }
}

/// Public entry for the rule-line filter (used by tests).
String dropTerminalRuleLines(String text) =>
    _AnsiTerminalState.dropRuleLines(text);
