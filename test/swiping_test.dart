import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/profile.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'package:pawfect_match_app/swiping_page.dart';

void main() async {
    group('Swiping Page Functionality Tests', ()
    {
      late InMemoryUserRepository userRepository;

      setUp(() {
        userRepository = InMemoryUserRepository();
        userRepository.addUser(Profile(
          username: 'varun',
          dogName: 'snoopy',
          password: 'password',
          dogBreed: 'Pit Bull',
          dogAge: 2,
          gender: 'Male',
          about: 'I always have my tennis ball in my mouth!',
          phoneNumber: '(123)123-1234',
          image: 'lib/Assets/photos/195827115-2024-01-04.jpg',
        ));
        userRepository.addUser(Profile(
          username: 'baran',
          dogName: 'Marley',
          password: 'password',
          dogBreed: 'Retriever',
          dogAge: 8,
          gender: 'Female',
          about: 'I love long hikes!',
          phoneNumber: '(123)123-1234',
          image: 'lib/Assets/photos/195723497-2024-01-01.jpg',
        ));
      });

      testWidgets("Testing swiping features", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: SwipingMatchingPage(
                    userRepository: userRepository, userName: 'varun')
            )
        ));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsNWidgets(2));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Swiping and Matching'), findsOneWidget);
        expect(find.text('Swipe left or right to match or unmatch'), findsOneWidget);
        await tester.pumpAndSettle();

        final dismissibleFinder = find.byType(Dismissible);
        expect(dismissibleFinder, findsOneWidget);

        final Dismissible dismissibleWidget = tester.widget(dismissibleFinder);

        Widget? childWidget = dismissibleWidget.child;
        childWidget = (childWidget as Card).child;
        childWidget = (childWidget as Stack).children[0];
        childWidget = (childWidget as Padding).child;
        Column column = childWidget as Column;
        expect((column.children[0] as Text).data, "User: baran");
        expect((column.children[1] as Text).data, "Dog: Marley");

        final rowFinder = find.byType(Row);
        expect(rowFinder, findsNWidgets(2));

        final elevatedButtonFinder = find.descendant(
          of: find.byWidgetPredicate((widget) => widget is Row ),
          matching: find.byType(ElevatedButton),
        );
        expect(elevatedButtonFinder, findsNWidgets(4));
      });
    });
  }