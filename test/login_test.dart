import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/login.dart';
import 'package:pawfect_match_app/create_profile.dart';
import 'package:pawfect_match_app/swiping_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() {
  setUpAll(() {
    // Initialize sqflite for tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets("Testing Widgets in Login page", (WidgetTester tester) async {
    // Ensure the database is initialized before proceeding with the test
    WidgetsFlutterBinding.ensureInitialized();
    String dbPath = join(await getDatabasesPath(), 'test.db');

    // Open the database and create the necessary table
    Database db = await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE Users (
          username TEXT PRIMARY KEY,
          password TEXT
        )
      ''');
      await db.insert('Users', {
        'username': 'testuser',
        'password': 'testpass',
      });
    });

    await tester.pump(const Duration(seconds: 1)); // Forces the test to wait for 1 second

    // Pump the Login widget with the test database path
    await tester.pumpWidget(MaterialApp(home: Login(dbPath: dbPath)));

    // Check for the presence of text fields and buttons
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsExactly(1));
    expect(find.byType(TextButton), findsExactly(1));

    // Enter valid username and password
    await tester.enterText(find.byType(TextField).at(0), "testuser");
    await tester.enterText(find.byType(TextField).at(1), "testpass");

    // Tap the login button and wait for the UI to react
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the SwipingMatchingPage is shown after a successful login
    expect(find.byType(SwipingMatchingPage), findsOneWidget);

    // Navigate to the SignUp page to check navigation
    await tester.tap(find.text('SignUp'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileCreationPage), findsOneWidget);

    // Close the database to clean up
    await db.close();
  });
}