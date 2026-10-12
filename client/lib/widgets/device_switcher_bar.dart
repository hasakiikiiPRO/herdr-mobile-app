import 'dart:async';

import 'package:flutter/material.dart';

import '../core/service_locator.dart';
import '../core/transport/http_health.dart';
import '../l10n/l10n_ext.dart';
import '../models/pair_config.dart';
import '../services/config_store.dart';
import '../services/relay_client.dart';

/// Horizontal chip bar of saved relay devices. Tap a chip to switch the active
/// profile immediately (parent reconnects). The active device always shows its
/// live [RelayStatus]; other devices get a single cheap /healthz probe when
/// the bar loads (injectable for tests).
///
/// Day-to-day switching lives here so Settings is only needed for pair/forget.
class DeviceSwitcherBar extends StatefulWidget {
  const DeviceSwitcherBar({
    super.key,
    required this.activeConfig,
    required this.activeStatus,
    required this.onSwitch,
    this.onAddDevice,
    this.configStore,
    this.reachabilityProbe,
  });

  /// Currently connected profile (chip highlighted).
  final PairConfig activeConfig;

  /// Live status of the active relay (drives the selected chip's dot).
  final ValueNotifier<RelayStatus> activeStatus;

  /// Switch to another saved profile and reconnect.
  final Future<void> Function(PairConfig config) onSwitch;

  /// Optional "Add" chip — opens the scanner.
  final Future<void> Function()? onAddDevice;

  /// Injectable for tests; defaults to the global [ConfigStore].
  final ConfigStore? configStore;

  /// Optional probe for non-active devices. Defaults to a single short
  /// /healthz check. Tests inject a sync stub so [pumpAndSettle] never waits
  /// on the network.
  final Future<bool> Function(PairConfig config)? reachabilityProbe;

  @override
  State<DeviceSwitcherBar> createState() => _DeviceSwitcherBarState();
}

class _DeviceSwitcherBarState extends State<DeviceSwitcherBar> {
  List<PairConfig> _profiles = const [];
  /// profileKey → reachable (null = not probed yet / unknown).
  final Map<String, bool?> _reachability = {};
  bool _switching = false;
  int _loadGen = 0;

  ConfigStore get _store => widget.configStore ?? getIt<ConfigStore>();

  @override
  void initState() {
    super.initState();
    widget.activeStatus.addListener(_onActiveStatus);
    _reload();
  }

  @override
  void didUpdateWidget(covariant DeviceSwitcherBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeStatus != widget.activeStatus) {
      oldWidget.activeStatus.removeListener(_onActiveStatus);
      widget.activeStatus.addListener(_onActiveStatus);
    }
    if (oldWidget.activeConfig.profileKey != widget.activeConfig.profileKey) {
      _reload();
    }
  }

  @override
  void dispose() {
    widget.activeStatus.removeListener(_onActiveStatus);
    super.dispose();
  }

  void _onActiveStatus() {
    if (mounted) setState(() {});
  }

  Future<void> _reload() async {
    final gen = ++_loadGen;
    final profiles = await _store.loadProfiles();
    if (!mounted || gen != _loadGen) return;
    setState(() => _profiles = profiles);
    // Cheap background probe for inactive devices (does not block first paint).
    unawaited(_probeOthers(profiles, gen));
  }

  Future<void> _probeOthers(List<PairConfig> profiles, int gen) async {
    final activeKey = widget.activeConfig.profileKey;
    final probe = widget.reachabilityProbe ?? _defaultProbe;
    for (final p in profiles) {
      if (!mounted || gen != _loadGen) return;
      if (p.profileKey == activeKey) continue;
      final ok = await probe(p);
      if (!mounted || gen != _loadGen) return;
      setState(() => _reachability[p.profileKey] = ok);
    }
  }

  /// Single short /healthz — cheap enough for a chip bar.
  Future<bool> _defaultProbe(PairConfig config) async {
    final health = HttpHealth();
    try {
      return await health.check(config.healthUri, attempts: 1);
    } finally {
      health.close();
    }
  }

  Future<void> _onTap(PairConfig config) async {
    if (_switching) return;
    if (config.profileKey == widget.activeConfig.profileKey) return;
    setState(() => _switching = true);
    try {
      await widget.onSwitch(config);
    } finally {
      if (mounted) setState(() => _switching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeKey = widget.activeConfig.profileKey;
    final status = widget.activeStatus.value;

    // Always show at least the active device so the name is visible even with
    // a single paired relay.
    final profiles = _profiles.isEmpty ? [widget.activeConfig] : _profiles;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      child: SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          children: [
            for (final p in profiles) ...[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _DeviceChip(
                  label: p.displayName,
                  selected: p.profileKey == activeKey,
                  // Active chip: live status. Others: probed reachability.
                  online: p.profileKey == activeKey
                      ? status == RelayStatus.connected
                      : _reachability[p.profileKey],
                  connecting: p.profileKey == activeKey &&
                      status == RelayStatus.connecting,
                  enabled: !_switching,
                  tooltip: context.l10n.tapToSwitchDevice,
                  onTap: () => _onTap(p),
                ),
              ),
            ],
            if (widget.onAddDevice != null)
              ActionChip(
                avatar: const Icon(Icons.add, size: 16),
                label: Text(context.l10n.addDeviceChip),
                onPressed: _switching ? null : () => widget.onAddDevice!(),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        ),
      ),
    );
  }
}

class _DeviceChip extends StatelessWidget {
  const _DeviceChip({
    required this.label,
    required this.selected,
    required this.online,
    required this.connecting,
    required this.enabled,
    required this.tooltip,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool? online;
  final bool connecting;
  final bool enabled;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color dot;
    if (connecting) {
      dot = Colors.orange;
    } else if (online == true) {
      dot = Colors.green;
    } else if (online == false) {
      dot = Colors.grey;
    } else {
      dot = theme.colorScheme.outlineVariant;
    }

    return Tooltip(
      message: tooltip,
      child: FilterChip(
        selected: selected,
        showCheckmark: false,
        avatar: Icon(Icons.circle, size: 10, color: dot),
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: selected
                ? const TextStyle(fontWeight: FontWeight.w600)
                : null,
          ),
        ),
        onSelected: enabled ? (_) => onTap() : null,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: theme.colorScheme.primaryContainer,
        side: selected
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : null,
      ),
    );
  }
}
