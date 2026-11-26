import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('iterable', () {
    test('default', () {
      final printer = standardInt.iterable();
      check(printer([])).equals('');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
      check(printer([1, 2, 3])).equals('1, 2, 3');
      check(printer([1, 2, 3, 4])).equals('1, 2, 3, 4');
      check(printer([1, 2, 3, 4, 5])).equals('1, 2, 3, 4, 5');
    });
    test('emptyPrinter', () {
      final printer = standardInt.iterable(
        emptyPrinter: const Printer.literal('n/a'),
      );
      check(printer([])).equals('n/a');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
      check(printer([1, 2, 3])).equals('1, 2, 3');
      check(printer([1, 2, 3, 4])).equals('1, 2, 3, 4');
      check(printer([1, 2, 3, 4, 5])).equals('1, 2, 3, 4, 5');
    });
    test('beforePrinter', () {
      final printer = standardInt.iterable(
        beforePrinter: const Printer.literal('['),
      );
      check(printer([])).equals('');
      check(printer([1])).equals('[1');
      check(printer([1, 2])).equals('[1, 2');
      check(printer([1, 2, 3])).equals('[1, 2, 3');
      check(printer([1, 2, 3, 4])).equals('[1, 2, 3, 4');
      check(printer([1, 2, 3, 4, 5])).equals('[1, 2, 3, 4, 5');
    });
    test('afterPrinter', () {
      final printer = standardInt.iterable(
        afterPrinter: const Printer.literal(']'),
      );
      check(printer([])).equals('');
      check(printer([1])).equals('1]');
      check(printer([1, 2])).equals('1, 2]');
      check(printer([1, 2, 3])).equals('1, 2, 3]');
      check(printer([1, 2, 3, 4])).equals('1, 2, 3, 4]');
      check(printer([1, 2, 3, 4, 5])).equals('1, 2, 3, 4, 5]');
    });
    test('enclosed', () {
      final printer = standardInt.iterable(
        emptyPrinter: const Printer.literal('∅'),
        beforePrinter: const Printer.literal('['),
        afterPrinter: const Printer.literal(']'),
      );
      check(printer([])).equals('∅');
      check(printer([1])).equals('[1]');
      check(printer([1, 2])).equals('[1, 2]');
      check(printer([1, 2, 3])).equals('[1, 2, 3]');
      check(printer([1, 2, 3, 4])).equals('[1, 2, 3, 4]');
      check(printer([1, 2, 3, 4, 5])).equals('[1, 2, 3, 4, 5]');
    });
    test('separator', () {
      final printer = standardInt.iterable(separator: ';');
      check(printer([])).equals('');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1;2');
      check(printer([1, 2, 3])).equals('1;2;3');
      check(printer([1, 2, 3, 4])).equals('1;2;3;4');
      check(printer([1, 2, 3, 4, 5])).equals('1;2;3;4;5');
    });
    test('lastSeparator', () {
      final printer = standardInt.iterable(lastSeparator: ', and ');
      check(printer([])).equals('');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, and 2');
      check(printer([1, 2, 3])).equals('1, 2, and 3');
      check(printer([1, 2, 3, 4])).equals('1, 2, 3, and 4');
      check(printer([1, 2, 3, 4, 5])).equals('1, 2, 3, 4, and 5');
    });
    test('leadingItems', () {
      final printer = standardInt.iterable(leadingItems: 3);
      check(printer([])).equals('');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
      check(printer([1, 2, 3])).equals('1, 2, 3');
      check(printer([1, 2, 3, 4])).equals('1, 2, 3, …');
      check(printer([1, 2, 3, 4, 5])).equals('1, 2, 3, …');
      check(printer([1, 2, 3, 4, 5, 6])).equals('1, 2, 3, …');
      check(printer([1, 2, 3, 4, 5, 6, 7])).equals('1, 2, 3, …');
      check(printer([1, 2, 3, 4, 5, 6, 7, 8])).equals('1, 2, 3, …');
    });
    test('trailingItems', () {
      final printer = standardInt.iterable(trailingItems: 3);
      check(printer([])).equals('');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
      check(printer([1, 2, 3])).equals('1, 2, 3');
      check(printer([1, 2, 3, 4])).equals('…, 2, 3, 4');
      check(printer([1, 2, 3, 4, 5])).equals('…, 3, 4, 5');
      check(printer([1, 2, 3, 4, 5, 6])).equals('…, 4, 5, 6');
      check(printer([1, 2, 3, 4, 5, 6, 7])).equals('…, 5, 6, 7');
      check(printer([1, 2, 3, 4, 5, 6, 7, 8])).equals('…, 6, 7, 8');
    });
    test('leadingItems and trailingItems', () {
      final printer = standardInt.iterable(leadingItems: 3, trailingItems: 3);
      check(printer([])).equals('');
      check(printer([1])).equals('1');
      check(printer([1, 2])).equals('1, 2');
      check(printer([1, 2, 3])).equals('1, 2, 3');
      check(printer([1, 2, 3, 4])).equals('1, 2, 3, 4');
      check(printer([1, 2, 3, 4, 5])).equals('1, 2, 3, 4, 5');
      check(printer([1, 2, 3, 4, 5, 6])).equals('1, 2, 3, 4, 5, 6');
      check(printer([1, 2, 3, 4, 5, 6, 7])).equals('1, 2, 3, …, 5, 6, 7');
      check(printer([1, 2, 3, 4, 5, 6, 7, 8])).equals('1, 2, 3, …, 6, 7, 8');
    });
    test('infinite iterable with leadingItems', () {
      final printer = standardInt.iterable(leadingItems: 3);
      check(printer(Iterable<int>.generate(1 << 30))).equals('0, 1, 2, …');
    });
    test('ellipses: null and zero limits', () {
      check(standardInt.iterable(leadingItems: 2, ellipses: null)([1, 2, 3]))
          .equals('1, 2');
      check(
        standardInt.iterable(leadingItems: 1, trailingItems: 1, ellipses: null)(
          [1, 2, 3, 4],
        ),
      ).equals('1, 4');
      check(standardInt.iterable(leadingItems: 0)([1, 2, 3])).equals('…');
      check(standardInt.iterable(trailingItems: 0)([1, 2, 3])).equals('…');
      check(
        standardInt.iterable(
          leadingItems: 2,
          lastSeparator: ', and ',
          ellipses: null,
        )([1, 2, 3]),
      ).equals('1, and 2');
    });
    test('toString', () {
      final printer = standardInt.iterable();
      check(printer.toString()).startsWith('IterablePrinter<int>');
    });
  });
}
