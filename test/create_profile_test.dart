import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/create_profile.dart';

void main(){
  testWidgets("Testing SignUp page for users to be able to enter info ", (WidgetTester tester) async{
    await tester.pumpWidget(const MaterialApp(
        home:ProfileCreationPage(dbPath: '')
    ));

    expect(find.byType(Scaffold), findsOneWidget);

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Create Profile'), findsOneWidget);

    expect(find.byType(TextFormField), findsNWidgets(7));
    expect(find.byType(ElevatedButton), findsNWidgets(3));

    const String age = '2';
    const String contact = '911';

    await tester.enterText(find.byType(TextFormField).at(0), "varuntej07");
    await tester.enterText(find.byType(TextFormField).at(1), "weakpassword");
    await tester.enterText(find.byType(TextFormField).at(2), "Snoopy");
    await tester.enterText(find.byType(TextFormField).at(3), "Rottweiler");
    await tester.enterText(find.byType(TextFormField).at(4), contact);
    await tester.enterText(find.byType(TextFormField).at(5), age);
    await tester.enterText(find.byType(TextFormField).at(6), "Pissing off people");

    expect(find.text("varuntej07"), findsOneWidget);
    expect(find.text("weakpassword"), findsOneWidget);
    expect(find.text("Snoopy"), findsOneWidget);
    expect(find.text("Rottweiler"), findsOneWidget);
    expect(find.text(contact), findsOneWidget);
    expect(find.text(age), findsOneWidget);
    expect(find.text("Pissing off people"), findsOneWidget);
  });
}