import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('lexicographical', () {
    test('default', () {
      final comparator = naturalInt.lexicographical;
      verify(
        comparator,
        <List<int>>[
          [],
          [1],
          [1, 1],
          [1, 2],
          [2],
        ],
        <List<int>>[
          [],
          [1],
          [1, 1],
          [1, 2],
          [2],
        ],
      );
      verify(
        comparator,
        <List<int>>[
          [2],
          [1, 2],
          [1, 1],
          [1],
          [],
        ],
        <List<int>>[
          [],
          [1],
          [1, 1],
          [1, 2],
          [2],
        ],
      );
    });
  });
}
