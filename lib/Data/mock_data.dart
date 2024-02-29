import 'package:pawfect_match_app/Data/profile.dart';

class MockProfileDao {
  // Mock data
  final List<Profile> _mockProfiles = [
    Profile(
      username: 'baran',
      dogName: 'Marley',
      password: 'password',
      dogBreed: 'Black Lab',
      dogAge: 8,
      gender: 'Female',
      about: 'I love going on long walks on trails and jumping around in the mud!',
      phoneNumber: '(123)123-1234',
      image: 'lib/Assets/photos/195744883-2024-01-04.jpg',
    ),
    Profile(
      username: 'james',
      dogName: 'Leo',
      password: 'password',
      dogBreed: 'Golden Retriever',
      dogAge: 5,
      gender: 'Male',
      about: 'I like long naps in the sun and taking breaks during my walks, I get tired easily... zzzzZzz',
      phoneNumber: '(123)123-1234',
      image: 'lib/Assets/photos/195756450-2023-12-17.jpg',
    ),
    Profile(
      username: 'varun',
      dogName: 'Momo',
      password: 'password',
      dogBreed: 'Sarabi',
      dogAge: 12,
      gender: 'Male',
      about: 'I always have my tennis ball in my mouth, let\'s play fetch! I\'m old so I might be slow, so please be patient with me!',
      phoneNumber: '(123)123-1234',
      image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
    ),
  ];

  List<Profile> get mockProfiles => _mockProfiles;

  Future<List<Profile>> getAllProfiles() async {
    return Future.value(_mockProfiles);
  }
}
