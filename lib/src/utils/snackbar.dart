import 'package:flutter/material.dart';

/// Snackbar Type for identifying the type of snackbar.
/// Used for showing different snackbar for different type.
enum SnackbarType {
  /// Success Snackbar
  success(color: Colors.green, icon: Icons.check_circle),

  /// Error Snackbar
  error(color: Colors.red, icon: Icons.error),

  /// Warning Snackbar
  warning(color: Colors.amber, icon: Icons.warning),

  /// Info Snackbar
  info(color: Colors.blue, icon: Icons.info);

  /// Constructor for the [SnackbarType] enum.
  const SnackbarType({required this.color, required this.icon});

  /// Color for the snackbar.
  final Color color;

  /// Icon for the snackbar.
  final IconData icon;
}

/// Snackbar Utils
class SnackbarUtils {
  /// ScaffoldMessengerKey for showing snackbar.
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Shows a snackbar with the given [message].
  /// If [type] is not specified, it defaults to [SnackbarType.info].
  /// If [duration] is not specified, it defaults to 1 seconds.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? show({
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 10),
  }) {
    return scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: type.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
