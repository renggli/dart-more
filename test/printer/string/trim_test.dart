import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('trim', () {
    test('both', () {
      final printer = standardString.trim();
      check(printer('')).equals('');
      check(printer(' * ')).equals('*');
      check(printer('  **  ')).equals('**');
    });
    test('left', () {
      final printer = standardString.trimLeft();
      check(printer('')).equals('');
      check(printer(' * ')).equals('* ');
      check(printer('  **  ')).equals('**  ');
    });
    test('right', () {
      final printer = standardString.trimRight();
      check(printer('')).equals('');
      check(printer(' * ')).equals(' *');
      check(printer('  **  ')).equals('  **');
    });
    test('toString', () {
      final printer = standardString.trim();
      check(printer.toString()).startsWith('TrimBothPrinter<String>');
    });
  });
}
