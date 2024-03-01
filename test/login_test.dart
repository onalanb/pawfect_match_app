import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/user_repo.dart';

void main() {
  group('Login Functionality Tests', () {
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

    test('Successful login with correct credentials', () async {
      const username = 'varun';
      const password = 'password';

      // fetching username
      final user = await userRepository.getUser(username);

      expect(user, isNotNull);

      // If the user is found, then checking the password
      if (user != null) {
        expect(user.password, equals(password));
      }
    });

    test('Failed login with incorrect username', () async {
      const username = 'varuntej';

      // fetching the user by username
      final user = await userRepository.getUser(username);

      //user does not found
      expect(user, isNull);
    });
  });
}