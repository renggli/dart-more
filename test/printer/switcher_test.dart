import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('switcher', () {
    test('default', () {
      final printer = Printer<int>.switcher({
        (value) => value < 1: const Printer.literal('<1'),
        (value) => value < 10: const Printer.literal('<10'),
        (value) => value < 100: const Printer.literal('<100'),
      }, otherwise: const Printer.literal('larger'));
      check(printer(0)).equals('<1');
      check(printer(5)).equals('<10');
      check(printer(50)).equals('<100');
      check(printer(500)).equals('larger');
    });
    test('missing otherwise', () {
      final printer = Printer<int>.switcher({
        (value) => value < 1: const Printer.literal('<1'),
        (value) => value < 10: const Printer.literal('<10'),
        (value) => value < 100: const Printer.literal('<100'),
      });
      check(printer(0)).equals('<1');
      check(printer(5)).equals('<10');
      check(printer(50)).equals('<100');
      check(printer(500)).equals('');
    });
    test('toString', () {
      const printer = Printer<int>.switcher({});
      check(printer.toString()).startsWith('SwitcherPrinter');
    });
  });
}
