import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    return items.whereType<Book>().where((book) => book.title == title).firstOrNull;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  late final DateTime openedAt;

  void open() {
    openedAt = DateTime.now();
  }

  String? _cachedReport;

  String get report => _cachedReport ??= displayList.join('\n');

  List<String> get titles =>
      items.whereType<Book>().map((book) => book.title).toList();

  List<Book> get booksAfter2010 =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  double get averagePages {
    final books = items.whereType<Book>().toList();

    if (books.isEmpty) {
      return 0;
    }

    // fold is used because the task specifically requires fold for the sum.
    final total = books.fold<int>(
      0,
      (sum, book) => sum + book.pages,
    );

    return total / books.length;
  }

  Map<String, int> get booksByAuthor => items
      .whereType<Book>()
      .fold<Map<String, int>>(
        {},
        (map, book) => {
          ...map,
          book.author.name: (map[book.author.name] ?? 0) + 1,
        },
      );

  Set<String> get authorNames =>
      items.whereType<Book>().map((book) => book.author.name).toSet();

  Set<Genre> get genres =>
      items.whereType<Book>().map((book) => book.genre).toSet();

  List<String> get displayList => [
        'CATALOGUE',
        ...items.whereType<Book>().map(
              (book) => '${book.title} (${book.year})',
            ),
        ...authorNames,
        if (items.whereType<Book>().any((book) => book.pages == 0))
          '(incomplete data)',
      ];
}