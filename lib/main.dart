// Baran Onalan , Sai Varun , James Robinson
// February 29th, 2024
// CPSC 5250 Mobile Development Group Project

import 'package:flutter/material.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  var appDirPath = appDir.path;
  String dbPath = join(appDirPath, 'PawfectMatch.db');
  print(dbPath);
  runApp(PawfectMatchApp(dbPath: dbPath));
}

class PawfectMatchApp extends StatelessWidget {
  final String dbPath;

  const PawfectMatchApp({required this.dbPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawfect Match App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(dbPath: dbPath),
    );
  }
}