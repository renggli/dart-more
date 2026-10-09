import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('largest', () {
    test('default', () {
      check(naturalInt.largest([], 0)).isEmpty();
      check(naturalInt.largest([2, 3, 1], 0)).isEmpty();
      check(naturalInt.largest([], 3)).isEmpty();
      check(naturalInt.largest([2, 3, 1], 3)).deepEquals([3, 2, 1]);
      check(naturalInt.largest([2, 3, 1, 5, 4], 3)).deepEquals([5, 4, 3]);
      check(naturalInt.largest([], 5)).isEmpty();
      check(naturalInt.largest([2, 3, 1], 5)).deepEquals([3, 2, 1]);
      check(naturalInt.largest([2, 3, 1, 5, 4], 5)).deepEquals([5, 4, 3, 2, 1]);
    });
  });
}
