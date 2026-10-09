import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('scientific', () {
    test('default', () {
      final printer = ScientificNumberPrinter();
      check(printer(0)).equals('0.000e0');
      check(printer(2)).equals('2.000e0');
      check(printer(300)).equals('3.000e2');
      check(printer(4321.768)).equals('4.322e3');
      check(printer(-53000)).equals('-5.300e4');
      check(printer(6720000000)).equals('6.720e9');
      check(printer(0.2)).equals('2.000e-1');
      check(printer(0.00000000751)).equals('7.510e-9');
      check(printer(double.nan)).equals('NaN');
      check(printer(double.infinity)).equals('Infinity');
    });
    test('base', () {
      final printer = ScientificNumberPrinter(base: 16);
      check(printer(0)).equals('0.000e0');
      check(printer(2)).equals('2.000e0');
      check(printer(300)).equals('1.2c0e2');
      check(printer(4321.768)).equals('1.0e2e3');
      check(printer(-53000)).equals('-c.f08e3');
      check(printer(6720000000)).equals('1.909e8');
      check(printer(0.2)).equals('3.333e-1');
      check(printer(0.00000000751)).equals('2.041e-7');
    });
    test('characters', () {
      final printer = ScientificNumberPrinter(
        base: 16,
        characters: '0123456789ABCDEF'.split(''),
      );
      check(printer(0)).equals('0.000e0');
      check(printer(2)).equals('2.000e0');
      check(printer(300)).equals('1.2C0e2');
      check(printer(4321.768)).equals('1.0E2e3');
      check(printer(-53000)).equals('-C.F08e3');
      check(printer(6720000000)).equals('1.909e8');
      check(printer(0.2)).equals('3.333e-1');
      check(printer(0.00000000751)).equals('2.041e-7');
    });
    test('delimiter', () {
      final printer = ScientificNumberPrinter(delimiter: ',');
      check(printer(0)).equals('0,000e0');
      check(printer(2)).equals('2,000e0');
      check(printer(300)).equals('3,000e2');
      check(printer(4321.768)).equals('4,322e3');
      check(printer(-53000)).equals('-5,300e4');
      check(printer(6720000000)).equals('6,720e9');
      check(printer(0.2)).equals('2,000e-1');
      check(printer(0.00000000751)).equals('7,510e-9');
    });
    test('exponentPadding', () {
      final printer = ScientificNumberPrinter(exponentPadding: 3);
      check(printer(0)).equals('0.000e000');
      check(printer(2)).equals('2.000e000');
      check(printer(300)).equals('3.000e002');
      check(printer(4321.768)).equals('4.322e003');
      check(printer(-53000)).equals('-5.300e004');
      check(printer(6720000000)).equals('6.720e009');
      check(printer(0.2)).equals('2.000e-001');
      check(printer(0.00000000751)).equals('7.510e-009');
      check(printer(double.nan)).equals('NaN');
      check(printer(double.infinity)).equals('Infinity');
    });
    test('exponentSign', () {
      final printer = ScientificNumberPrinter(
        exponentSign: const SignNumberPrinter.negativeAndPositiveSign(),
      );
      check(printer(0)).equals('0.000e+0');
      check(printer(2)).equals('2.000e+0');
      check(printer(300)).equals('3.000e+2');
      check(printer(4321.768)).equals('4.322e+3');
      check(printer(-53000)).equals('-5.300e+4');
      check(printer(6720000000)).equals('6.720e+9');
      check(printer(0.2)).equals('2.000e-1');
      check(printer(0.00000000751)).equals('7.510e-9');
    });
    test('infinity', () {
      final printer = ScientificNumberPrinter(infinity: 'huge');
      check(printer(0)).equals('0.000e0');
      check(printer(2)).equals('2.000e0');
      check(printer(300)).equals('3.000e2');
      check(printer(4321.768)).equals('4.322e3');
      check(printer(-53000)).equals('-5.300e4');
      check(printer(6720000000)).equals('6.720e9');
      check(printer(0.2)).equals('2.000e-1');
      check(printer(0.00000000751)).equals('7.510e-9');
    });
    test('mantissaPadding', () {
      final printer = ScientificNumberPrinter(mantissaPadding: 3);
      check(printer(0)).equals('000.000e0');
      check(printer(2)).equals('002.000e0');
      check(printer(300)).equals('003.000e2');
      check(printer(4321.768)).equals('004.322e3');
      check(printer(-53000)).equals('-005.300e4');
      check(printer(6720000000)).equals('006.720e9');
      check(printer(0.2)).equals('002.000e-1');
      check(printer(0.00000000751)).equals('007.510e-9');
      check(printer(double.nan)).equals('NaN');
      check(printer(double.infinity)).equals('Infinity');
    });
    test('mantissaSign', () {
      final printer = ScientificNumberPrinter(
        mantissaSign: const SignNumberPrinter.negativeAndPositiveSign(),
      );
      check(printer(0)).equals('+0.000e0');
      check(printer(2)).equals('+2.000e0');
      check(printer(300)).equals('+3.000e2');
      check(printer(4321.768)).equals('+4.322e3');
      check(printer(-53000)).equals('-5.300e4');
      check(printer(6720000000)).equals('+6.720e9');
      check(printer(0.2)).equals('+2.000e-1');
      check(printer(0.00000000751)).equals('+7.510e-9');
    });
    test('nan', () {
      final printer = ScientificNumberPrinter(nan: 'n/a');
      check(printer(0)).equals('0.000e0');
      check(printer(2)).equals('2.000e0');
      check(printer(300)).equals('3.000e2');
      check(printer(4321.768)).equals('4.322e3');
      check(printer(-53000)).equals('-5.300e4');
      check(printer(6720000000)).equals('6.720e9');
      check(printer(0.2)).equals('2.000e-1');
      check(printer(0.00000000751)).equals('7.510e-9');
    });
    test('notation', () {
      final printer = ScientificNumberPrinter(notation: 'E');
      check(printer(0)).equals('0.000E0');
      check(printer(2)).equals('2.000E0');
      check(printer(300)).equals('3.000E2');
      check(printer(4321.768)).equals('4.322E3');
      check(printer(-53000)).equals('-5.300E4');
      check(printer(6720000000)).equals('6.720E9');
      check(printer(0.2)).equals('2.000E-1');
      check(printer(0.00000000751)).equals('7.510E-9');
    });
    test('precision', () {
      final printer = ScientificNumberPrinter(precision: 6);
      check(printer(0)).equals('0.000000e0');
      check(printer(2)).equals('2.000000e0');
      check(printer(300)).equals('3.000000e2');
      check(printer(4321.768)).equals('4.321768e3');
      check(printer(-53000)).equals('-5.300000e4');
      check(printer(6720000000)).equals('6.720000e9');
      check(printer(0.2)).equals('2.000000e-1');
      check(printer(0.00000000751)).equals('7.510000e-9');
    });
    test('separator', () {
      final printer = ScientificNumberPrinter(
        precision: 4,
        separator: ',',
        significant: 4,
      );
      check(printer(0)).equals('0.000,0e0');
      check(printer(2)).equals('2,000.000,0e-3');
      check(printer(300)).equals('3,000.000,0e-1');
      check(printer(4321.768)).equals('4,321.768,0e0');
      check(printer(-53000)).equals('-5,300.000,0e1');
      check(printer(6720000000)).equals('6,720.000,0e6');
      check(printer(0.2)).equals('2,000.000,0e-4');
      check(printer(0.00000000751)).equals('7,510.000,0e-12');
    });
    test('separator with width and offset', () {
      final printer = ScientificNumberPrinter(
        base: 2,
        precision: 8,
        significant: 4,
        separator: '_',
        separatorWidth: 4,
        separatorOffset: 2,
      );
      check(printer(0)).equals('0.00_0000_00e0');
      check(printer(2)).equals('10_00.00_0000_00e-10');
      check(printer(300)).equals('10_01.01_1000_00e1_01');
      check(printer(4321.768)).equals('10_00.01_1100_01e10_01');
      check(printer(-53000)).equals('-11_00.11_1100_01e11_00');
      check(printer(6720000000)).equals('11_00.10_0001_00e111_01');
      check(printer(0.2)).equals('11_00.11_0011_01e-1_10');
      check(printer(0.00000000751)).equals('10_00.00_0100_00e-111_10');
    });
    test('significant', () {
      final printer = ScientificNumberPrinter(significant: 3);
      check(printer(0)).equals('0.000e0');
      check(printer(2)).equals('200.000e-2');
      check(printer(300)).equals('300.000e0');
      check(printer(4321.768)).equals('432.177e1');
      check(printer(-53000)).equals('-530.000e2');
      check(printer(6720000000)).equals('672.000e7');
      check(printer(0.2)).equals('200.000e-3');
      check(printer(0.00000000751)).equals('751.000e-11');
    });
    test('toString', () {
      final printer = ScientificNumberPrinter();
      check(printer.toString()).startsWith('ScientificNumberPrinter<num>');
    });
  });
}
