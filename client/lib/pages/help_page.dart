import 'package:flutter/material.dart';
import '../l10n/l10n_ext.dart';

/// Help & troubleshooting: what to do when the relay is unreachable and what
/// each connection mode means (docs/AUTO_MODE_SWITCHING_PLAN.md, Phase 5.1).
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.help)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(context.l10n.connectionIssues, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _qaCard(
              context,
              theme,
              question: context.l10n.helpAwayQuestion,
              answer: context.l10n.helpAwayAnswer,
            ),
            const SizedBox(height: 24),
            Text(context.l10n.connectionModes, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _modeCard(
              theme,
              icon: Icons.wifi,
              title: context.l10n.modeLanTitle,
              body: context.l10n.modeLanBody,
            ),
            const SizedBox(height: 8),
            _modeCard(
              theme,
              icon: Icons.lan,
              title: context.l10n.modeTailscaleTitle,
              body: context.l10n.modeTailscaleBody,
            ),
            const SizedBox(height: 8),
            _modeCard(
              theme,
              icon: Icons.public,
              title: context.l10n.modeFunnelTitle,
              body: context.l10n.modeFunnelBody,
            ),
          ],
        ),
      ),
    );
  }

  Widget _qaCard(BuildContext context, ThemeData theme,
      {required String question, required String answer}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.helpQuestion(question),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(context.l10n.helpAnswer(answer), style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _modeCard(ThemeData theme,
      {required IconData icon, required String title, required String body}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
