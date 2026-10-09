import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('powerSet', () {
    test('empty', () {
      check(<String>[].powerSet()).deepEquals(<List<String>>[[]]);
    });
    test('example', () {
      check(['x', 'y', 'z'].powerSet()).deepEquals(<List<String>>[
        [],
        ['x'],
        ['y'],
        ['z'],
        ['x', 'y'],
        ['x', 'z'],
        ['y', 'z'],
        ['x', 'y', 'z'],
      ]);
    });
  });
}
