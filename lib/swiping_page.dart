import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/profile.dart';
import 'package:sqflite/sqflite.dart';

class SwipingMatchingPage extends StatefulWidget {
  final String dbPath;
  final String userName;

  SwipingMatchingPage({required this.dbPath, required this.userName, Key? key}) : super(key: key);

  @override
  _SwipingMatchingPageState createState() => _SwipingMatchingPageState();
}

class _SwipingMatchingPageState extends State<SwipingMatchingPage> {
  List<Profile> profiles = [];

  Future<List<Profile>> readProfilesFromDatabase() async {
    print('Reading profiles from database');
    Database database = await openDatabase(widget.dbPath, version: 1);

    // Query the database for all users except self
    final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT username, petName, picture FROM Users WHERE username != ?', [widget.userName]);

    // Convert the List<Map> to a List<User>
    return List.generate(maps.length, (i) {
      return Profile(maps[i]['username'], maps[i]['petName'], maps[i]['picture']);
    });
  }

  Future setProfiles() async {
    List<Profile> readProfiles;
    if (profiles.isEmpty) {
      readProfiles = await readProfilesFromDatabase();
      setState(() {
        profiles = readProfiles;
      });
    }
  }

  int currentIndex = 0;

  void _swipeLeft() async {
    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  void _swipeRight() {
    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            print(profiles[currentIndex].image);
            return Scaffold(
              appBar: AppBar(
                title: Text('Swiping and Matching'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Swipe left or right to match or unmatch'),
                    SizedBox(height: 20),
                    Dismissible(
                      key: Key(profiles[currentIndex].user),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          _swipeLeft();
                        } else {
                          _swipeRight();
                        }
                      },
                      child: Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Display user and dog names
                              Text('User: ${profiles[currentIndex].user}'),
                              Text('Dog: ${profiles[currentIndex].dog}'),
                              // Display image (or blank if null)
                              profiles[currentIndex].image != null
                                  ? Image.memory(base64Decode(profiles[currentIndex].image!))
                                  : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey, // Placeholder for blank image
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _swipeLeft,
                      child: Text('Swipe Left'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _swipeRight,
                      child: Text('Swipe Right'),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}