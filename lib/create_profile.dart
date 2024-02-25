import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_match_app/swiping_page.dart';
import 'package:sqflite/sqflite.dart';

class ProfileCreationPage extends StatefulWidget {
  final String dbPath;

  const ProfileCreationPage({required this.dbPath, Key? key}) : super(key: key);

  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  String username = '';
  String dogName = '';
  String password = '';
  String breed = '';
  String age = '';
  String about = '';
  String? genderValue;
  final usernameController = TextEditingController();
  final dogNameController = TextEditingController();
  final passwordController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final aboutController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      // Handles the selected image file
    }
  }

  @override
  Widget build(BuildContext context) {
    usernameController.text = username;
    dogNameController.text = dogName;
    passwordController.text = password;
    breedController.text = breed;
    ageController.text = age;
    aboutController.text = about;

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
              controller: usernameController,
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Create username'),
            ),
            TextFormField(
              controller: passwordController,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: const InputDecoration(hintText: "Create password"),
              // obscureText: true,
            ),
            const SizedBox(height: 50),
            const Center(child: Text("Dog's Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
            TextFormField(
              controller: dogNameController,
              onChanged: (value) {
                setState(() {
                  dogName = value;
                });
              },
              decoration: const InputDecoration(hintText: "Enter your Pet's name"),
            ),
            TextFormField(
              controller: breedController,
              onChanged: (value) {
                setState(() {
                  breed = value;
                });
              },
              decoration: const InputDecoration(hintText: "Enter your Dog breed"),
            ),
            Row(
              children: <Widget>[
                Expanded(child:
                  TextFormField(
                    controller: ageController,
                    onChanged: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                    decoration: const InputDecoration(hintText: "Age"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(child: SizedBox(
                  child: Container(padding: const EdgeInsets.symmetric(),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: genderValue,
                      hint: const Text("Gender"),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(value: 'Female', child: Text("Female"))
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            genderValue = newValue;
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
            TextFormField(
              controller: aboutController,
              onChanged: (value) {
                setState(() {
                  about = value;
                });
              },
              decoration: const InputDecoration(hintText: "List favorite activities that your dog like"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                Database database = await openDatabase(widget.dbPath, version: 1);
                await database.transaction((txn) async {
                  await txn.rawInsert(
                      'INSERT INTO Users(username, password, dogName, dogBreed, dogAge, gender, about) '
                      'VALUES("$username", "$password", "$dogName", "$breed", "$age", "$genderValue", "$about")');
                });
                // Will Implement logic to save profile data later
                // Navigating to the next page to perform other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SwipingMatchingPage(dbPath: widget.dbPath, userName: username),
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