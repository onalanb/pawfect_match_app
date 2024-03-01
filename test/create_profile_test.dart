import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pawfect_match_app/create_profile.dart';
import 'package:pawfect_match_app/user_repo.dart';
class MockUserRepository extends Mock implements UserRepository {}
void main() {
  group('ProfileCreationPage Tests', () {
    testWidgets("Testing SignUp page for users to be able to enter info", (WidgetTester tester) async {
      final mockUserRepository = MockUserRepository();
      await tester.pumpWidget(MaterialApp(
        home: ProfileCreationPage(userRepository: mockUserRepository),
      ));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Create Profile'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(7));
      expect(find.byType(ElevatedButton), findsNWidgets(3));
      await tester.enterText(find.byType(TextFormField).at(0), "varuntej07"); // username
      await tester.enterText(find.byType(TextFormField).at(1), "weakpassword"); // password
      await tester.enterText(find.byType(TextFormField).at(2), "Snoopy"); // dog's name
      await tester.enterText(find.byType(TextFormField).at(3), "Rottweiler"); // dog's breed
      await tester.enterText(find.byType(TextFormField).at(4), "2"); // dog's age
      await tester.enterText(find.byType(TextFormField).at(5), "Pissing off people"); // about the dog
      await tester.enterText(find.byType(TextFormField).at(6), "911"); // phone number
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      var genderDropdownItem = find.text('Male').last;
      await tester.tap(genderDropdownItem);
      await tester.pumpAndSettle();
      expect(find.text("varuntej07"), findsOneWidget);
      expect(find.text("weakpassword"), findsOneWidget);
      expect(find.text("Snoopy"), findsOneWidget);
      expect(find.text("Rottweiler"), findsOneWidget);
      expect(find.text("2"), findsOneWidget);
      expect(find.text("Pissing off people"), findsOneWidget);
      expect(find.text("911"), findsOneWidget);
      expect(find.text('Male'), findsWidgets);
    });
    testWidgets("Testing form validators show error messages when fields are empty", (WidgetTester tester) async {
      final mockUserRepository = MockUserRepository();
      await tester.pumpWidget(MaterialApp(
        home: ProfileCreationPage(userRepository: mockUserRepository),
      ));
// Attempt to save the profile without entering any information
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pump(); // This call is necessary to ensure that any async work is completed before moving on.
// Check if error messages are shown for each TextFormField
      expect(find.text('Please enter a username'), findsOneWidget);
      expect(find.text('Please create a password'), findsOneWidget);
      expect(find.text('Please enter Dog name'), findsOneWidget);
      expect(find.text('Please enter your Dog breed'), findsOneWidget);
      expect(find.text("Please enter your Dog age"), findsOneWidget);
      expect(find.text("Please share something about your dog"), findsOneWidget);
      expect(find.text("Please enter your phone number"), findsOneWidget);
// This assumes you have specified these exact error messages in your TextFormField validators.
    });
  });
}