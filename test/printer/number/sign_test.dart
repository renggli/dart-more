import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('sign', () {
    group('int', () {
      test('default', () {
        const printer = SignNumberPrinter<int>();
        check(printer(-1)).equals('-');
        check(printer(1)).equals('');
      });
      test('custom', () {
        const printer = SignNumberPrinter<int>(
          negative: Printer.literal('--'),
          positive: Printer.literal('++'),
        );
        check(printer(-1)).equals('--');
        check(printer(1)).equals('++');
      });
      test('omitPositiveSign', () {
        const printer = SignNumberPrinter<int>.omitPositiveSign();
        check(printer(-1)).equals('-');
        check(printer(1)).equals('');
      });
      test('spacePositiveSign', () {
        const printer = SignNumberPrinter<int>.spacePositiveSign();
        check(printer(-1)).equals('-');
        check(printer(1)).equals(' ');
      });
      test('negativeAndPositiveSign', () {
        const printer = SignNumberPrinter<int>.negativeAndPositiveSign();
        check(printer(-1)).equals('-');
        check(printer(1)).equals('+');
      });
    });
    group('double', () {
      test('default', () {
        const printer = SignNumberPrinter<double>();
        check(printer(-1.1)).equals('-');
        check(printer(1.1)).equals('');
      });
      test('custom', () {
        const printer = SignNumberPrinter<double>(
          negative: Printer.literal('--'),
          positive: Printer.literal('++'),
        );
        check(printer(-1.1)).equals('--');
        check(printer(1.1)).equals('++');
      });
      test('omitPositiveSign', () {
        const printer = SignNumberPrinter<double>.omitPositiveSign();
        check(printer(-1.1)).equals('-');
        check(printer(1.1)).equals('');
      });
      test('spacePositiveSign', () {
        const printer = SignNumberPrinter<double>.spacePositiveSign();
        check(printer(-1.1)).equals('-');
        check(printer(1.1)).equals(' ');
      });
      test('negativeAndPositiveSign', () {
        const printer = SignNumberPrinter<double>.negativeAndPositiveSign();
        check(printer(-1.1)).equals('-');
        check(printer(1.1)).equals('+');
      });
    });
    test('toString', () {
      const printer = SignNumberPrinter<num>.negativeAndPositiveSign();
      check(printer.toString()).equals(
        'SignNumberPrinter<num>('
        'negative: LiteralPrinter<Never>(value: -), '
        'positive: LiteralPrinter<Never>(value: +))',
      );
    });
  });
}
