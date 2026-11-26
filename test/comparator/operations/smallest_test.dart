import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  test('default', () {
    check(naturalInt.smallest([], 0)).isEmpty;
    check(naturalInt.smallest([2, 3, 1], 0)).isEmpty;
    check(naturalInt.smallest([], 3)).isEmpty;
    check(naturalInt.smallest([2, 3, 1], 3)).deepEquals([1, 2, 3]);
    check(naturalInt.smallest([2, 3, 1, 5, 4], 3)).deepEquals([1, 2, 3]);
    check(naturalInt.smallest([], 5)).isEmpty;
    check(naturalInt.smallest([2, 3, 1], 5)).deepEquals([1, 2, 3]);
    check(naturalInt.smallest([2, 3, 1, 5, 4], 5)).deepEquals([1, 2, 3, 4, 5]);
  });

  test('fixed-length result', () {
    check(() => naturalInt.smallest([1, 2, 3], 0).add(4))
        .throws<UnsupportedError>();
    check(() => naturalInt.smallest([], 3).add(4)).throws<UnsupportedError>();
  });

  test('negative k', () {
    check(() => naturalInt.smallest([1, 2, 3], -1)).throws<RangeError>();
  });

  test('k == 0 short-circuit', () {
    var iterated = false;
    final iterable = [1, 2, 3].map((x) {
      iterated = true;
      return x;
    });
    check(naturalInt.smallest(iterable, 0)).isEmpty;
    check(iterated).isFalse;
  });
}
