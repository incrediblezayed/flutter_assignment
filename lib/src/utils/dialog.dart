import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/utils/routes.dart';

/// A class that contains methods to show dialogs.
class AppDialog {
  /// Shows a dialog with the given child.
  static Future<T?> showBottomSheet<T>({
    required Widget Function(BuildContext context) child,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext!;
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      builder: child,
    );
  }

  /// Shows a dialog with the given child.
  static Future<T?> showLoading<T>() {
    final context = AppRoutes.navigatorKey.currentContext!;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: SizedBox.square(
              dimension: MediaQuery.of(context).size.width * 0.2,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Loading...',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
