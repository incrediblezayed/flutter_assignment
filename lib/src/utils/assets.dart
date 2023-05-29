import 'package:flutter/material.dart';

/// The assets used in the app.
class Assets {
  /// Image for the first onboarding page.
  static String onboarding1(Brightness brightness) =>
      'assets/images/${brightness.name}/onboarding_1.png';

  /// Image for the second onboarding page.
  static String onboarding2(Brightness brightness) =>
      'assets/images/${brightness.name}/onboarding_2.png';

  /// Image for the no todos page.
  static const String noTodos = 'assets/images/shared/no_todos.png';

  /// Google Logo
  static const String google = 'assets/images/shared/google.png';

  /// Calendar Logo.
  static const String calendar = 'assets/images/shared/calendar.png';
}
