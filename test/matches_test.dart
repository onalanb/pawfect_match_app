import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/matches.dart';
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

    testWidgets('Matches widget shows "No matches yet" when no profiles are available', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Matches(
          userRepository: userRepository,
          userName: 'varun',
        ),
      ));

      // There is no mutual liking between varun and baran
      await tester.pumpWidget(Matches(userRepository: userRepository, userName: 'varun'));
      expect(find.text('User: baran'), findsNothing);
    });

    // testWidgets('Matches widget displays profile information when profiles are available', (WidgetTester tester) async {
    //   await tester.pumpWidget(MaterialApp(
    //     home: Matches(
    //       userRepository: userRepository,
    //       userName: 'varun',
    //     ),
    //   ));
    //
    //   // Verify that profile information is displayed
    //   expect(find.text('User: baran'), findsOneWidget);
    //   expect(find.text('Dog: Marley'), findsOneWidget);
    //
    //   // Swipe to next profile
    //   await tester.tap(find.byType(ElevatedButton).at(1)); // Tap Next button
    //   await tester.pumpAndSettle();
    //
    //   // Verify that profile information of the next profile is displayed
    //   expect(find.text('User: user2'), findsOneWidget);
    //   expect(find.text('Dog: Dog2'), findsOneWidget);
    //   expect(find.text('Breed: Breed2'), findsOneWidget);
    //   expect(find.text('Age: 5'), findsOneWidget);
    //   expect(find.text('Gender: Female'), findsOneWidget);
    //   expect(find.text('About me: About Dog2'), findsOneWidget);
    //   expect(find.text('Contact me: 9876543210'), findsOneWidget);
    // });

  });
}