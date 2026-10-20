import 'package:flutter/material.dart';

import 'library_screen.dart';
import 'models/book.dart';

void main() {
  debugPrint('${totalPages(seed)} pages, ${unread(seed).length} unread');
  debugPrint(
    Book.fromMap({'title': 'X', 'author': 'Y', 'pages': 10}).toString(),
  );
  runApp(const ReadingListApp());
}

class ReadingListApp extends StatelessWidget {
  const ReadingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const LibraryScreen(),
    );
  }
}
