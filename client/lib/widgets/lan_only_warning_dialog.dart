import 'package:flutter/material.dart';
import '../l10n/l10n_ext.dart';

import '../pages/help_page.dart';

/// Bottom sheet warning shown when a pair link only knows the LAN endpoint:
/// the relay works on the current WiFi but will be unreachable once the user
/// leaves home (docs/AUTO_MODE_SWITCHING_PLAN.md, Phase 1.1).
///
/// Returns `true` when the user picks "Continue anyway"; `false` on dismissal
/// or "Learn more" (which opens the help page — pairing is then left to a
/// second attempt, since the sheet route is dismissed with the help push).
Future<bool> showLanOnlyWarning(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _LanOnlyWarningSheet(),
  );
  return result ?? false;
}

class _LanOnlyWarningSheet extends StatelessWidget {
  const _LanOnlyWarningSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: theme.colorScheme.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.limitedConnectivity,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.limitedConnectivityBody,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.installTailscaleBoth, style: theme.textTheme.bodyMedium),
          Text(context.l10n.rescanQrTailscale,
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Keep the sheet open under the help page; the user comes
                  // back and can still choose to continue.
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const HelpPage()),
                  );
                },
                child: Text(context.l10n.learnMore),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(context.l10n.continueAnyway),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
