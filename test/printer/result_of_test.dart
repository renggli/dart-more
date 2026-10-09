import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('onResultOf', () {
    test('printer', () {
      final printer = standardInt.onResultOf(int.parse);
      check(() => printer('')).throws<FormatException>();
      check(printer('1')).equals('1');
      check(printer('12')).equals('12');
    });
    test('cast', () {
      final printer = standardString.cast<Object>();
      check(() => printer(0)).throws<TypeError>();
      check(printer('1')).equals('1');
      check(printer('12')).equals('12');
    });
    test('toString', () {
      final printer = standardInt.onResultOf(int.parse);
      check(printer.toString()).startsWith('ResultOfPrinter<String, int>');
    });
  });
}
