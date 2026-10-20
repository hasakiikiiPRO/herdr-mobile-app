/// Client-side terminal history for the agent page.
///
/// herdr (0.9.x) clamps every `pane read` / `agent read` to the newest
/// [kHerdrMaxReadLines] rendered rows (`lines.min(1000)` in herdr's
/// `api_helpers.rs`) and has no offset/paging parameter, so the phone can
/// never fetch rows older than that window. To avoid re-sending the whole
/// window on every live update over slow links, the page fetches the full
/// window once and then only a short tail, stitching the tail onto what it
/// already holds with [mergeTerminalTail]. Rows that scroll out of herdr's
/// window while the page stays open are kept (up to [kMaxRetainedLines]).
library;

/// Most rows herdr returns for one read, whatever `--lines` asks for.
const int kHerdrMaxReadLines = 1000;

/// Rows fetched on live refreshes (pane.output_changed / working poll).
const int kTailReadLines = 150;

/// Upper bound on rows kept in memory while an agent page is open.
const int kMaxRetainedLines = 5000;

/// Splits terminal output into rows (a trailing newline does not add a row).
List<String> splitTerminalLines(String text) {
  if (text.isEmpty) return const [];
  final lines = text.split('\n');
  if (lines.isNotEmpty && lines.last.isEmpty) lines.removeLast();
  return lines;
}

bool _isBlank(String line) {
  // Strip SGR/CSI sequences before checking for visible content.
  final visible = line.replaceAll(RegExp(r'\x1B\[[0-9;?]*[ -/]*[@-~]'), '');
  return visible.trim().isEmpty;
}

/// Stitches [tail] (the newest rows just read from herdr) onto [old] (rows
/// already shown). Finds the most recent place in [old] where an anchor block
/// from the top of [tail] appears and replaces everything from there on with
/// [tail]; rows above the anchor are preserved. The bottom of a TUI (spinner,
/// input box, status line) changes between reads, so a strict suffix/prefix
/// overlap would not work — anchoring on the stable top of the tail does.
///
/// Returns `null` when no anchor is found (more than a tail's worth of rows
/// scrolled by, or the screen was fully redrawn): the caller should do a full
/// read instead. The result is trimmed to [maxLines] from the top.
List<String>? mergeTerminalTail(List<String> old, List<String> tail,
    {int anchorSize = 6, int maxLines = kMaxRetainedLines}) {
  if (old.isEmpty) return _trim(List<String>.of(tail), maxLines);
  if (tail.isEmpty) return null;
  // Choose an anchor block that starts with a visible row, so we never anchor
  // on runs of blank lines (which match anywhere).
  var start = 0;
  while (start < tail.length && _isBlank(tail[start])) {
    start++;
  }
  if (start >= tail.length) return null;
  final k = (tail.length - start) < anchorSize ? tail.length - start : anchorSize;
  for (var j = old.length - k; j >= 0; j--) {
    var match = true;
    for (var i = 0; i < k; i++) {
      if (old[j + i] != tail[start + i]) {
        match = false;
        break;
      }
    }
    if (!match) continue;
    final keep = j - start;
    final merged = <String>[
      if (keep > 0) ...old.sublist(0, keep),
      ...tail,
    ];
    return _trim(merged, maxLines);
  }
  return null;
}

List<String> _trim(List<String> lines, int maxLines) =>
    lines.length > maxLines ? lines.sublist(lines.length - maxLines) : lines;
