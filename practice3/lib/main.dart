import 'package:flutter/material.dart';

import 'data.dart';
import 'info_row.dart';
import 'profile_header.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My profile')),
        body: ListView(
          children: [
            const ProfileHeader(name: myName, university: myUniversity),
            ...facts.map(
              (fact) => InfoRow(label: fact.label, value: fact.value),
            ),
          ],
        ),
      ),
    );
  }
}
