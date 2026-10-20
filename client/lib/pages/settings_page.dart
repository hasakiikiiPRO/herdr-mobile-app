import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/l10n_ext.dart';

import '../controllers/modes_controller.dart';
import '../core/service_locator.dart';
import '../models/pair_config.dart';
import '../repositories/agent_repository.dart';
import '../services/app_settings.dart';
import '../services/notification_api.dart';
import '../services/relay_client.dart';
import '../widgets/mode_picker_sheet.dart';
import 'help_page.dart';

/// Settings tab: connection (status, one-tap offline mode switching from the
/// saved endpoints, /pair mode picker, link to the Connection screen),
/// notifications, terminal preferences and help — the single home for app
/// settings, replacing the ⋮ menu entries.
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.config,
    required this.onModeSelected,
    required this.onRequestSwitch,
    this.modesController,
  });

  final PairConfig config;

  /// Switch the connection mode (saved endpoint or one picked from /pair).
  final Future<void> Function(PairConfig config) onModeSelected;

  /// Open the Connection screen (switch profile, pair, forget).
  final Future<void> Function() onRequestSwitch;

  /// Injectable for tests; defaults to the global [ModesController].
  final ModesController? modesController;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final AgentRepository _repository;
  late final AppSettings _settings;
  String _appVersion = '…';

  @override
  void initState() {
    super.initState();
    _repository = getIt<AgentRepository>();
    _settings = getIt<AppSettings>();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _appVersion = info.version);
  }

  /// Immediate offline switch: the mode is a saved endpoint of the current
  /// config, so no /pair round-trip is needed (same path as ConnectionPage).
  Future<void> _switchToLocalMode(String mode) async {
    final config = widget.config.viaStoredEndpoint(mode);
    if (config == null) return;
    await widget.onModeSelected(config);
  }

  /// Online picker: loads the modes the relay advertises over /pair (with
  /// loading/error states handled inside the sheet).
  Future<void> _openModePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => ModePickerSheet(
        config: widget.config,
        modesController: widget.modesController ?? getIt<ModesController>(),
        onSelected: widget.onModeSelected,
      ),
    );
  }

  void _openHelp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const HelpPage()),
    );
  }

  Future<void> _setNotificationsEnabled(bool value) async {
    _settings.setNotificationsEnabled(value);
    if (value) {
      // Ask the OS again so the user can grant permission from here.
      await getIt<NotificationApi>().requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _header(context, context.l10n.settingsConnection),
            ValueListenableBuilder<RelayStatus>(
              valueListenable: _repository.status,
              builder: (context, status, _) {
                final connected = status == RelayStatus.connected;
                return ListTile(
                  leading: Icon(
                    connected
                        ? Icons.cloud_done
                        : status == RelayStatus.connecting
                            ? Icons.cloud_sync
                            : Icons.cloud_off,
                    color: connected
                        ? Colors.green
                        : status == RelayStatus.connecting
                            ? Colors.orange
                            : Colors.grey,
                  ),
                  title: Text('${c.mode} · ${c.host}:${c.port}'),
                  subtitle: Text(_statusLabel(context, status)),
                );
              },
            ),
            // Offline mode switch: saved endpoints of this config, shown even
            // when /pair is unreachable (away from the local network, e.g. a
            // Tailscale fallback).
            if (c.endpoints.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final mode in c.endpoints.keys)
                      ChoiceChip(
                        label: Text(mode),
                        selected: mode == c.mode,
                        onSelected: (_) => _switchToLocalMode(mode),
                      ),
                  ],
                ),
              ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: Text(context.l10n.moreModes),
              subtitle: Text(context.l10n.moreModesSubtitle),
              onTap: _openModePicker,
            ),
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(context.l10n.connectionSettingsEllipsis),
              subtitle: Text(context.l10n.connectionSettingsSubtitle),
              onTap: widget.onRequestSwitch,
            ),
            const Divider(),
            _header(context, context.l10n.settingsNotifications),
            SwitchListTile(
              title: Text(context.l10n.blockedAgentAlerts),
              subtitle: Text(context.l10n.blockedAgentAlertsSubtitle),
              value: _settings.notificationsEnabled,
              onChanged: _setNotificationsEnabled,
            ),
            const Divider(),
            _header(context, context.l10n.settingsTerminal),
            ListTile(
              title: Text(context.l10n.terminalFontSize),
              subtitle: Text(
                context.l10n.terminalFontSizeSubtitle(
                  _settings.terminalFontSize.round(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Slider(
                value: _settings.terminalFontSize,
                min: AppSettings.kMinFontSize,
                max: AppSettings.kMaxFontSize,
                divisions:
                    (AppSettings.kMaxFontSize - AppSettings.kMinFontSize)
                        .round(),
                label: '${_settings.terminalFontSize.round()}',
                onChanged: _settings.setTerminalFontSize,
              ),
            ),
            SwitchListTile(
              title: Text(context.l10n.autoFollowTerminal),
              subtitle: Text(context.l10n.autoFollowTerminalSubtitle),
              value: _settings.autoScrollFollow,
              onChanged: _settings.setAutoScrollFollow,
            ),
            const Divider(),
            _header(context, context.l10n.settingsAppearance),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                context.l10n.themeSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'claude',
                    label: Text(context.l10n.themeClaude),
                    icon: const Icon(Icons.auto_awesome, size: 18),
                  ),
                  ButtonSegment(
                    value: 'teal',
                    label: Text(context.l10n.themeTeal),
                    icon: const Icon(Icons.water_drop_outlined, size: 18),
                  ),
                ],
                selected: {_settings.themeId},
                onSelectionChanged: (set) {
                  if (set.isEmpty) return;
                  _settings.setThemeId(set.first);
                },
              ),
            ),
            const Divider(),
            _header(context, context.l10n.settingsAbout),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(context.l10n.helpTroubleshooting),
              onTap: _openHelp,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.l10n.versionLabel(_appVersion)),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  String _statusLabel(BuildContext context, RelayStatus status) => switch (status) {
        RelayStatus.connected => context.l10n.online,
        RelayStatus.connecting => context.l10n.connecting,
        RelayStatus.disconnected => context.l10n.offline,
      };

  Widget _header(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}