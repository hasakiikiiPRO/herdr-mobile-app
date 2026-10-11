import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../services/relay_client.dart';

enum ToastType { success, error, info, warning }

class ToastService {
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = switch (type) {
      ToastType.success => Colors.green.shade700,
      ToastType.error => Colors.red.shade700,
      ToastType.warning => Colors.orange.shade700,
      ToastType.info => Colors.blue.shade700,
    };

    final icon = switch (type) {
      ToastType.success => Icons.check_circle,
      ToastType.error => Icons.error,
      ToastType.warning => Icons.warning,
      ToastType.info => Icons.info,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showError(BuildContext context, Object error) {
    show(context, _formatError(context, error), type: ToastType.error);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message, type: ToastType.success);
  }

  static String _formatError(BuildContext context, Object error) {
    // Relay protocol errors map to actionable advice instead of a raw code.
    final l10n = AppLocalizations.of(context);
    if (error is RelayException) {
      return switch (error.code) {
        'not_connected' => l10n.errorNotConnected,
        'timeout' => l10n.errorTimeout,
        'unauthorized' => l10n.errorUnauthorized,
        _ => error.message.isEmpty ? error.code : error.message,
      };
    }
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }
}
