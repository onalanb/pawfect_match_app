class Profile {
  final String username;
  final String dogName;
  final String? password;
  final String? dogBreed;
  final int? dogAge;
  final String? gender;
  final String? about;
  final String? image;

  // For Create Profile
  Profile({
    required this.username,
    required this.dogName,
    this.password,
    this.dogBreed,
    this.dogAge,
    this.gender,
    this.about,
    this.image,
  });
}