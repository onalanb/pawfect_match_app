import 'package:sqflite/sqflite.dart';
import 'Data/profile.dart';

abstract class UserRepository {
  Future<Profile?> getUser(String username);
  Future<List<Profile>> getProfilesExcludingUser(String userName);
  Future<void> swipeLeft(String fromUser, String toUser);
  Future<void> swipeRight(String fromUser, String toUser);
  Future<int> getMatchCount(String userName);
  Future<List<Profile>>getMatchedProfiles(String userName);
  Future<void>insertProfile(Profile profile);
}

class SQLiteUserRepository implements UserRepository {
  final Database db;

  SQLiteUserRepository(this.db);

  @override
  Future<void> insertProfile(Profile profile) async {
    await db.insert(
      'Profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Profiles created");
  }
  @override
  Future<List<Profile>> getProfilesExcludingUser(String userName) async {
    print("entered Profiles excluding user");
    final List<Map<String, dynamic>> maps = await db.query(
      'Profiles',
      where: 'username != ?',
      whereArgs: [userName],
    );
    return maps.map((map) => Profile.fromMap(map)).toList();
  }

  @override
  Future<Profile?> getUser(String username) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'Profiles',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Profile>> getAllProfiles() async {
    final List<Map<String, dynamic>> result = await db.query('Profiles');
    return result.map((map) => Profile.fromMap(map)).toList();
  }

  @override
  Future<void> swipeLeft(String fromUser, String toUser) async {
    await db.transaction((txn) async {
      await txn.delete('Matches', where: 'fromUser = ? AND toUser = ?', whereArgs: [fromUser, toUser]);
      await txn.insert('Matches', {'fromUser': fromUser, 'toUser': toUser, 'liked': 0});
    });
  }

  @override
  Future<void> swipeRight(String fromUser, String toUser) async {
    await db.transaction((txn) async {
      await txn.delete('Matches', where: 'fromUser = ? AND toUser = ?', whereArgs: [fromUser, toUser]);
      await txn.insert('Matches', {'fromUser': fromUser, 'toUser': toUser, 'liked': 1});
    });
  }

  @override
  Future<List<Profile>> getMatchedProfiles(String userName) async {
    final List<Map<String, dynamic>> matchedProfilesMaps = await db.rawQuery('''
      SELECT p.* FROM Profiles p
      JOIN Matches m1 ON p.username = m1.toUser
      JOIN Matches m2 ON p.username = m2.fromUser
      WHERE m1.fromUser = ? AND m2.toUser = ? AND m1.liked = 1 AND m2.liked = 1
    ''', [userName, userName]);

    print('--------- Matched Profiles for $userName ---------');
    // Print the contents of each row
    for (Map<String, dynamic> matchedProfile in matchedProfilesMaps) {
      for (String key in matchedProfile.keys) {
        print('$key : ${matchedProfile[key]}');
      }
      print('---');
    }

    return List.generate(matchedProfilesMaps.length, (i) {
      return Profile.fromMap(matchedProfilesMaps[i]);
    });
  }

  @override
  Future<int> getMatchCount(String userName) async {
    print(userName);
    await printMatches();
    await printMatchesForUser(userName);
    var result = await db.rawQuery('''
      SELECT COUNT(*)
      FROM Matches m1
      JOIN Matches m2 ON m1.toUser = m2.fromUser AND m1.fromUser = m2.toUser
      WHERE m1.liked = 1 AND m2.liked = 1 AND m1.fromUser = ?
    ''', [userName]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> printMatchesForUser(String userName) async {
    // Fetch all rows from the Matches table
    List<Map<String, dynamic>> matches = await db.rawQuery('''
      SELECT *
      FROM Matches m1
      JOIN Matches m2 ON m1.toUser = m2.fromUser AND m1.fromUser = m2.toUser
      WHERE m1.liked = 1 AND m2.liked = 1 AND m1.fromUser = ?
    ''', [userName]);
    print('--------- Matches for $userName ---------');
    // Print the contents of each row
    for (Map<String, dynamic> match in matches) {
      for (String key in match.keys) {
        print('$key : ${match[key]}');
      }
      print('---');
    }
  }

  Future<void> printMatches() async {
    // Fetch all rows from the Matches table
    List<Map<String, dynamic>> matches = await db.query('Matches');
    print('--------- Entire Matches table ---------');
    // Print the contents of each row
    for (Map<String, dynamic> match in matches) {
      print('Match ID: ${match['id']}');
      print('From User: ${match['fromUser']}');
      print('To User: ${match['toUser']}');
      print('Liked: ${match['liked']}');
      // Add more fields as needed
      print('---');
    }
  }
}


//////////////////////////////////////////////////////////////////////////
////////This Interface uses an in-memory data store instead of a persistent database

class InMemoryUserRepository implements UserRepository {
  final Map<String, Profile> _users = {};
  final Map<String, Set<String>> _likes = {}; // Tracks likes between users

  @override
  Future<Profile?> getUser(String username) async {
    return _users[username];
  }

  @override
  Future<List<Profile>> getProfilesExcludingUser(String userName) async {
    return _users.values.where((profile) => profile.username != userName).toList();
  }

  void addUser(Profile user) {
    _users[user.username] = user;
    _likes[user.username] = {};
  }

  @override
  Future<int> getMatchCount(String userName) async {
    var userLikes = _likes[userName];
    var matchCount = 0;

    if (userLikes != null) {
      for (var like in userLikes) {
        if (_likes[like]?.contains(userName) == true) {
          matchCount++;
        }
      }
    }
    return matchCount;
  }

  @override
  Future<void> swipeLeft(String fromUser, String toUser) async {
  }

  @override
  Future<void> swipeRight(String fromUser, String toUser) async {
    // Records as fromUser likes toUser
    _likes[fromUser]?.add(toUser);
  }

  @override
  Future<List<Profile>> getMatchedProfiles(String userName) async {
    var userLikes = _likes[userName];
    var matchedProfiles = <Profile>[];

    if (userLikes != null) {
      for (var like in userLikes) {
        if (_likes[like]?.contains(userName) == true) {
          var matchedUser = _users[like];
          if (matchedUser != null) {
            matchedProfiles.add(matchedUser);
          }
        }
      }
    }
    return matchedProfiles;
  }

  @override
  insertProfile(Profile profile) async {
    addUser(profile);
  }
}