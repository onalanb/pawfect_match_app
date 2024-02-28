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
      image: 'image1',
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
      image: 'image2',
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
      image: 'image3',
    ),
  ];

  // Simulates fetching all profiles from the database
  Future<List<Profile>> getAllProfiles() async {
    return Future.value(_mockProfiles);
  }
}