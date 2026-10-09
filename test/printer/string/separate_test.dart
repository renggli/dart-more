import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('separate', () {
    test('left', () {
      final printer = standardString.separateLeft(3, 0, '_');
      check(printer('')).equals('');
      check(printer('1')).equals('1');
      check(printer('12')).equals('12');
      check(printer('123')).equals('123');
      check(printer('1234')).equals('123_4');
      check(printer('12345')).equals('123_45');
      check(printer('123456')).equals('123_456');
      check(printer('1234567')).equals('123_456_7');
      check(printer('12345678')).equals('123_456_78');
      check(printer('123456789')).equals('123_456_789');
      check(printer('1234567890')).equals('123_456_789_0');
      check(printer('👨👩👧👦')).equals('👨👩👧_👦');
    });
    test('right', () {
      final printer = standardString.separateRight(3, 0, '_');
      check(printer('')).equals('');
      check(printer('1')).equals('1');
      check(printer('12')).equals('12');
      check(printer('123')).equals('123');
      check(printer('1234')).equals('1_234');
      check(printer('12345')).equals('12_345');
      check(printer('123456')).equals('123_456');
      check(printer('1234567')).equals('1_234_567');
      check(printer('12345678')).equals('12_345_678');
      check(printer('123456789')).equals('123_456_789');
      check(printer('1234567890')).equals('1_234_567_890');
      check(printer('👨👩👧👦')).equals('👨_👩👧👦');
    });
    test('offset left', () {
      final left0 = standardString.separateLeft(3, 0, '_');
      check(left0('1234567890')).equals('123_456_789_0');
      final left1 = standardString.separateLeft(3, 1, '_');
      check(left1('1234567890')).equals('1_234_567_890');
      final left2 = standardString.separateLeft(3, 2, '_');
      check(left2('1234567890')).equals('12_345_678_90');
    });
    test('offset right', () {
      final right0 = standardString.separateRight(3, 0, '_');
      check(right0('1234567890')).equals('1_234_567_890');
      final right1 = standardString.separateRight(3, 1, '_');
      check(right1('1234567890')).equals('123_456_789_0');
      final right2 = standardString.separateRight(3, 2, '_');
      check(right2('1234567890')).equals('12_345_678_90');
    });
    test('toString', () {
      final printer = standardString.separateLeft(3, 0, '_');
      check(printer.toString()).startsWith('SeparateLeftPrinter<String>');
    });
  });
}
