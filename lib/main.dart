import 'package:flutter/material.dart';
import 'package:pawfect_match_app/Data/database_setup.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  Database db = await databaseHelper.database;
  await databaseHelper.insertMockDataIfNeeded();
  SQLiteUserRepository userRepository = SQLiteUserRepository(db);

  runApp(PawfectMatchApp(userRepository: userRepository));
}

class PawfectMatchApp extends StatelessWidget {
  final UserRepository userRepository;

  const PawfectMatchApp({Key? key, required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawfect Match App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Login(userRepository: userRepository), // Passing userRepo for Logging in
    );
  }
}