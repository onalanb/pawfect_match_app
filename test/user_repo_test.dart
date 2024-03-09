import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'package:sqflite/sqlite_api.dart';

// Manually created mock class for Database
class MockDatabase extends Fake implements Database {
  @override
  Future<int> insert(String table, Map<String, dynamic> values, {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async {
    expect(table, 'Profiles');
    expect(values.containsKey('username'), isTrue);
    return 1;
  }
}

void main() {
  group('SQLiteUserRepository Tests', () {
    late SQLiteUserRepository userRepository;
    late MockDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockDatabase();
      userRepository = SQLiteUserRepository(mockDatabase);
    });

    test('insertProfile adds a profile to the database', () async {
      final profile = Profile(
        username: 'testUser',
        dogName: 'Rex',
        password: 'secret',
        dogBreed: 'Labrador',
        dogAge: 3,
        gender: 'Male',
        about: 'Loves playing fetch',
        image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
        phoneNumber: '1234567890',
      );

      // Act
      await userRepository.insertProfile(profile);
    });
  });
}
