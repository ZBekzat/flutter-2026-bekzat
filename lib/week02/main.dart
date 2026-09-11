// ignore_for_file: avoid_print

import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();

  library.open();

  for (final rawBook in rawBooks) {
    library.add(Book.fromJson(rawBook));
  }

  print('=== QUERIES ===');

  print('Titles: ${library.titles}');

  print('Books after 2010: ${library.booksAfter2010}');

  print('Average pages: ${library.averagePages}');

  print('Books by author: ${library.booksByAuthor}');

  print('Author names: ${library.authorNames}');

  print('Genres: ${library.genres}');

  print('\n=== DISPLAY LIST ===');

  for (final line in library.displayList) {
    print(line);
  }

  print('\n=== COUNTRY ===');

  print('Clean Code: ${library.countryOf('Clean Code')}');
  print('Design Patterns: ${library.countryOf('Design Patterns')}');

  print('\n=== STATS ===');

  final books = library.items.whereType<Book>().toList();
  final stats = statsOf(books);

  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  print('\n=== SHELF STATES ===');

  print(describe(Empty()));
  print(describe(Ready(books)));
  print(describe(Broken('Database connection failed')));
}
