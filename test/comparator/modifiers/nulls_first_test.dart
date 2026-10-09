import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('nullsFirst', () {
    test('default', () {
      final comparator = naturalInt.nullsFirst;
      verify(comparator, [null, 1, 2, 3], [null, 1, 2, 3]);
      verify(comparator, [2, null, 3, 1], [null, 1, 2, 3]);
      verify(comparator, [3, 1, null, 2], [null, 1, 2, 3]);
      verify(comparator, [3, 2, 1, null], [null, 1, 2, 3]);
      verify(comparator.nullsLast, [1, null, 2], [1, 2, null]);
    });
  });
}
