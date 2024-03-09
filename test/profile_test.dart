import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';

void main() {
  group('Profile Model Tests', () {
    test('Profile.toMap() returns a correct map representation', () {
      final profile = Profile(
        username: 'testUser',
        dogName: 'Buddy',
        password: 'password123',
        dogBreed: 'Golden Retriever',
        dogAge: 5,
        gender: 'Male',
        about: 'Loves playing fetch',
        image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
        phoneNumber: '123-456-7890',
      );

      final profileMap = profile.toMap();

      expect(profileMap, isA<Map<String, dynamic>>());
      expect(profileMap['username'], 'testUser');
      expect(profileMap['dogName'], 'Buddy');
    });

    test('Profile.fromMap() correctly initializes from map representation', () {
      final Map<String, dynamic> profileMap = {
        'username': 'testUser',
        'dogName': 'Buddy',
      };

      final profile = Profile.fromMap(profileMap);

      expect(profile, isA<Profile>());
      expect(profile.username, 'testUser');
      expect(profile.dogName, 'Buddy');
    });
  });
}
