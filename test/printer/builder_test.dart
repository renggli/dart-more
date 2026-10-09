import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('builder', () {
    test('mapIf true', () {
      final printer = standardString.mapIf(
        true,
        (printer) => printer.around('[', ']'),
      );
      check(printer('hello')).equals('[hello]');
    });
    test('mapIf false', () {
      final printer = standardString.mapIf(
        false,
        (printer) => printer.around('[', ']'),
      );
      check(printer('hello')).equals('hello');
    });
  });
}
