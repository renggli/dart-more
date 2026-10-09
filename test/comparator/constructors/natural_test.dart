import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('natural', () {
    test('int', () {
      const Comparator<int> comparator = naturalComparable<num>;
      verify(comparator, [1, 2, 3], [1, 2, 3]);
      verify(comparator, [2, 3, 1], [1, 2, 3]);
      verify(comparator, [3, 1, 2], [1, 2, 3]);
      verify(comparator, [3, 2, 1], [1, 2, 3]);
    });

    test('num', () {
      const comparator = naturalComparable<num>;
      verify(comparator, [1, 2, 3], [1, 2, 3]);
      verify(comparator, [2, 3, 1], [1, 2, 3]);
      verify(comparator, [3, 1, 2], [1, 2, 3]);
      verify(comparator, [3, 2, 1], [1, 2, 3]);
    });

    test('dynamic', () {
      const comparator = naturalCompare;
      verify(comparator, [1, 2, 3], [1, 2, 3]);
      verify(comparator, [2, 3, 1], [1, 2, 3]);
      verify(comparator, [3, 1, 2], [1, 2, 3]);
      verify(comparator, [3, 2, 1], [1, 2, 3]);
    });
  });
}
