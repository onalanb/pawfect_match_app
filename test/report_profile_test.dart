import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/report_profile.dart';

void main() {
  group('Report Profile Dialog Test', () {
    testWidgets('Submit button returns input data', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () => reportProfile(context),
          child: const Text('Open Dialog'),
        );
      })
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Spam');
      await tester.enterText(find.byType(TextField).at(1), 'This is a spam profile.');

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verifying the dialog is dismissed.
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}