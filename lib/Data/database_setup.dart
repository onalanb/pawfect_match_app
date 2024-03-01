import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'mock_data.dart';

class DatabaseHelper {
  static const _databaseName = "PawfectMatch.db";
  static const _version = 2;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  _initializeDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, _databaseName);
    await deleteDatabase(dbPath);
    return await openDatabase(dbPath, version: _version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Profiles(
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
            liked INTEGER,
            FOREIGN KEY (fromUser) REFERENCES Profiles(username),
            FOREIGN KEY (toUser) REFERENCES Profiles(username),
            UNIQUE(fromUser, toUser, liked)
          )
        ''');
        print("Tables created Successfully!");
      },
    );
  }

  Future<void> insertMockDataIfNeeded() async {
    final Database db = await database;
      var mockData = MockProfileDao().mockProfiles;
      print("Entered inserting");
      for (var profile in mockData) {
        await db.insert('Profiles', profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      print('Mock data inserted into Profiles table');
    }
  }
}
