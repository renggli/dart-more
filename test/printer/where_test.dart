import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('where', () {
    test('printer', () {
      final printer = standardInt.where((value) => value > 0);
      check(printer(1)).equals('1');
      check(printer(-1)).equals('');
    });
    test('toString', () {
      final printer = standardInt.where((value) => value > 0);
      check(printer.toString()).startsWith('WherePrinter<int>');
    });
  });
}
