// Baran Onalan , Sai Varun , James Robinson
// February 29th, 2024
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
  print(dbPath);
  initializeDatabaseWithSomeUsers(dbPath);

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

void initializeDatabaseWithSomeUsers(String dbPath) async {
  // Delete the database to start fresh
  await deleteDatabase(dbPath);
  print('Deleted DB');

  Database db = await openDatabase(dbPath, version: 1);
  await db.execute('''
    CREATE TABLE Users (
      username TEXT PRIMARY KEY UNIQUE, 
      dogName TEXT, 
      password TEXT, 
      dogBreed TEXT, 
      dogAge INTEGER, 
      gender TEXT, 
      about TEXT, 
      image TEXT, 
      phoneNumber TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE Matches (
      fromUser TEXT,
      toUser TEXT,
      liked BOOLEAN,
      FOREIGN KEY (fromUser) REFERENCES Users(username),
      FOREIGN KEY (toUser) REFERENCES Users(username),
      UNIQUE(fromUser, toUser, liked)
    )
  ''');

  // Insert some records in a transaction
  print('Created tables');
  await db.transaction((txn) async {
    int id1 = await txn.rawInsert('INSERT INTO Users(username, password, dogName, image) VALUES("baran", "password", "Marley", "$image1")');
    print('inserted user: $id1');
    int id2 = await txn.rawInsert('INSERT INTO Users(username, password, dogName, image) VALUES("james", "password", "Leo", "$image2")');
    print('inserted user: $id2');
    int id3 = await txn.rawInsert('INSERT INTO Users(username, password, dogName, image) VALUES("varun", "password", "Momo", "$image3")');
    print('inserted user: $id3');
  });
}

