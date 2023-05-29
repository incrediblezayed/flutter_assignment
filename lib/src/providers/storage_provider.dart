import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This file contains the theme data for the app.
class StorageProvider extends ChangeNotifier {
  /// Constructor for the [StorageProvider] class.
  StorageProvider() {
    _initSharedPreferences();
  }

  bool _isInitialized = false;

  /// Returns true if the [StorageProvider] is initialized.
  bool get isInitialized => _isInitialized;

  final String _themeModeKey = 'theme_mode';

  final String _accessTokenKey = 'access_token';

  late SharedPreferences _sharedPreferences;

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _isInitialized = true;
    notifyListeners();
  }

  /// Returns the current theme mode.
  ThemeMode getThemeMode() {
    final themeModeIndex = _sharedPreferences.getInt(_themeModeKey);
    if (themeModeIndex == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values[themeModeIndex];
  }

  /// sets the [themeMode] to the given [themeMode].
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.setInt(_themeModeKey, themeMode.index);
  }

  /// Returns the access token.
  String getAccessToken() {
    return _sharedPreferences.getString(_accessTokenKey) ?? '';
  }

  /// Sets the [accessToken] to the given [accessToken].
  Future<void> setAccessToken(String accessToken) async {
    await _sharedPreferences.setString(_accessTokenKey, accessToken);
  }

  /// Returns the [StorageProvider] instance from the [context].
  static StorageProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<StorageProvider>(context, listen: listen);
}
