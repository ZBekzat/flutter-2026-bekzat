import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'routes.dart';
import 'screens/not_found_screen.dart';
import 'screens/run_details_screen.dart';
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
        Routes.home: (context) =>
            AppShell(onThemeModeChanged: _changeThemeMode),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.runDetails) {
          final arguments = settings.arguments;
          if (arguments is RunDetailsArguments) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => RunDetailsScreen(arguments: arguments),
            );
          }
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => const NotFoundScreen(),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const NotFoundScreen(),
      ),
      initialRoute: Routes.home,
    );
  }
}
