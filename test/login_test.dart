
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/create_profile.dart';

void main(){
  testWidgets("Testing Widgets in Login page", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Login(),
    ));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsExactly(1));
    expect(find.byType(TextButton), findsExactly(1));

    await tester.enterText(find.byType(TextField).at(0), "varuntej07");
    await tester.enterText(find.byType(TextField).at(1), "weakpassword");

    expect(find.text("varuntej07"), findsOneWidget);
    expect(find.text("weakpassword"), findsOneWidget);

    await tester.tap(find.text('SignUp'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileCreationPage), findsOneWidget);
  });
}