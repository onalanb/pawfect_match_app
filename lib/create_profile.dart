import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_match_app/swiping_page.dart';

class ProfileCreationPage extends StatefulWidget {
  const ProfileCreationPage({Key? key}) : super(key: key);

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
        title: const Text('Create Profile'),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Enter your name'),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Create password"
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Dog's Information")),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  dogName = value;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Enter your Pet's name"
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Enter your Dog' breed"
              ),
            ),
            const Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Age ",
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: "Sex"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                  hintText: "List favorite activities that your dog like"
              ),
            ),
            const SizedBox(height: 30),
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
              child: const Text('Save Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open gallery for photo selection
                _pickImage(ImageSource.gallery);
              },
              child: Text('Select Photo from Gallery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open camera for live photo capture
                _pickImage(ImageSource.camera);
              },
              child: const Text('Take Photo with Camera'),
            ),
          ],
        ),
      ),
      )
    );
  }
}