import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';

void verifyBasic<T>(
  String type,
  Comparator<T> comparator,
  Iterable<T> unsorted,
  Iterable<T> expected,
) {
  final sorted = comparator.sorted(unsorted);
  check(sorted, because: '$type.sorted').deepEquals(expected);
  check(comparator.isOrdered(sorted), because: '$type.isOrdered').isTrue();
  for (final element in unsorted) {
    check(
      comparator.binarySearch(sorted, element),
      because: '$type.binarySearch',
    ).isGreaterOrEqual(0);
  }

  final uniques = sorted.unique().toList();
  for (var i = 0; i < uniques.length - 1; i++) {
    final curr = uniques[i];
    final next = uniques[i + 1];
    // equalTo
    check(comparator.equalTo(curr, curr)).isTrue();
    check(comparator.equalTo(curr, next)).isFalse();
    check(comparator.equalTo(next, curr)).isFalse();
    // notEqualTo
    check(comparator.notEqualTo(curr, curr)).isFalse();
    check(comparator.notEqualTo(curr, next)).isTrue();
    check(comparator.notEqualTo(next, curr)).isTrue();
    // lessThan
    check(comparator.lessThan(curr, curr)).isFalse();
    check(comparator.lessThan(curr, next)).isTrue();
    check(comparator.lessThan(next, curr)).isFalse();
    // lessThanOrEqualTo
    check(comparator.lessThanOrEqualTo(curr, curr)).isTrue();
    check(comparator.lessThanOrEqualTo(curr, next)).isTrue();
    check(comparator.lessThanOrEqualTo(next, curr)).isFalse();
    // greaterThan
    check(comparator.greaterThan(curr, curr)).isFalse();
    check(comparator.greaterThan(curr, next)).isFalse();
    check(comparator.greaterThan(next, curr)).isTrue();
    // greaterThanOrEqualTo
    check(comparator.greaterThanOrEqualTo(curr, curr)).isTrue();
    check(comparator.greaterThanOrEqualTo(curr, next)).isFalse();
    check(comparator.greaterThanOrEqualTo(next, curr)).isTrue();
  }
  if (sorted.isNotEmpty) {
    final minVal = comparator.minOf(unsorted);
    final maxVal = comparator.maxOf(unsorted);
    if (minVal is Iterable && expected.first is Iterable) {
      check(
        minVal as Iterable,
        because: '$type.minOf',
      ).deepEquals(expected.first as Iterable);
    } else {
      check(minVal, because: '$type.minOf').equals(expected.first);
    }
    if (maxVal is Iterable && expected.last is Iterable) {
      check(
        maxVal as Iterable,
        because: '$type.maxOf',
      ).deepEquals(expected.last as Iterable);
    } else {
      check(maxVal, because: '$type.maxOf').equals(expected.last);
    }
  }
}

void verify<T>(
  Comparator<T> comparator,
  Iterable<T> unsorted,
  Iterable<T> expected,
) {
  verifyBasic<T>('comparator', comparator, unsorted, expected);
  verifyBasic<T>(
    'comparator.reversed',
    comparator.reversed,
    unsorted,
    expected.toList().reversed,
  );
}
