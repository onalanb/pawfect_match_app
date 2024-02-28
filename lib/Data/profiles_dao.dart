import 'package:pawfect_match_app/Data/profile.dart';

class ProfileDAO {
  Future<void> insertProfile(Profile profile) async {
    // Converting Profile to a map and insert it into the database
  }

  Future<List<Profile>?> getProfiles() async {
    // should query the database and convert the result to a list of Profile objects
    return null;
  }

// will add methods for updating and deleting profiles as needed
}
