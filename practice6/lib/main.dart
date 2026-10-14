import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'edit_screen.dart';
import 'routes.dart';
import 'students.dart';
import 'students_screen.dart';

void main() => runApp(const Practice6App());

class Practice6App extends StatelessWidget {
  const Practice6App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Students',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    initialRoute: Routes.students,
    routes: {Routes.students: (_) => const StudentsScreen()},
    onGenerateRoute: (settings) {
      final argument = settings.arguments;
      if (settings.name == Routes.student && argument is Student) {
        return MaterialPageRoute<void>(
          builder: (_) => DetailScreen(student: argument),
        );
      }
      if (settings.name == Routes.edit && argument is Student) {
        return MaterialPageRoute<String>(
          builder: (_) => EditScreen(student: argument),
        );
      }
      return null;
    },
  );
}
