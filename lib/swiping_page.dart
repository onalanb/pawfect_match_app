import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/profile.dart';

class SwipingMatchingPage extends StatefulWidget {
  @override
  _SwipingMatchingPageState createState() => _SwipingMatchingPageState();
}

class _SwipingMatchingPageState extends State<SwipingMatchingPage> {
  List<Profile> profiles = [
    Profile('User 1', 'Dog 1', null), // Blank image
    Profile('User 2', 'Dog 2', null), // Blank image
    Profile('User 3', 'Dog 3', null), // Blank image
    // Add more profiles as needed
  ];

  int currentIndex = 0;

  void _swipeLeft() {
    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  void _swipeRight() {
    // Implement logic for swiping right
    // You may want to show a matched screen or take other actions
    setState(() {
      currentIndex = (currentIndex + 1) % profiles.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swiping and Matching'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Swipe left or right to match or unmatch'),
            SizedBox(height: 50),
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
                          ? Image.network(profiles[currentIndex].image!)
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
}