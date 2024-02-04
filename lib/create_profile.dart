// Baran

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_match_app/swiping_page.dart';

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