import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/profile.dart';
import 'package:sqflite/sqflite.dart';

class Matches extends StatefulWidget {
  final String dbPath;
  final String userName;

  const Matches({required this.dbPath, required this.userName, Key? key}) : super(key: key);

  @override
  createState() => MatchesPageState();
}

class MatchesPageState extends State<Matches> {
  List<Profile> profiles = [];

  Future<List<Profile>> readProfilesFromDatabase() async {
    print('Reading profiles from database');
    Database database = await openDatabase(widget.dbPath, version: 1);

    // Query the database for all users except self
    final List<Map<String, dynamic>> maps = await database.rawQuery('''
        SELECT 
        *
        FROM Matches m1
        JOIN Matches m2
        ON m1.toUser = m2.fromUser
        JOIN Users u
        ON m1.toUser = u.username
        WHERE m1.fromUser = ? AND m2.toUser = ? AND m1.liked = true AND m2.liked = true
        ''',
        [widget.userName, widget.userName]);

    // Convert the List<Map> to a List<User>
    return List.generate(maps.length, (i) {
      return Profile(
        username: maps[i]['username'],
        dogName: maps[i]['dogName'],
        dogBreed: maps[i]['dogBreed'],
        dogAge: maps[i]['dogAge'],
        gender: maps[i]['gender'],
        about: maps[i]['about'],
        phoneNumber: maps[i]['phoneNumber'],
        image: maps[i]['image'],
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

  void _previous() async {
    setState(() {
      currentIndex = (currentIndex - 1) % profiles.length;
      if (currentIndex < 0) {
        currentIndex = profiles.length - 1;
      }
    });
  }

  void _next() async {
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

  // This is for debugging purposes
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
      print('Phone Number: ${match['phoneNumber']}');
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
                  title: Text('$matchCount Matches'),
                ),
                body: SingleChildScrollView(child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Click info icon for my phone number!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 30),
                      Dismissible(
                        key: Key(profiles[currentIndex].username),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            _previous();
                          } else {
                            _next();
                          }
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Displaying user and dog names
                                    Text('User: ${profiles[currentIndex].username}'),
                                    Text('Dog: ${profiles[currentIndex].dogName}'),
                                    // Display image (or blank if null)
                                    profiles[currentIndex].image != null
                                        ? Image.memory(
                                      base64Decode(profiles[currentIndex].image!),
                                      width: 330,
                                      height: 475,
                                    )
                                        : Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.grey, // Placeholder for blank image
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(Icons.info),
                                  onPressed: () {
                                    // Show pop-up dialog with information
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(profiles[currentIndex].dogName),
                                          content: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: Colors.black, fontSize: 20), // Set the default text color and font size
                                              children: [
                                                const TextSpan(text: 'Breed: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: '${profiles[currentIndex].dogBreed ?? ""}\n'),
                                                const TextSpan(text: 'Age: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: '${profiles[currentIndex].dogAge ?? ""}\n'),
                                                const TextSpan(text: 'Gender: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: '${profiles[currentIndex].gender ?? ""}\n'),
                                                const TextSpan(text: 'About me: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: '${profiles[currentIndex].about ?? ""}\n'),
                                                const TextSpan(text: 'Contact me: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: profiles[currentIndex].phoneNumber ?? ""),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {_previous();},
                                child: const Text('Prev')
                            ),
                            const SizedBox(width: 30),
                            ElevatedButton(
                                onPressed: () {_next();},
                                child: const Text('Next')
                            ),
                          ]
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