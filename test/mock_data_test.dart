import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/Data/mock_data.dart';

void main() {
  group('MockProfileDao Tests', () {
    late MockProfileDao mockProfileDao;

    setUp(() {
      mockProfileDao = MockProfileDao();
    });

    test('getAllProfiles returns a list of mock profiles', () async {
      final profiles = await mockProfileDao.getAllProfiles();

      expect(profiles, isA<List<Profile>>());
      expect(profiles.length, mockProfileDao.mockProfiles.length);

      expect(profiles.first.username, 'baran');
      expect(profiles.first.dogName, 'Marley');
      expect(profiles.first.password, 'password');
      expect(profiles.first.dogBreed, 'Black Lab');
      expect(profiles.first.dogAge, 8);
      expect(profiles.first.gender, 'Female');
      expect(profiles.first.about, 'I love going on long walks on trails and jumping around in the mud!');
      expect(profiles.first.phoneNumber, '(123)123-1234');
      expect(profiles.first.image, 'lib/Assets/photos/195744883-2024-01-04.jpg');

      for (var i = 0; i < profiles.length; i++) {
        final profile = profiles[i];
        final expectedProfile = mockProfileDao.mockProfiles[i];

        expect(profile.username, expectedProfile.username);
        expect(profile.dogName, expectedProfile.dogName);
        expect(profile.password, expectedProfile.password);
        expect(profile.dogBreed, expectedProfile.dogBreed);
        expect(profile.dogAge, expectedProfile.dogAge);
        expect(profile.gender, expectedProfile.gender);
        expect(profile.about, expectedProfile.about);
        expect(profile.phoneNumber, expectedProfile.phoneNumber);
        expect(profile.image, expectedProfile.image);
      }
    });
  });
}
