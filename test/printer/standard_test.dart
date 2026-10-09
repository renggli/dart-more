import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('standard', () {
    test('untyped', () {
      const printer = Printer<Object?>.standard();
      check(printer(123)).equals('123');
      check(printer('abc')).equals('abc');
    });
    test('typed', () {
      const printer = Printer<num>.standard();
      check(printer(123)).equals('123');
      check(printer(123.4)).equals('123.4');
    });
    test('toString', () {
      const printer = Printer<double>.standard();
      check(printer.toString()).startsWith('StandardPrinter<double>');
    });
  });
}
