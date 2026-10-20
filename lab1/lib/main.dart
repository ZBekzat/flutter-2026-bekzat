import 'package:flutter/material.dart';

void main() {
  runApp(const PaceMateApp());
}

class PaceMateApp extends StatelessWidget {
  const PaceMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaceMate',
      theme: ThemeData(),
      home: const Scaffold(
        body: Center(child: Text('PaceMate — running club')),
      ),
    );
  }
}
