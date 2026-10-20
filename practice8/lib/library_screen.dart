import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((book) => book.read).toList(),
  };

  void _toggle(Book book) {
    setState(() => book.read = !book.read);
  }

  Future<void> _openDetails(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );
    if (!mounted) return;

    switch (action) {
      case null:
        break;
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context)
        .push<Book>(MaterialPageRoute(builder: (_) => const AddBookScreen()));
    if (!mounted || book == null) return;
    setState(() => _books.add(book));
  }

  Widget _stat(String label, int value) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text('$value', style: textTheme.headlineSmall),
          Text(label, style: textTheme.bodySmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    _stat('Books', _books.length),
                    _stat('Pages', totalPages(_books)),
                    _stat('Unread', unread(_books).length),
                  ],
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                _filterChip('All', Filter.all),
                _filterChip('Unread', Filter.unread),
                _filterChip('Read', Filter.read),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                itemCount: _visible.length,
                itemBuilder: (context, index) {
                  final book = _visible[index];
                  return BookTile(
                    book: book,
                    onToggle: () => _toggle(book),
                    onTap: () => _openDetails(book),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Add book',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String label, Filter filter) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == filter,
      onSelected: (_) => setState(() => _filter = filter),
    );
  }
}
