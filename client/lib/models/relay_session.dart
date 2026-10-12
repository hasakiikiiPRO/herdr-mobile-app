/// Full herdr session: workspaces (spaces), panes (terminals and agent
/// panes) and focused targets — the `session.snapshot` response
/// (docs/10-herdr-api.md §6.1).
class RelaySession {
  const RelaySession({
    required this.workspaces,
    required this.panes,
    this.focusedWorkspaceId,
    this.focusedPaneId,
  });

  final List<RelayWorkspace> workspaces;
  final List<RelayPane> panes;
  final String? focusedWorkspaceId;
  final String? focusedPaneId;

  factory RelaySession.fromJson(Map<String, dynamic> json) {
    final workspaces = <RelayWorkspace>[];
    final rawWs = json['workspaces'];
    if (rawWs is List) {
      for (final e in rawWs) {
        if (e is Map) {
          workspaces.add(RelayWorkspace.fromJson(e.cast<String, dynamic>()));
        }
      }
    }
    final panes = <RelayPane>[];
    final rawPanes = json['panes'];
    if (rawPanes is List) {
      for (final e in rawPanes) {
        if (e is Map) {
          panes.add(RelayPane.fromJson(e.cast<String, dynamic>()));
        }
      }
    }
    return RelaySession(
      workspaces: workspaces,
      panes: panes,
      focusedWorkspaceId: json['focused_workspace_id'] as String?,
      focusedPaneId: json['focused_pane_id'] as String?,
    );
  }

  /// Serializes back to the snapshot shape (round-trips with [fromJson]) so a
  /// successful session can be cached for instant restore on reconnect.
  Map<String, dynamic> toJson() => {
        'workspaces': [for (final w in workspaces) w.toJson()],
        'panes': [for (final p in panes) p.toJson()],
        if (focusedWorkspaceId != null)
          'focused_workspace_id': focusedWorkspaceId,
        if (focusedPaneId != null) 'focused_pane_id': focusedPaneId,
      };
}

/// A herdr workspace ("space"): a terminal project area.
class RelayWorkspace {
  const RelayWorkspace({
    required this.id,
    required this.label,
    this.status = 'unknown',
    this.paneCount = 0,
    this.focused = false,
  });

  final String id;
  final String label;

  /// Aggregated agent status of the workspace (idle/working/blocked/...).
  final String status;
  final int paneCount;
  final bool focused;

  factory RelayWorkspace.fromJson(Map<String, dynamic> json) => RelayWorkspace(
        id: (json['workspace_id'] ?? '').toString(),
        label: (json['label'] ?? '').toString(),
        status: (json['agent_status'] ?? 'unknown').toString(),
        paneCount: (json['pane_count'] as num?)?.toInt() ?? 0,
        focused: json['focused'] == true,
      );

  Map<String, dynamic> toJson() => {
        'workspace_id': id,
        'label': label,
        'agent_status': status,
        'pane_count': paneCount,
        'focused': focused,
      };
}

/// A terminal pane in a workspace — either an agent pane or a plain
/// terminal (agent is empty). The target for output/keys/prompt is [id]
/// (pane_id).
class RelayPane {
  const RelayPane({
    required this.id,
    required this.workspaceId,
    required this.tabId,
    this.agent = '',
    this.status = 'unknown',
    this.cwd,
    this.tabLabel,
  });

  final String id;
  final String workspaceId;
  final String tabId;

  /// Agent name (kimi, codex, ...) or empty for a plain terminal.
  final String agent;
  final String status;
  final String? cwd;

  /// Herdr UI tab title (e.g. "test", "8"), forwarded as `tab_label`.
  final String? tabLabel;

  bool get isAgentPane => agent.isNotEmpty;

  factory RelayPane.fromJson(Map<String, dynamic> json) {
    final rawTab = json['tab_label'];
    return RelayPane(
      id: (json['pane_id'] ?? '').toString(),
      workspaceId: (json['workspace_id'] ?? '').toString(),
      tabId: (json['tab_id'] ?? '').toString(),
      agent: (json['agent'] ?? '').toString(),
      status: (json['agent_status'] ?? 'unknown').toString(),
      cwd: json['cwd'] as String?,
      tabLabel: rawTab == null || '$rawTab'.trim().isEmpty
          ? null
          : '$rawTab'.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'pane_id': id,
        'workspace_id': workspaceId,
        'tab_id': tabId,
        'agent': agent,
        'agent_status': status,
        if (cwd != null) 'cwd': cwd,
        if (tabLabel != null) 'tab_label': tabLabel,
      };
}
