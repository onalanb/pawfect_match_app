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
      //await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Create Profile'), findsOneWidget);

      expect(find.byType(TextFormField), findsNWidgets(7));
      expect(find.byType(ElevatedButton), findsNWidgets(3));

      expect(find.byKey(ProfileCreationPageState.formKey), findsOneWidget);
      final Form formWidget = tester.widget(find.byKey(ProfileCreationPageState.formKey));
      final Column column = formWidget.child as Column;
      expect(find.text('SignUp'), findsOneWidget);
      expect((column.children[1] as TextFormField).controller!.text, ''); // Create username
      expect((column.children[2] as TextFormField).controller!.text, ''); // Create password
      expect(find.text("Dog's Information"), findsOneWidget);
      expect((column.children[5] as TextFormField).controller!.text, ''); // Dog's name
      expect((column.children[6] as TextFormField).controller!.text, ''); // Dog's breed
      expect((column.children[8] as TextFormField).controller!.text, ''); // About
      expect((column.children[9] as TextFormField).controller!.text, ''); // Phone number

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

      tester.tap(find.byType(ElevatedButton).at(2));
      await tester.pumpAndSettle();

      expect(find.text("Welcome to Pawfect"), findsOneWidget);
    });

    testWidgets("Testing form validators show error messages when fields are empty", (WidgetTester tester) async {
      final mockUserRepository = MockUserRepository();

      await tester.pumpWidget(MaterialApp(
        home: ProfileCreationPage(userRepository: mockUserRepository),
      ));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pump();

      expect(find.text('Please enter a username'), findsOneWidget);
      expect(find.text('Please create a password'), findsOneWidget);
      expect(find.text('Please enter Dog name'), findsOneWidget);
      expect(find.text('Please enter your Dog breed'), findsOneWidget);
      expect(find.text("Please enter your Dog age"), findsOneWidget);
      expect(find.text("Please share something about your dog"), findsOneWidget);
      expect(find.text("Please enter your phone number"), findsOneWidget);
    });

    testWidgets("Ensure initial UI state has no error messages displayed", (WidgetTester tester) async {
      final mockUserRepository = MockUserRepository();

      await tester.pumpWidget(MaterialApp(
        home: ProfileCreationPage(userRepository: mockUserRepository),
      ));

      // Check that no error messages are displayed initially
      expect(find.text('Please enter a username'), findsNothing);
      expect(find.text('Please create a password'), findsNothing);
      expect(find.text('Please enter Dog name'), findsNothing);
      expect(find.text('Please enter your Dog breed'), findsNothing);
      expect(find.text("Please enter your Dog age"), findsNothing);
      expect(find.text("Please share something about your dog"), findsNothing);
      expect(find.text("Please enter your phone number"), findsNothing);
    });
  });
}