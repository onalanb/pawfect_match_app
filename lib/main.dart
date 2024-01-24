import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(PawfectMatchApp());
}

class PawfectMatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawfect Match App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileCreationPage(),
    );
  }
}

class ProfileCreationPage extends StatefulWidget {
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  String userName = '';
  String dogName = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      // Handle the selected image file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Information:'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // Add more text form fields for user information

            SizedBox(height: 20),

            Text('Dog Information:'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  dogName = value;
                });
              },
              decoration: InputDecoration(labelText: 'Dog Name'),
            ),
            // Add more text form fields for dog information

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Implement logic to save profile data
                // Navigate to the next page or perform other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SwipingMatchingPage(),
                  ),
                );
              },
              child: Text('Save Profile'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Open gallery for photo selection
                _pickImage(ImageSource.gallery);
              },
              child: Text('Select Photo from Gallery'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Open camera for live photo capture
                _pickImage(ImageSource.camera);
              },
              child: Text('Take Photo with Camera'),
            ),
          ],
        ),
      ),
    );
  }
}

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

class Profile {
  final String user;
  final String dog;
  final String? image;

  Profile(this.user, this.dog, this.image);
}