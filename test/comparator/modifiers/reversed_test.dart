import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('reversed', () {
    test('default', () {
      final comparator = naturalInt.reversed;
      verify(comparator, [1, 2, 3], [3, 2, 1]);
      verify(comparator, [2, 3, 1], [3, 2, 1]);
      verify(comparator, [3, 1, 2], [3, 2, 1]);
      verify(comparator, [3, 2, 1], [3, 2, 1]);
    });

    test('double', () {
      final comparator = naturalInt.reversed.reversed;
      verify(comparator, [1, 2, 3], [1, 2, 3]);
      verify(comparator, [2, 3, 1], [1, 2, 3]);
      verify(comparator, [3, 1, 2], [1, 2, 3]);
      verify(comparator, [3, 2, 1], [1, 2, 3]);
    });
  });
}
