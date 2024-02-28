import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:pawfect_match_app/swiping_page.dart';

void main() async{
  //Initializing the ffi implementation
    sqfliteFfiInit();

    //global database factory
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(inMemoryDatabasePath, options: OpenDatabaseOptions(
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE PROFILES(
        username TEXT PRIMARY KEY UNIQUE,
        dogName TEXT,
        password TEXT,
        dogBreed TEXT,
        dogAge INTEGER,
        gender TEXT,
        about TEXT,
        image TEXT)
        ''');
      await db.insert('PROFILES', {
        'username': 'varun',
        'dogName': 'snoopy',
        'dogBreed': 'pit bull',
        'dogAge': 3,
        'gender': 'Male',
        'about': 'Loves long walks',
        'image': 'base64EncodedImageString',
      });
    }
    ));

    testWidgets("Testing swiping features", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Swiping and Matching')),
            body: const SwipingMatchingPage(dbPath: inMemoryDatabasePath, userName: 'varun')
        )
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Swiping and Matching'), findsOneWidget);
      await tester.pumpAndSettle();

      // final dismissibleFinder = find.byType(Dismissible);
      // expect(dismissibleFinder, findsOneWidget);
      // expect(find.text('varun'), findsOneWidget);
      // expect(find.text('snoopy'), findsOneWidget);
      // expect(find.text('pit bull'), findsOneWidget);

      // expect(find.byType(ElevatedButton), findsNWidgets(1));

      //await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.report_outlined));
      //await tester.pump(const Duration(seconds: 1));
      // expect(find.byType(AlertDialog), findsOneWidget);
    });
    await db.close();
  }