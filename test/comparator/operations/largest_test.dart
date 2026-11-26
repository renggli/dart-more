import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  test('default', () {
    check(naturalInt.largest([], 0)).isEmpty;
    check(naturalInt.largest([2, 3, 1], 0)).isEmpty;
    check(naturalInt.largest([], 3)).isEmpty;
    check(naturalInt.largest([2, 3, 1], 3)).deepEquals([3, 2, 1]);
    check(naturalInt.largest([2, 3, 1, 5, 4], 3)).deepEquals([5, 4, 3]);
    check(naturalInt.largest([], 5)).isEmpty;
    check(naturalInt.largest([2, 3, 1], 5)).deepEquals([3, 2, 1]);
    check(naturalInt.largest([2, 3, 1, 5, 4], 5)).deepEquals([5, 4, 3, 2, 1]);
  });

  test('fixed-length result', () {
    check(() => naturalInt.largest([1, 2, 3], 0).add(4))
        .throws<UnsupportedError>();
    check(() => naturalInt.largest([], 3).add(4)).throws<UnsupportedError>();
    check(() => naturalInt.largest([1, 2, 3], 2).add(4))
        .throws<UnsupportedError>();
  });

  test('negative k', () {
    check(() => naturalInt.largest([1, 2, 3], -1)).throws<RangeError>();
  });

  test('k == 0 short-circuit', () {
    var iterated = false;
    final iterable = [1, 2, 3].map((x) {
      iterated = true;
      return x;
    });
    check(naturalInt.largest(iterable, 0)).isEmpty;
    check(iterated).isFalse;
  });
}
