import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class ProfileCreationPage extends StatefulWidget {
  final String dbPath;

  const ProfileCreationPage({required this.dbPath, Key? key}) : super(key: key);

  @override
  createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String dogName = '';
  String password = '';
  String breed = '';
  String age = '';
  String about = '';
  String? genderValue;
  String imagePath = ''; // Adjusted for file path usage
  String phoneNumber = '';

  final usernameController = TextEditingController();
  final dogNameController = TextEditingController();
  final passwordController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final aboutController = TextEditingController();
  final phoneNumberController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // Store the file path directly
      });
    }
  }

  Future<void> saveProfileToDatabase() async {
    final Database database = await openDatabase(widget.dbPath, version: 1);
    await database.insert('Users', {
      'username': usernameController.text,
      'password': passwordController.text,
      'dogName': dogNameController.text,
      'dogBreed': breedController.text,
      'dogAge': int.tryParse(ageController.text) ?? 0, // Ensure dogAge is stored as an integer
      'gender': genderValue,
      'about': aboutController.text,
      'image': imagePath, // Saving the image file path
      'phoneNumber': phoneNumberController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Create Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                    child: Text("SignUp", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
                ),
                TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Create username')
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true, // Enhance password field security
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Create password"),
                ),
                const SizedBox(height: 30),
                const Center(
                    child: Text("Dog's Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ),
                TextFormField(
                  controller: dogNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Dog name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Enter your Pet's name"),
                ),
                TextFormField(
                    controller: breedController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Dog breed";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Enter your Dog breed")
                ),
                Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Dog's Age")
                        )
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: genderValue,
                          hint: const Text("Select Gender"),
                          items: <String>['Male', 'Female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              genderValue = newValue;
                            });
                          }
                          )
                      )
                    ]
                ),
                TextFormField(
                  controller: aboutController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(hintText: "About the dog"),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: "Phone Number"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await saveProfileToDatabase();
                      Navigator.of(context).pop(); // Assuming you want to pop back after saving
                    }
                  },
                  child: const Center(child: Text('Save Profile')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
