import 'package:flutter/material.dart';

/// The routes used in the app.
class AppRoutes {
  /// The navigator key used in the app.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<T> _getRoute<T>(
    Widget widget, {
    RouteSettings? settings,
    String? name,
  }) {
    settings ??= RouteSettings(name: name);
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => widget,
    );
  }

  ///Push the given route onto the navigator.
  ///
  ///'''dart
  ///AppRoutes.push(
  ///  HomePage(),
  /// );
  /// ```
  static Future<T?>? push<T extends Object?>(Widget page) {
    return navigatorKey.currentState
        ?.push<T>(_getRoute(page, name: page.toString()));
  }

  ///Push the given route and replace the current route in the navigator.
  ///
  ///'''dart
  ///AppRoutes.pushReplacement(
  ///  HomePage(),
  /// );
  static Future<T?>? pushReplacement<T extends Object?, TO extends Object>(
    Widget page, {
    TO? result,
  }) =>
      navigatorKey.currentState?.pushReplacement<T, TO>(
        _getRoute(page, name: page.toString()),
        result: result,
      );

  ///Push the given route onto the navigator, and then remove all the previous
  ///routes until the predicate returns true.
  ///
  ///'''dart
  ///AppRoutes.pushAndRemoveUntil(
  ///  HomePage(),
  /// (route) => false,
  /// );
  static Future<T?>? pushAndRemoveUntil<T extends Object?, TO extends Object>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    predicate ??= (p0) => false;
    return navigatorKey.currentState?.pushAndRemoveUntil<T>(
      _getRoute(page, name: page.toString()),
      predicate,
    );
  }

  ///Pop the current route off the navigator
  ///
  ///
  ///'''dart
  ///AppRoutes.pop();
  /// ```
  static void pop<T extends Object?>() => navigatorKey.currentState?.pop<T>();
}
