import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('literal', () {
    test('default', () {
      const printer = Printer<int>.literal();
      check(printer(123)).equals('');
    });
    test('untyped', () {
      const printer = Printer<Object?>.literal('hello');
      check(printer(123)).equals('hello');
      check(printer('abc')).equals('hello');
    });
    test('typed', () {
      const printer = Printer<num>.literal('hello');
      check(printer(123)).equals('hello');
      check(printer(123.4)).equals('hello');
    });
    test('toString', () {
      const printer = Printer<double>.literal('hello');
      check(printer.toString()).startsWith('LiteralPrinter<double>');
    });
  });
}
