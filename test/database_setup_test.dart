import 'package:flutter_test/flutter_test.dart';
import 'package:pawfect_match_app/Data/database_setup.dart';

void main() {
  group('DatabaseHelper Tests', () {
    test('DatabaseHelper provides a singleton instance', () async {
      var instance1 = DatabaseHelper.instance;
      var instance2 = DatabaseHelper.instance;

      expect(instance1, isNotNull);
      expect(instance2, isNotNull);
      expect(identical(instance1, instance2), isTrue);
    });
  });
}
