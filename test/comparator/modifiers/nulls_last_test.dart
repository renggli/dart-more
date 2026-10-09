import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;
  const naturalString = naturalComparable<String>;

  group('nullsLast', () {
    test('default', () {
      final comparator = naturalInt.nullsLast;
      verify(comparator, [null, 1, 2, 3], [1, 2, 3, null]);
      verify(comparator, [2, null, 3, 1], [1, 2, 3, null]);
      verify(comparator, [3, 1, null, 2], [1, 2, 3, null]);
      verify(comparator, [3, 2, 1, null], [1, 2, 3, null]);
      verify(comparator.nullsFirst, [1, null, 2], [null, 1, 2]);
    });

    test('regression #4', () {
      final input = <String?>['dog', 'ape', null, 'cat'];
      final comparatorAsc = naturalString.nullsLast;
      check(comparatorAsc.sorted(input))
          .deepEquals(['ape', 'cat', 'dog', null]);
      final comparatorDesc = naturalString.reversed.nullsLast;
      check(comparatorDesc.sorted(input))
          .deepEquals(['dog', 'cat', 'ape', null]);
    });
  });
}
