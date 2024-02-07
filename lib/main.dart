// Baran Onalan , Sai Varun , James Robinson
// February 6th, 2024
// CPSC 5250 Mobile Development Group Project

import 'package:flutter/material.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/images.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  var appDirPath = appDir.path;
  String dbPath = join(appDirPath, 'PawfectMatch.db');
  initializeDatabaseWithSomeUsers(dbPath);

  runApp(const PawfectMatchApp(dbPath: dbPath));
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
      home: const Login(dbPath: dbPath),
    );
  }
}

void initializeDatabaseWithSomeUsers(String dbPath) async {
  // Delete the database to start fresh
  await deleteDatabase(dbPath);
  print('Deleted DB');

  Database db = await openDatabase(dbPath, version: 1);
  await db.execute(
      'CREATE TABLE Users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, petName TEXT, picture TEXT)');
  // Insert some records in a transaction
  print('Created table');
  await db.transaction((txn) async {
    int id1 = await txn.rawInsert('INSERT INTO Users(id, username, password, petName, picture) VALUES(1, "baran", "password", "Marley", "$image1")');
    print('inserted user: $id1');
    int id2 = await txn.rawInsert('INSERT INTO Users(id, username, password, petName, picture) VALUES(2, "james", "password", "Leo", "$image2")');
    print('inserted user: $id2');
    int id3 = await txn.rawInsert('INSERT INTO Users(id, username, password, petName) VALUES(3, "varun", "password", "Momo")');
    print('inserted user: $id3');
  });
}

