import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Color palette for agent statuses in the list and details.
///
/// Status vocabulary — `idle / working / blocked / done / unknown`
/// (see docs/01-architecture.md). Unknown statuses are tolerated.
/// Colors come from [HerdrColors] so Claude vs Teal themes stay consistent.
Color statusColor(ThemeData theme, String status) {
  final colors = theme.extension<HerdrColors>() ?? HerdrColors.claude;
  final s = status.toLowerCase();
  if (s == 'done' || s == 'success' || s == 'idle') return colors.statusIdle;
  if (s == 'blocked' || s == 'waiting') return colors.statusBlocked;
  if (s == 'error' || s == 'failed') return colors.statusError;
  if (s == 'running' || s == 'working' || s == 'thinking') {
    return colors.statusWorking;
  }
  return colors.statusUnknown;
}

/// Compact chip with the agent's status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor(theme, status).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor(theme, status).withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor(theme, status),
        ),
      ),
    );
  }
}
