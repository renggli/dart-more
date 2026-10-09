import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('smallest', () {
    test('default', () {
      check(naturalInt.smallest([], 0)).isEmpty();
      check(naturalInt.smallest([2, 3, 1], 0)).isEmpty();
      check(naturalInt.smallest([], 3)).isEmpty();
      check(naturalInt.smallest([2, 3, 1], 3)).deepEquals([1, 2, 3]);
      check(naturalInt.smallest([2, 3, 1, 5, 4], 3)).deepEquals([1, 2, 3]);
      check(naturalInt.smallest([], 5)).isEmpty();
      check(naturalInt.smallest([2, 3, 1], 5)).deepEquals([1, 2, 3]);
      check(naturalInt.smallest([2, 3, 1, 5, 4], 5))
          .deepEquals([1, 2, 3, 4, 5]);
    });
  });
}
