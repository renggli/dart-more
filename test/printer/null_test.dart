import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('ifNull', () {
    test('default', () {
      final printer = standardString.ifNull();
      check(printer(null)).equals('␀');
      check(printer('foo')).equals('foo');
    });
    test('custom', () {
      final printer = standardString.ifNull('n/a');
      check(printer(null)).equals('n/a');
      check(printer('foo')).equals('foo');
    });
    test('toString', () {
      final printer = standardString.ifNull();
      check(printer.toString()).startsWith('NullPrinter<String>');
    });
  });
}
