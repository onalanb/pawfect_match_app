// Baran Onalan
// February 6th, 2024
// CPSC 5350 Mobile Development Group Project

// Importing the necessary packages for the project.
import 'package:flutter/material.dart';
import 'create_profile.dart';

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