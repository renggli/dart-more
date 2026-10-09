import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('explicit', () {
    test('ordering', () {
      final comparator = explicitComparator(const [2, 3, 1]);
      verify(comparator, [3, 2], [2, 3]);
      verify(comparator, [1, 2], [2, 1]);
      verify(comparator, [1, 2, 3], [2, 3, 1]);
      verify(comparator, [2, 3, 1], [2, 3, 1]);
    });

    test('missing element', () {
      final comparator = explicitComparator(const [2, 3, 1]);
      check(() => comparator.binarySearch([2, 3, 1], 4)).throws<StateError>();
      check(() => comparator.binarySearch([2, 4, 1], 3)).throws<StateError>();
    });
  });
}
