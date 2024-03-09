import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/matches.dart';
import 'package:pawfect_match_app/user_repo.dart';

void main() {
  group('Matches Tests', () {
    late InMemoryUserRepository userRepository;
    late Profile profile1;
    late Profile profile2;

    setUp(() {
      userRepository = InMemoryUserRepository();
      profile1 = Profile(
        username: 'varun',
        dogName: 'snoopy',
        password: 'password',
        dogBreed: 'Pit Bull',
        dogAge: 2,
        gender: 'Male',
        about: 'Loves fetch',
        phoneNumber: '123-456-7890',
        image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
      );

      profile2 = Profile(
        username: 'baran',
        dogName: 'Marley',
        password: 'password',
        dogBreed: 'Retriever',
        dogAge: 8,
        gender: 'Female',
        about: 'Loves hikes',
        phoneNumber: '123-456-7891',
        image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
      );

      userRepository.addUser(profile1);
      userRepository.addUser(profile2);
      userRepository.swipeRight('varun', 'baran');
      userRepository.swipeRight('baran', 'varun');
    });

    Widget createTestWidget() => MaterialApp(
      home: Matches(userRepository: userRepository, userName: 'varun'),
    );



    testWidgets('Previous and next buttons cycle through matches', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('User: baran'), findsOneWidget);

      await tester.tap(find.text('Prev'));
      await tester.pump();

      expect(find.text('User: baran'), findsOneWidget);
    });

    testWidgets('Tapping info icon shows profile details', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pump();
    });
  });
}
