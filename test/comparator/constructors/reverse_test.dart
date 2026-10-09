import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('reverse', () {
    test('int', () {
      const Comparator<int> comparator = reverseComparable<num>;
      verify(comparator, [1, 2, 3], [3, 2, 1]);
      verify(comparator, [2, 3, 1], [3, 2, 1]);
      verify(comparator, [3, 1, 2], [3, 2, 1]);
      verify(comparator, [3, 2, 1], [3, 2, 1]);
    });

    test('num', () {
      const comparator = reverseComparable<num>;
      verify(comparator, [1, 2, 3], [3, 2, 1]);
      verify(comparator, [2, 3, 1], [3, 2, 1]);
      verify(comparator, [3, 1, 2], [3, 2, 1]);
      verify(comparator, [3, 2, 1], [3, 2, 1]);
    });

    test('dynamic', () {
      const comparator = reverseCompare;
      verify(comparator, [1, 2, 3], [3, 2, 1]);
      verify(comparator, [2, 3, 1], [3, 2, 1]);
      verify(comparator, [3, 1, 2], [3, 2, 1]);
      verify(comparator, [3, 2, 1], [3, 2, 1]);
    });
  });
}
