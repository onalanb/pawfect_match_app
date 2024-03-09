import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'package:provider/provider.dart';

void main() {
  group('Login Tests', () {
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
    });

    Widget makeTestableWidget({required UserRepository userRepository}) => MaterialApp(
      home: Provider<UserRepository>(
        create: (context) => userRepository,
        child: Login(userRepository: userRepository),
      ),
    );

    testWidgets('Renders login widgets and accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(userRepository: userRepository));

      expect(find.text('Welcome to Pawfect'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'varun');
      await tester.enterText(find.byType(TextField).last, 'password');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('Login button shows dialog on empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(userRepository: userRepository));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // AlertDialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Login Failed'), findsOneWidget);

      // Clear AlertDialog with OK.
      await tester.tap(find.text('OK'));
      await tester.pump(); // Trigger a dismiss to AlertDialog
    });

    test('Successful login with correct credentials', () async {
      const username = 'varun';
      const password = 'password';
      final user = await userRepository.getUser(username);
      expect(user, isNotNull);
      expect(user?.password, equals(password));
    });

    test('Failed login with incorrect username', () async {
      const username = 'varuntej';
      final user = await userRepository.getUser(username);
      expect(user, isNull);
    });
  });
}
