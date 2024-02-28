class Profile {
  final String username;
  final String dogName;
  final String? password;
  final String? dogBreed;
  final int? dogAge;
  final String? gender;
  final String? about;
  final String? image;
  final String? phoneNumber;

  Profile({
    required this.username,
    required this.dogName,
    this.password,
    this.dogBreed,
    this.dogAge,
    this.gender,
    this.about,
    this.image,
    this.phoneNumber,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'dogName': dogName,
      'password': password,
      'dogBreed': dogBreed,
      'dogAge': dogAge,
      'gender': gender,
      'about':about,
      'image': image,
      'phoneNumber': phoneNumber
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
        username: map['username'],
        dogName: map['dogName'],
        password: map['password'],
        dogBreed:map['dogBreed'],
        dogAge:map['dogAge'],
        gender: map['gender'],
        about: map['about'],
        image: map['image'],
        phoneNumber: map['phoneNumber']
    );
  }
}