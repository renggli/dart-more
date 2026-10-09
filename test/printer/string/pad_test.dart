import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('pad', () {
    test('left', () {
      final printer = standardString.padLeft(5);
      check(printer('')).equals('     ');
      check(printer('1')).equals('    1');
      check(printer('12')).equals('   12');
      check(printer('123')).equals('  123');
      check(printer('1234')).equals(' 1234');
      check(printer('12345')).equals('12345');
      check(printer('123456')).equals('123456');
      check(printer('👋')).equals('    👋');
    });
    test('left with custom pad', () {
      final printer = standardString.padLeft(5, '*');
      check(printer('')).equals('*****');
      check(printer('1')).equals('****1');
      check(printer('12')).equals('***12');
      check(printer('123')).equals('**123');
      check(printer('1234')).equals('*1234');
      check(printer('12345')).equals('12345');
      check(printer('123456')).equals('123456');
      check(printer('👋')).equals('****👋');
    });
    test('right', () {
      final printer = standardString.padRight(5);
      check(printer('')).equals('     ');
      check(printer('1')).equals('1    ');
      check(printer('12')).equals('12   ');
      check(printer('123')).equals('123  ');
      check(printer('1234')).equals('1234 ');
      check(printer('12345')).equals('12345');
      check(printer('123456')).equals('123456');
      check(printer('👋')).equals('👋    ');
    });
    test('right with custom pad', () {
      final printer = standardString.padRight(5, '*');
      check(printer('')).equals('*****');
      check(printer('1')).equals('1****');
      check(printer('12')).equals('12***');
      check(printer('123')).equals('123**');
      check(printer('1234')).equals('1234*');
      check(printer('12345')).equals('12345');
      check(printer('123456')).equals('123456');
      check(printer('👋')).equals('👋****');
    });
    test('both', () {
      final printer = standardString.padBoth(5);
      check(printer('')).equals('     ');
      check(printer('1')).equals('  1  ');
      check(printer('12')).equals(' 12  ');
      check(printer('123')).equals(' 123 ');
      check(printer('1234')).equals('1234 ');
      check(printer('12345')).equals('12345');
      check(printer('123456')).equals('123456');
      check(printer('👋')).equals('  👋  ');
    });
    test('both with custom pad', () {
      final printer = standardString.padBoth(5, '*');
      check(printer('')).equals('*****');
      check(printer('1')).equals('**1**');
      check(printer('12')).equals('*12**');
      check(printer('123')).equals('*123*');
      check(printer('1234')).equals('1234*');
      check(printer('12345')).equals('12345');
      check(printer('123456')).equals('123456');
      check(printer('👋')).equals('**👋**');
    });
    test('toString', () {
      final printer = standardString.padBoth(5);
      check(printer.toString()).startsWith('PadBothPrinter<String>');
    });
  });
}
