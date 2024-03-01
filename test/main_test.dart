import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/main.dart';
import 'package:pawfect_match_app/user_repo.dart';

void main() async {
  group('Main App Functionality Tests', ()
  {
    late InMemoryUserRepository userRepository;

    setUp(() {
      userRepository = InMemoryUserRepository();
      userRepository.addUser(Profile(
        username: 'varun',
        dogName: 'snoopy',
        password: 'password',
        dogBreed: 'Pit Bull',
        dogAge: 2,
        gender: 'Male',
        about: 'I always have my tennis ball in my mouth!',
        phoneNumber: '(123)123-1234',
        image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
      ));
      userRepository.addUser(Profile(
        username: 'baran',
        dogName: 'Marley',
        password: 'password',
        dogBreed: 'Retriever',
        dogAge: 8,
        gender: 'Female',
        about: 'I love long hikes!',
        phoneNumber: '(123)123-1234',
        image: 'lib/Assets/photos/195723497-2024-01-01.jpg',
      ));
    });

    testWidgets('App should load Login screen', (WidgetTester tester) async {
      // Build the app and trigger frame rendering
      await tester.pumpWidget(PawfectMatchApp(userRepository: userRepository));

      // Verify that the Login screen is displayed
      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('App title should be "Pawfect Match App"', (WidgetTester tester) async {
      // Build the app and trigger frame rendering
      await tester.pumpWidget(PawfectMatchApp(userRepository: userRepository));

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'Pawfect Match App');
    });

    testWidgets('App theme should use primary color of blue', (WidgetTester tester) async {
      // Build the app and trigger frame rendering
      await tester.pumpWidget(PawfectMatchApp(userRepository: userRepository));

      // Verify that the primary color is blue
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme!.primaryColor, Color(0xff6750a4));
    });

  });
}