import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('ordinal', () {
    test('default', () {
      final printer = OrdinalNumberPrinter();
      check(printer(0)).equals('0th');
      check(printer(1)).equals('1st');
      check(printer(2)).equals('2nd');
      check(printer(3)).equals('3rd');
      check(printer(4)).equals('4th');
      check(printer(10)).equals('10th');
      check(printer(11)).equals('11th');
      check(printer(12)).equals('12th');
      check(printer(13)).equals('13th');
      check(printer(14)).equals('14th');
      check(printer(20)).equals('20th');
      check(printer(21)).equals('21st');
      check(printer(22)).equals('22nd');
      check(printer(23)).equals('23rd');
      check(printer(24)).equals('24th');
    });
    test('toString', () {
      final printer = OrdinalNumberPrinter();
      check(printer.toString()).startsWith('OrdinalNumberPrinter');
    });
  });
}
