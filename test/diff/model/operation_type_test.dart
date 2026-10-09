import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('operation type', () {
    test('values', () {
      check(OperationType.values).deepEquals([
        OperationType.replace,
        OperationType.delete,
        OperationType.insert,
        OperationType.equal,
      ]);
    });
    test('names', () {
      check(OperationType.replace.name).equals('replace');
      check(OperationType.delete.name).equals('delete');
      check(OperationType.insert.name).equals('insert');
      check(OperationType.equal.name).equals('equal');
    });
  });
}
