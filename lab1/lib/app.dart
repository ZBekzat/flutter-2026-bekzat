import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'routes.dart';
import 'theme_mode_scope.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaceMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorScheme.light().primary,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorScheme.light().primary,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      builder: (context, child) => ThemeModeScope(
        themeMode: _themeMode,
        child: child ?? const SizedBox.shrink(),
      ),
      routes: {
        AppRoutes.home: (context) =>
            AppShell(onThemeModeChanged: _changeThemeMode),
      },
      initialRoute: AppRoutes.home,
    );
  }
}
