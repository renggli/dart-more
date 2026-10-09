import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('sequence', () {
    test('default', () {
      const printer = SequencePrinter<String>([
        standardString,
        Printer.literal('-'),
        standardString,
      ]);
      check(printer('1')).equals('1-1');
      check(printer('12')).equals('12-12');
    });
    test('iterable', () {
      final printer = <Printer<int>>[
        const Printer.standard(),
        const Printer.literal(' <-> '),
        Printer.pluggable(
          (value) => value.toString().split('').reversed.join(''),
        ),
      ].toPrinter();
      check(printer(1)).equals('1 <-> 1');
      check(printer(12)).equals('12 <-> 21');
      check(printer(123)).equals('123 <-> 321');
      check(printer(1234)).equals('1234 <-> 4321');
    });
    test('before', () {
      final printer = standardString.before('*');
      check(printer('1')).equals('*1');
    });
    test('after', () {
      final printer = standardString.after('*');
      check(printer('1')).equals('1*');
    });
    test('around (same)', () {
      final printer = standardString.around('*');
      check(printer('1')).equals('*1*');
    });
    test('around (different)', () {
      final printer = standardString.around('<', '>');
      check(printer('1')).equals('<1>');
    });
    test('toString', () {
      final printer = standardString.around('<', '>');
      check(printer.toString()).startsWith('SequencePrinter<String>');
    });
  });
}
