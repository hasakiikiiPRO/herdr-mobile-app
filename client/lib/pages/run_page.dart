import 'package:flutter/material.dart';
import '../l10n/l10n_ext.dart';

import '../controllers/session_controller.dart';
import '../core/service_locator.dart';
import '../models/relay_session.dart';
import '../services/app_settings.dart';
import '../utils/async_value.dart';
import '../utils/toast_service.dart';

/// Supported agent kinds from `herdr agent start --kind` (docs/10-herdr-api.md).
const List<String> agentKinds = [
  'pi', 'claude', 'codex', 'gemini', 'cursor', 'devin', 'agy', 'cline',
  'omp', 'mastracode', 'opencode', 'copilot', 'kimi', 'kiro', 'droid', 'amp',
  'grok', 'hermes', 'kilo', 'qodercli', 'maki',
];

/// Run tab: launch an agent from the phone into a workspace (`agent.start`).
/// Uses the first free (agent-less) pane; when every pane already has an
/// agent, creates a new tab via `tab.create` so the phone can open a remote
/// window without touching the computer.
///
/// Workspace/pane data comes from the shared [SessionController]; this page
/// keeps only UI state (kind/workspace selection, name field, start in-flight).
class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  final TextEditingController _nameController = TextEditingController();
  String _kind = 'codex';
  String? _workspaceId;
  bool _starting = false;
  late final SessionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getIt<SessionController>();
    _controller.ensureLoaded();
    // Default the workspace selection once data arrives; keep it on refresh.
    _controller.addListener(_ensureDefaultWorkspace);
    // The controller may already be loaded (e.g. the Spaces tab fetched it) —
    // pick the default now (no setState needed before the first build).
    _workspaceId ??= _defaultWorkspaceId(_controller.state.dataOrNull);
  }

  @override
  void dispose() {
    _controller.removeListener(_ensureDefaultWorkspace);
    _nameController.dispose();
    super.dispose();
  }

  void _ensureDefaultWorkspace() {
    final session = _controller.state.dataOrNull;
    if (session != null && session.workspaces.isNotEmpty && _workspaceId == null) {
      setState(() => _workspaceId = _defaultWorkspaceId(session));
    }
  }

  /// Prefer persisted last workspace, then session focus, then first workspace.
  String? _defaultWorkspaceId(RelaySession? session) {
    if (session == null || session.workspaces.isEmpty) return null;
    final settings = getIt<AppSettings>();
    final preferred = settings.lastWorkspaceId ?? session.focusedWorkspaceId;
    if (preferred != null &&
        session.workspaces.any((w) => w.id == preferred)) {
      return preferred;
    }
    return session.workspaces.first.id;
  }

  /// First free (agent-less) pane of the selected workspace, if any.
  RelayPane? get _freePane => _controller.freePaneFor(_workspaceId);

  Future<void> _start() async {
    final name = _nameController.text.trim();
    final workspaceId = _workspaceId;
    if (workspaceId == null) {
      ToastService.showError(context, context.l10n.noWorkspacesCreateFirst);
      return;
    }
    if (name.isEmpty) {
      ToastService.showError(context, context.l10n.enterAgentName);
      return;
    }
    setState(() => _starting = true);
    try {
      final paneId =
          await _controller.startAgentInWorkspace(name, _kind, workspaceId);
      if (mounted) {
        ToastService.showSuccess(
            context, context.l10n.startedAgentInPane(name, _kind, paneId));
        _nameController.clear();
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        ToastService.showError(
          context,
          msg.toLowerCase().contains('agent_pane_busy') ||
                  msg.toLowerCase().contains('not an available shell')
              ? context.l10n.startAgentFailed(context.l10n.agentPaneBusyRetry)
              : e,
        );
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        switch (_controller.state) {
          case AsyncIdle() || AsyncLoading():
            return const Center(child: CircularProgressIndicator());
          case AsyncError(:final error):
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: _controller.refresh,
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          case AsyncData(:final data) when data.workspaces.isEmpty:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(context.l10n.noWorkspacesCreateFirst),
              ),
            );
          case AsyncData(:final data):
            final workspaces = data.workspaces;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(context.l10n.runAnAgent, style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _kind,
                  decoration: InputDecoration(
                    labelText: context.l10n.agentKind,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    for (final k in agentKinds)
                      DropdownMenuItem(value: k, child: Text(k)),
                  ],
                  onChanged: (v) => setState(() => _kind = v ?? _kind),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _workspaceId,
                  decoration: InputDecoration(
                    labelText: context.l10n.workspace,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    for (final ws in workspaces)
                      DropdownMenuItem(
                        value: ws.id,
                        child: Text(ws.label.isEmpty ? ws.id : ws.label),
                      ),
                  ],
                  onChanged: (v) {
                    setState(() => _workspaceId = v);
                    getIt<AppSettings>().setLastWorkspaceId(v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.agentName,
                    hintText: context.l10n.agentNameHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _freePane == null
                      ? context.l10n.willCreateTabThenStart
                      : context.l10n.willStartInFreePane(_freePane!.id),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: (_starting || _workspaceId == null) ? null : _start,
                  icon: _starting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(context.l10n.startAgent),
                ),
              ],
            );
        }
      },
    );
  }
}
