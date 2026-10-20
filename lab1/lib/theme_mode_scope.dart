import 'package:flutter/material.dart';

class ThemeModeScope extends InheritedWidget {
  const ThemeModeScope({
    super.key,
    required this.themeMode,
    required super.child,
  });

  final ThemeMode themeMode;

  static ThemeMode of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
    assert(scope != null, 'ThemeModeScope was not found above this context.');
    return scope!.themeMode;
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) =>
      themeMode != oldWidget.themeMode;
}
