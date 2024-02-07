// Baran Onalan , Sai Varun , James Robinson
// February 6th, 2024
// CPSC 5250 Mobile Development Group Project

// Importing the necessary packages for the project.
import 'package:flutter/material.dart';
import 'package:pawfect_match_app/login.dart';

void main() {
  runApp(const PawfectMatchApp());
}

class PawfectMatchApp extends StatelessWidget {
  const PawfectMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawfect Match App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}