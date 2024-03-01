import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/create_profile.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'package:provider/provider.dart';

void main() {
  group('Login Widget Tests', () {
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

    Widget makeTestableWidget() => MaterialApp(
      home: Provider<UserRepository>(
        create: (context) => userRepository,
        child: Login(userRepository: userRepository),
      ),
    );

    testWidgets('Renders login widgets and accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      expect(find.text('Welcome to Pawfect'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'varun');
      await tester.enterText(find.byType(TextField).last, 'password');

      await tester.tap(find.text('SignUp'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileCreationPage), findsOneWidget);
    });
  });
}