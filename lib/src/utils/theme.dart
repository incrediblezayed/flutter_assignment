import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/providers/storage_provider.dart';
import 'package:provider/provider.dart';

/// This file contains the theme data for the app.
class AppTheme extends ChangeNotifier {
  /// Constructor for the [AppTheme] class.
  ///
  /// It initializes the [themeMode] from the [StorageProvider].
  AppTheme(BuildContext context) {
    _storageProvider = StorageProvider.of(context, listen: false);
    final themeMode = _storageProvider.getThemeMode();
    _themeMode = themeMode;
  }

  late StorageProvider _storageProvider;

  //final Color _primaryColor = const Color(0xFF24A19C);

  /// Returns the light theme data.
  ThemeData lightTheme(ColorScheme? colorScheme) => ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: colorScheme,
        primaryColor: colorScheme?.primary,
        primaryColorDark: colorScheme?.primaryContainer,
        primaryColorLight: colorScheme?.primary,
        //primaryColor: _primaryColor,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            //  color: _primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
          },
        ),
      );

  /// Returns the light theme data.
  ThemeData darkTheme(ColorScheme? colorScheme) => ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: colorScheme,
        primaryColor: colorScheme?.primary,
        primaryColorDark: colorScheme?.primaryContainer,
        primaryColorLight: colorScheme?.primary,
        scaffoldBackgroundColor: colorScheme?.background,

        //   primaryColor: _primaryColor,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            //  color: _primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.white60,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
          },
        ),
      );

  ThemeMode _themeMode = ThemeMode.system;

  /// Returns the current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// sets the [themeMode] to the given [themeMode].
  void setThemeMode(ThemeMode themeMode, BuildContext context) {
    _themeMode = themeMode;
    _storageProvider.setThemeMode(themeMode);
    notifyListeners();
  }

  /// Toggles the theme mode.
  /// If the current theme mode is [ThemeMode.system], it will change to
  /// [ThemeMode.light].
  ///
  /// If the current theme mode is [ThemeMode.light], it will change to
  /// [ThemeMode.dark].
  ///
  /// If the current theme mode is [ThemeMode.dark], it will change to
  /// [ThemeMode.system].
  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  /// Returns the string representation of the current theme mode.
  String themeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  /// Returns the icon data of the current theme mode.
  IconData themeModeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return Icons.brightness_4_outlined;
      case ThemeMode.light:
        return Icons.brightness_1;
      case ThemeMode.dark:
        return Icons.brightness_3;
    }
  }

  /// Returns the [AppTheme] instance from the [context].
  /// If [listen] is true, it will rebuild the widget when the theme changes.
  /// If [listen] is false, it will not rebuild the widget when the theme change
  static AppTheme of(BuildContext context, {bool listen = true}) =>
      Provider.of<AppTheme>(context, listen: listen);
}
