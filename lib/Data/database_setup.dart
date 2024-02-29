import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'mock_data.dart';

class DatabaseHelper {
  static const _databaseName = "PawfectMatch.db";
  static const _databaseVersion = 1;

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
    bool dbExists = await File(dbPath).exists();
    if (dbExists) {
      print("Opening existing database");
    } else {
      print("Creating new database");
    }
    var db = await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreate);
    if (!dbExists) {
      await insertMockDataIfNeeded();
    }
    return db;
  }

  Future _onCreate(Database db, int version) async {
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
    print('Database and tables created');
  }

  Future<void> insertMockDataIfNeeded() async {
    final Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Users'));
    if (count == 0) {
      var mockData = MockProfileDao().mockProfiles;
      for (var profile in mockData) {
        await db.insert('Users', profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      print('Mock data inserted');
    }
  }
}
