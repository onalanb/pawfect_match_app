import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/user_repo.dart';

class Matches extends StatefulWidget {
  final UserRepository userRepository;
  final String userName;

  const Matches({required this.userRepository, required this.userName, Key? key,}) : super(key: key);

  @override
  createState() => MatchesPageState();
}

class MatchesPageState extends State<Matches> {
  List<Profile> profiles = [];
  int currentIndex = 0;
  bool animateCount = false;
  int matchCount = 0;
  late Future<void> matchesPage;

  @override
  void initState() {
    super.initState();
    matchesPage = _setProfiles();
  }

  Future<void> _setProfiles() async {
    profiles = await widget.userRepository.getMatchedProfiles(widget.userName);
    _updateMatchCount();
  }

  void _previous() {
    setState(() {
      currentIndex = currentIndex > 0 ? currentIndex - 1 : profiles.length - 1;
    });
  }

  void _next() {
    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  Future<void> _updateMatchCount() async {
    int newCount = await widget.userRepository.getMatchCount(widget.userName);
    setState(() {
      animateCount = (matchCount != newCount);
      matchCount = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: matchesPage,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (profiles.isEmpty) { // Checks if the Matchedprofiles list is empty
            return Scaffold(
              appBar: AppBar(title: const Text('Matches')),
              body: const Center(child: Text("Oops! No matches yet")),
            );
          } else {
            return Scaffold(
                appBar: AppBar(title: Text('$matchCount Matches')),
                body: SingleChildScrollView(child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Click info icon for my Number!', style: TextStyle(fontSize: 18)),
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
                                    Text('User: ${profiles[currentIndex].username}'),
                                    Text('Dog: ${profiles[currentIndex].dogName}'),
                                    profiles[currentIndex].image != null
                                        ? (profiles[currentIndex].image!.startsWith('lib/Assets/')
                                        ? Image.asset(
                                      profiles[currentIndex].image!,
                                      width: 330,
                                      height: 475,
                                    )
                                        : Image.file(
                                      File(profiles[currentIndex].image!),
                                      width: 330,
                                      height: 475,
                                    ))
                                        : Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.info),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(profiles[currentIndex].dogName),
                                          content: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: Colors.black, fontSize: 20),
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
                                              child: const Text('Close'),
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