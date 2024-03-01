import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/report_profile.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'heart_counter.dart';

class SwipingMatchingPage extends StatefulWidget {
  final UserRepository userRepository;
  final String userName;

  const SwipingMatchingPage({required this.userRepository, required this.userName, Key? key,}) : super(key: key);

  @override
  createState() => _SwipingMatchingPageState();
}

class _SwipingMatchingPageState extends State<SwipingMatchingPage> {
  List<Profile> profiles = [];
  int currentIndex = 0;
  bool animateCount = false;
  int matchCount = 0;
  late Future<void> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = setProfiles();
  }

  Future<void> setProfiles() async {
    print("called setProfile function");
    profiles = await widget.userRepository.getProfilesExcludingUser(widget.userName);
    await _updateMatchCount();
  }

  void _swipeLeft(String matchedUser) async {
    await widget.userRepository.swipeLeft(widget.userName, matchedUser);
    await _updateMatchCount();
    setState(() => currentIndex = (currentIndex + 1) % profiles.length);
  }

  void _swipeRight(String matchedUser) async {
    await widget.userRepository.swipeRight(widget.userName, matchedUser);
    await _updateMatchCount();
    setState(() => currentIndex = (currentIndex + 1) % profiles.length);
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
        future:  _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
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
                                        title: const Text('Information'),
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
                                              TextSpan(text: profiles[currentIndex].about ?? ""),
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
                            child: const Icon(Icons.report_outlined)
                        )
                      ]
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeartCounter(count: matchCount, animate: animateCount,
                            userName: widget.userName, userRepository: widget.userRepository)
                      ],
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