import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/ui/splash_screen.dart';
import 'package:flutter_assignment/src/utils/routes.dart';
import 'package:flutter_assignment/src/utils/snackbar.dart';
import 'package:flutter_assignment/src/utils/theme.dart';

/// The root widget of the application.
class TodoApp extends StatelessWidget {
  /// Constructor for the [TodoApp] widget.
  /// Creates a new [TodoApp] instance.
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          themeMode: appTheme.themeMode,
          theme: appTheme.lightTheme(lightColorScheme),
          darkTheme: appTheme.darkTheme(darkColorScheme),
          themeAnimationCurve: Curves.fastEaseInToSlowEaseOut,
          themeAnimationDuration: const Duration(milliseconds: 700),
          scaffoldMessengerKey: SnackbarUtils.scaffoldMessengerKey,
          navigatorKey: AppRoutes.navigatorKey,
          scrollBehavior: const CupertinoScrollBehavior(),
          home: const ConnectivityWidgetWrapper(
            alignment: Alignment.bottomCenter,
            message: 'No Internet Connection',
            child: SplashScreen(),
          ),
        );
      },
    );
  }
}
