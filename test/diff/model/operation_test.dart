import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('operation', () {
    const operation = Operation(
      OperationType.equal,
      sourceStart: 1,
      sourceEnd: 2,
      targetStart: 2,
      targetEnd: 3,
    );
    const other = Operation(
      OperationType.replace,
      sourceStart: 4,
      sourceEnd: 5,
      targetStart: 6,
      targetEnd: 7,
    );

    test('properties', () {
      check(operation.type).equals(OperationType.equal);
      check(operation.sourceStart).equals(1);
      check(operation.sourceEnd).equals(2);
      check(operation.targetStart).equals(2);
      check(operation.targetEnd).equals(3);
    });

    test('empty', () {
      check(Operation.empty.type).equals(OperationType.equal);
      check(Operation.empty.sourceStart).equals(0);
      check(Operation.empty.sourceEnd).equals(1);
      check(Operation.empty.targetStart).equals(0);
      check(Operation.empty.targetEnd).equals(1);
    });

    test('toString', () {
      check(operation.toString()).endsWith(
        'OperationType.equal, sourceStart: 1, sourceEnd: 2, targetStart: 2, targetEnd: 3)',
      );
    });

    test('equality and hashCode', () {
      check(operation == other).isFalse();
      check(operation == operation).isTrue();
      check(
        operation ==
            const Operation(
              OperationType.equal,
              sourceStart: 1,
              sourceEnd: 2,
              targetStart: 2,
              targetEnd: 3,
            ),
      ).isTrue();
      check(
        operation ==
            const Operation(
              OperationType.delete,
              sourceStart: 1,
              sourceEnd: 2,
              targetStart: 2,
              targetEnd: 3,
            ),
      ).isFalse();
      check(
        operation ==
            const Operation(
              OperationType.equal,
              sourceStart: 9,
              sourceEnd: 2,
              targetStart: 2,
              targetEnd: 3,
            ),
      ).isFalse();
      check(
        operation ==
            const Operation(
              OperationType.equal,
              sourceStart: 1,
              sourceEnd: 9,
              targetStart: 2,
              targetEnd: 3,
            ),
      ).isFalse();
      check(
        operation ==
            const Operation(
              OperationType.equal,
              sourceStart: 1,
              sourceEnd: 2,
              targetStart: 9,
              targetEnd: 3,
            ),
      ).isFalse();
      check(
        operation ==
            const Operation(
              OperationType.equal,
              sourceStart: 1,
              sourceEnd: 2,
              targetStart: 2,
              targetEnd: 9,
            ),
      ).isFalse();
      check(operation.hashCode).not((it) => it.equals(other.hashCode));
      check(operation.hashCode).equals(
        const Operation(
          OperationType.equal,
          sourceStart: 1,
          sourceEnd: 2,
          targetStart: 2,
          targetEnd: 3,
        ).hashCode,
      );
    });
  });
}
