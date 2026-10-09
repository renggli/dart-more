import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('ifEmpty', () {
    test('default', () {
      final printer = standardInt.iterable().ifEmpty();
      check(printer([])).equals('∅');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
    });
    test('custom', () {
      final printer = standardInt.iterable().ifEmpty('n/a');
      check(printer([])).equals('n/a');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
    });
    test('toString', () {
      final printer = standardInt.iterable().ifEmpty();
      check(printer.toString()).startsWith('EmptyPrinter<int>');
    });
  });
}
