import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('take/skip', () {
    test('take', () {
      final printer = standardString.take(2);
      check(printer('')).equals('');
      check(printer('a')).equals('a');
      check(printer('ab')).equals('ab');
      check(printer('abc')).equals('ab');
      check(printer('abcd')).equals('ab');
      check(printer.toString()).startsWith('TakePrinter');
    });
    test('takeLast', () {
      final printer = standardString.takeLast(2);
      check(printer('')).equals('');
      check(printer('a')).equals('a');
      check(printer('ab')).equals('ab');
      check(printer('abc')).equals('bc');
      check(printer('abcd')).equals('cd');
      check(printer.toString()).startsWith('TakeLastPrinter');
    });
    test('skip', () {
      final printer = standardString.skip(2);
      check(printer('')).equals('');
      check(printer('a')).equals('');
      check(printer('ab')).equals('');
      check(printer('abc')).equals('c');
      check(printer('abcd')).equals('cd');
      check(printer.toString()).startsWith('SkipPrinter');
    });
    test('skipLast', () {
      final printer = standardString.skipLast(2);
      check(printer('')).equals('');
      check(printer('a')).equals('');
      check(printer('ab')).equals('');
      check(printer('abc')).equals('a');
      check(printer('abcd')).equals('ab');
      check(printer.toString()).startsWith('SkipLastPrinter');
    });
  });
}
