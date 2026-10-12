import 'package:flutter/widgets.dart' show StringCharacters;

/// An agent from the relay snapshot (`agents.snapshot`).
///
/// The record shape matches what the relay receives from herdr
/// (`HERDR_PLUGIN_EVENT_JSON`): pane_id, tab_id, workspace_id, agent,
/// agent_status, cwd, focused, terminal_id. The target identifier for
/// `agent.output` / `agent.keys` / `agent.prompt` is `pane_id`
/// (verified against a live relay: herdr rejects terminal_id and tab_id).
class RelayAgent {
  const RelayAgent({
    required this.id,
    required this.agent,
    required this.status,
    this.cwd,
    this.focused = false,
    this.workspaceId = '',
    this.isPlainTerminal = false,
    this.terminalTitle,
    this.tabLabel,
  });

  /// OSC terminal title reported by herdr (ANSI/emoji-stripped when available).
  final String? terminalTitle;

  /// Herdr UI tab title (e.g. "test", "8") from snapshot tabs[].label,
  /// forwarded by the relay as `tab_label`.
  final String? tabLabel;

  /// pane_id is the only valid target for agent operations.
  final String id;

  /// Agent name (codex, kimi, ...). May be empty.
  final String agent;

  /// Status from herdr: idle, working, blocked, done, unknown
  /// (docs/10-herdr-api.md §6.2).
  final String status;

  final String? cwd;

  final bool focused;

  /// Workspace (space) this agent's pane belongs to ('' when unknown).
  final String workspaceId;

  /// True when this is a plain terminal pane (no agent): input is sent as
  /// literal text (`pane.send_text`), not as an agent prompt.
  final bool isPlainTerminal;

  /// Blocked — waiting for the user's response ("needs my reply").
  bool get isBlocked => status.toLowerCase() == 'blocked';

  /// Copy with selected fields replaced. Used to apply event deltas (e.g. a
  /// status change) without losing fields the event does not carry.
  RelayAgent copyWith({
    String? id,
    String? agent,
    String? status,
    String? cwd,
    bool? focused,
    String? workspaceId,
    bool? isPlainTerminal,
    String? terminalTitle,
    String? tabLabel,
  }) {
    return RelayAgent(
      id: id ?? this.id,
      agent: agent ?? this.agent,
      status: status ?? this.status,
      cwd: cwd ?? this.cwd,
      focused: focused ?? this.focused,
      workspaceId: workspaceId ?? this.workspaceId,
      isPlainTerminal: isPlainTerminal ?? this.isPlainTerminal,
      terminalTitle: terminalTitle ?? this.terminalTitle,
      tabLabel: tabLabel ?? this.tabLabel,
    );
  }

  /// Human-readable name for the list: agent, otherwise pane_id.
  String get displayAgent => agent.isEmpty ? id : agent;

  /// Short pane id (`w4:p27` -> `p27`).
  String get shortId => id.contains(':') ? id.split(':').last : id;

  String get cwdBase {
    final c = (cwd ?? '').replaceAll(RegExp(r'/+$'), '');
    if (c.isEmpty) return '';
    final i = c.lastIndexOf(RegExp(r'[/\\]'));
    return i < 0 ? c : c.substring(i + 1);
  }

  /// Folder segment from a generic agent title such as `π - cc` / `pi - cc`.
  String get _folderFromGenericTitle {
    final t = (terminalTitle ?? '').trim();
    if (t.isEmpty) return '';
    final m = RegExp(r'^(.+?)\s*[-–—:]\s*(.+)$').firstMatch(t);
    if (m == null) return '';
    final l = m.group(1)!.trim().toLowerCase();
    final r = m.group(2)!.trim();
    if ({agent.toLowerCase(), 'π', 'pi'}.contains(l) &&
        RegExp(r'^[\w.-]+$').hasMatch(r)) {
      return r;
    }
    return '';
  }

  /// The terminal title when it actually says something about this session
  /// (claude sets it to the conversation topic). Generic titles such as
  /// `π - cc`, `pi`, `user@host: ~/cc` or the cwd name return null.
  String? get meaningfulTitle {
    var t = (terminalTitle ?? '').trim();
    t = t.replaceFirst(RegExp(r'^[^\p{L}\p{N}]+', unicode: true), '').trim();
    if (t.isEmpty) return null;
    final low = t.toLowerCase();
    final a = agent.toLowerCase();
    final base = cwdBase.toLowerCase();
    if (low == a || low == base) return null;
    if (RegExp(r'^[\w.-]+@[\w.-]+:').hasMatch(t)) return null;
    final m = RegExp(r'^(.+?)\s*[-–—:]\s*(.+)$').firstMatch(low);
    if (m != null) {
      final l = m.group(1)!, r = m.group(2)!;
      // `π - cc` / `pi - project` / `{agent} - folder` is default agent chrome,
      // not a per-session topic — even when cwd is unknown.
      if ({a, 'π', 'pi'}.contains(l)) return null;
      final generic = {a, 'π', 'pi', base, ''};
      if (generic.contains(l) && (generic.contains(r) || r == cwd?.toLowerCase())) {
        return null;
      }
    }
    return t;
  }

  /// Distinct primary label for a row: Herdr tab title first, else meaningful
  /// terminal title, else "folder · last prompt", else "folder · pane id".
  /// Never the bare agent name — that collides when many panes share `pi`.
  ///
  /// [folderHint] (e.g. workspace label) is used when [cwd] is missing.
  String primaryLabel({String? lastPrompt, String? folderHint}) {
    // Plain terminals keep the full pane id — there is no agent name to collide.
    if (isPlainTerminal) {
      final tab = (tabLabel ?? '').trim();
      return tab.isNotEmpty ? tab : id;
    }
    final tab = (tabLabel ?? '').trim();
    if (tab.isNotEmpty) return tab;
    final title = meaningfulTitle;
    if (title != null) return title;
    final hint = (folderHint ?? '').trim();
    final fromTitle = _folderFromGenericTitle;
    final base = cwdBase.isNotEmpty
        ? cwdBase
        : (fromTitle.isNotEmpty ? fromTitle : hint);
    final p = (lastPrompt ?? '').trim().split('\n').first.trim();
    final tail = p.isNotEmpty
        ? (p.characters.length > 40 ? '${p.characters.take(40)}…' : p)
        : shortId;
    final label = base.isEmpty ? tail : '$base · $tail';
    // Guard: never surface just the agent name as the primary title.
    if (agent.isNotEmpty && label.toLowerCase() == agent.toLowerCase()) {
      return shortId;
    }
    return label;
  }

  /// Secondary line for list tiles: "agent · status" (or pane id for plain
  /// terminals).
  String secondaryLabel(String status) {
    if (isPlainTerminal || agent.isEmpty) {
      return '$id · $status';
    }
    return '$displayAgent · $status';
  }

  /// Sorts the list for the screen: blocked agents (awaiting a reply) on top,
  /// the rest by name. Keeps stability within groups.
  static List<RelayAgent> sorted(List<RelayAgent> agents) {
    final list = [...agents];
    list.sort((a, b) {
      if (a.isBlocked != b.isBlocked) return a.isBlocked ? -1 : 1;
      final c = a.displayAgent.toLowerCase().compareTo(b.displayAgent.toLowerCase());
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    return list;
  }

  factory RelayAgent.fromJson(Map<String, dynamic> json) {
    final id = json['pane_id'] ?? json['id'] ?? json['target'] ?? '';
    final rawTab = json['tab_label'];
    return RelayAgent(
      id: id is String ? id : '$id',
      agent: (json['display_agent'] ?? json['agent'] ?? '').toString(),
      status: (json['agent_status'] ?? json['status'] ?? 'unknown').toString(),
      cwd: json['cwd'] as String?,
      focused: json['focused'] == true,
      workspaceId: (json['workspace_id'] ?? '').toString(),
      terminalTitle:
          (json['terminal_title_stripped'] ?? json['terminal_title']) as String?,
      tabLabel: rawTab == null || '$rawTab'.trim().isEmpty
          ? null
          : '$rawTab'.trim(),
    );
  }

  /// Serializes back to the snapshot shape (round-trips with [fromJson]) so a
  /// successful snapshot can be cached for offline use.
  Map<String, dynamic> toJson() => {
        'pane_id': id,
        'agent': agent,
        'agent_status': status,
        if (cwd != null) 'cwd': cwd,
        'focused': focused,
        if (terminalTitle != null) 'terminal_title': terminalTitle,
        if (tabLabel != null) 'tab_label': tabLabel,
      };
}
