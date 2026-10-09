import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('ordered', () {
    test('isOrdered', () {
      check(naturalInt.isOrdered([])).isTrue();
      check(naturalInt.isOrdered([1])).isTrue();
      check(naturalInt.isOrdered([1, 2])).isTrue();
      check(naturalInt.isOrdered([2, 1])).isFalse();
      check(naturalInt.isOrdered([1, 1])).isTrue();
      check(naturalInt.isOrdered([1, 2, 3])).isTrue();
      check(naturalInt.isOrdered([1, 2, 2])).isTrue();
      check(naturalInt.isOrdered([2, 2, 3])).isTrue();
      check(naturalInt.isOrdered([1, 3, 2])).isFalse();
      check(naturalInt.isOrdered([2, 1, 3])).isFalse();
    });

    test('isStrictlyOrdered', () {
      check(naturalInt.isStrictlyOrdered([])).isTrue();
      check(naturalInt.isStrictlyOrdered([1])).isTrue();
      check(naturalInt.isStrictlyOrdered([1, 2])).isTrue();
      check(naturalInt.isStrictlyOrdered([2, 1])).isFalse();
      check(naturalInt.isStrictlyOrdered([1, 1])).isFalse();
      check(naturalInt.isStrictlyOrdered([1, 2, 3])).isTrue();
      check(naturalInt.isStrictlyOrdered([1, 2, 2])).isFalse();
      check(naturalInt.isStrictlyOrdered([2, 2, 3])).isFalse();
      check(naturalInt.isStrictlyOrdered([1, 3, 2])).isFalse();
      check(naturalInt.isStrictlyOrdered([2, 1, 3])).isFalse();
    });
  });
}
