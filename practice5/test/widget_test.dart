import 'package:flutter_test/flutter_test.dart';
import 'package:practice5/main.dart';

void main() {
  testWidgets('contacts screen displays its heading and first contact', (
    tester,
  ) async {
    await tester.pumpWidget(const ContactsApp());

    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('20 contacts'), findsOneWidget);
    expect(find.text('Aida Akhmetova'), findsOneWidget);
  });
}
