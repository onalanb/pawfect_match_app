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
  String? selectedValue;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      // Handles the selected image file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Create Profile', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(child: Text("SignUp", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Create Username'),
            ),
            const TextField(
              decoration: InputDecoration(hintText: "Create password"),
                obscureText: true,
            ),
            const SizedBox(height: 50),
            const Center(child: Text("Dog's Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
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
            Row(
              children: <Widget>[
                const Expanded(child:TextField(
                    decoration: InputDecoration(
                      hintText: "Age",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(child: SizedBox(
                    child: Container(padding: const EdgeInsets.symmetric(),
                        child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedValue,
                      hint: const Text("Gender"),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(value: 'Female', child: Text("Female"))
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        }
                      },
                    )
                    )
                )
                )
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
                // Will Implement logic to save profile data later
                // Navigating to the next page to perform other actions
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
              child: const Text('Select Photo from Gallery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Opens camera for live photo capture
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