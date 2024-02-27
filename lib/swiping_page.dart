import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/profile.dart';
import 'package:pawfect_match_app/report_profile.dart';
import 'package:sqflite/sqflite.dart';

import 'heart_counter.dart';

class SwipingMatchingPage extends StatefulWidget {
  final String dbPath;
  final String userName;

  const SwipingMatchingPage({required this.dbPath, required this.userName, Key? key}) : super(key: key);

  @override
  createState() => _SwipingMatchingPageState();
}

class _SwipingMatchingPageState extends State<SwipingMatchingPage> {
  List<Profile> profiles = [];

  Future<List<Profile>> readProfilesFromDatabase() async {
    print('Reading profiles from database');
    Database database = await openDatabase(widget.dbPath, version: 1);

    // Query the database for all users except self
    final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT username, dogName, image FROM Users WHERE username != ?', [widget.userName]);

    // Convert the List<Map> to a List<User>
    return List.generate(maps.length, (i) {
      return Profile(
        username: maps[i]['username'],
        dogName: maps[i]['dogName'],
        image: maps[i]['image']
      );
    });
  }

  Future setProfiles() async {
    List<Profile> readProfiles;
    if (profiles.isEmpty) {
      readProfiles = await readProfilesFromDatabase();
      await _updateMatchCount();
      setState(() {
        profiles = readProfiles;
      });
    }
  }

  int currentIndex = 0;

  void _swipeLeft(String matchedUser) async {
    Database database = await openDatabase(widget.dbPath, version: 1);
    await database.transaction((txn) async {
      await txn.delete('Matches', where: 'fromUser = ? AND toUser = ?', whereArgs: [widget.userName, matchedUser]);
      await txn.insert('Matches', {
        'fromUser': widget.userName,
        'toUser': matchedUser,
        'liked': false,
      });
    });
    await _updateMatchCount();

    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  void _swipeRight(String matchedUser) async {
    Database database = await openDatabase(widget.dbPath, version: 1);
    await database.transaction((txn) async {
      await txn.delete('Matches', where: 'fromUser = ? AND toUser = ?', whereArgs: [widget.userName, matchedUser]);
      await txn.insert('Matches', {
        'fromUser': widget.userName,
        'toUser': matchedUser,
        'liked': true,
      });
    });
    await _updateMatchCount();

    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  bool animateCount = false;
  int matchCount = 0;

  Future _updateMatchCount() async {
    Database database = await openDatabase(widget.dbPath, version: 1);
    printMatches(database);
    int? count = Sqflite.firstIntValue(
      await database.rawQuery('''
        SELECT COUNT(*)
        FROM Matches m1
        JOIN Matches m2
        ON m1.toUser = m2.fromUser
        WHERE m1.fromUser = ? AND m2.toUser = ? AND m1.liked = true AND m2.liked = true
        ''',
        [widget.userName, widget.userName]));

    animateCount = (matchCount != count!);
    matchCount = count;
  }

  Future<void> printMatches(Database database) async {
    // Fetch all rows from the Matches table
    List<Map<String, dynamic>> matches = await database.query('Matches');

    print('------------');
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //print(profiles[currentIndex].image);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Swiping and Matching'),
              ),
              body: SingleChildScrollView(child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Swipe left or right to match or unmatch'),
                    const SizedBox(height: 30),
                    Dismissible(
                      key: Key(profiles[currentIndex].username),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          String matchedUser = profiles[currentIndex].username;
                          _swipeLeft(matchedUser);
                        } else {
                          String matchedUser = profiles[currentIndex].username;
                          _swipeRight(matchedUser);
                        }
                      },
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              // Displaying user' and dog' names
                              Text('User: ${profiles[currentIndex].username}'),
                              Text('Dog: ${profiles[currentIndex].dogName}'),
                              // Display image (or blank if null)
                              profiles[currentIndex].image != null
                                  ? Image.memory(base64Decode(profiles[currentIndex].image!), width: 330, height: 475,)
                                  : Container(
                                width: 150,
                                height: 150,
                                color: Colors.grey, // Placeholder for blank image
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {_swipeLeft(profiles[currentIndex].username);},
                            child: const Icon(Icons.arrow_back_ios)
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                            onPressed: () {_swipeRight(profiles[currentIndex].username);},
                            child: const Icon(Icons.arrow_forward_ios)
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                            onPressed: () => reportProfile(context),
                            child: const Icon(Icons.report)
                        )
                      ]
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ HeartCounter(count: matchCount, animate: animateCount,) ],
                    ),
                  ],
                ),
              ),
            )
            );
          }
        });
  }
}