import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProfileCreationPage extends StatefulWidget {
  final String dbPath;

  const ProfileCreationPage({required this.dbPath, Key? key}) : super(key: key);

  @override
  createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final dogNameController = TextEditingController();
  final passwordController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final aboutController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String? genderValue;
  String imagePath = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<String> saveImageToFileSystem(String originalImagePath, String username) async {
    final directory = await getApplicationDocumentsDirectory();
    String fileName = basename(originalImagePath);
    final File newImage = File(join(directory.path, fileName));

    await File(originalImagePath).copy(newImage.path);

    return newImage.path;
  }

  Future<void> saveProfileToDatabase() async {
    String savedImagePath = imagePath;
    if (imagePath.isNotEmpty) {
      savedImagePath = await saveImageToFileSystem(imagePath, usernameController.text);
    }

    final Database database = await openDatabase(widget.dbPath, version: 1);
    await database.insert('Users', {
      'username': usernameController.text,
      'password': passwordController.text,
      'dogName': dogNameController.text,
      'dogBreed': breedController.text,
      'dogAge': int.tryParse(ageController.text) ?? 0,
      'gender': genderValue,
      'about': aboutController.text,
      'image': savedImagePath,
      'phoneNumber': phoneNumberController.text,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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
                const Center(child: Text("SignUp", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Create username'),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Create password"),
                ),
                const SizedBox(height: 20),
                const Center(child: Text("Dog's Information", style: TextStyle(fontSize: 18))),
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
                  decoration: const InputDecoration(hintText: "Enter your Dog breed"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Dog age";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: "Dog's Age"),
                      ),
                    ),
                    const SizedBox(width: 34),
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
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select Dog gender";
                          }
                          return null;
                        },
                      ),
                    )
                  ]
                ),
                TextFormField(
                  controller: aboutController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please share something about your dog";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "About the dog"),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter phone number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Phone Number"),
                ),
               const SizedBox(height: 20),
               Row(
                 children: [
                   ElevatedButton(
                     onPressed: () => _pickImage(ImageSource.gallery),
                     child: const Text('Select Image')
                   ),
                   const SizedBox(width: 20),
                   ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text('Take Photo with Camera'),
                  )
                 ]
               ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await saveProfileToDatabase();
                      Navigator.of(context).pop(); // Navigate back after saving
                    }
                  },
                  child: const Center( child: Text('Save Profile')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}