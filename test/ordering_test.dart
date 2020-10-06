import 'package:more/ordering.dart';
import 'package:test/test.dart';

void verifyBasic<T>(String type, Ordering<T> ordering, Iterable<T> unsorted,
    Iterable<T> expected) {
  final sorted = ordering.sorted(unsorted);
  expect(sorted, expected, reason: '$type.sorted');
  expect(ordering.isOrdered(sorted), isTrue, reason: '$type.isOrdered');
  for (final element in unsorted) {
    expect(ordering.binarySearch(sorted, element),
        (index) => index is int && index >= 0,
        reason: '$type.binarySearch');
  }
  if (sorted.isNotEmpty) {
    expect(ordering.minOf(unsorted), expected.first, reason: '$type.minOf');
    expect(ordering.maxOf(unsorted), expected.last, reason: '$type.maxOf');
  }
}

void verify<T>(
    Ordering<T> ordering, Iterable<T> unsorted, Iterable<T> expected) {
  verifyBasic(
    'ordering',
    ordering,
    unsorted,
    expected,
  );
  verifyBasic(
    'ordering.reversed',
    ordering.reversed,
    unsorted,
    expected.toList().reversed,
  );
  if (!unsorted.contains(null)) {
    verifyBasic(
      'ordering.nullsFirst',
      ordering.nullsFirst,
      <T?>[null, ...unsorted, null],
      <T?>[null, null, ...expected],
    );
    verifyBasic(
      'ordering.nullsLast',
      ordering.nullsLast,
      <T?>[null, ...unsorted, null],
      <T?>[...expected, null, null],
    );
  }
}

void main() {
  group('orders', () {
    int stringLengthComparator(String a, String b) => a.length - b.length;
    test('natural', () {
      final ordering = Ordering.natural<num>();
      verify(ordering, [1, 2, 3], [1, 2, 3]);
      verify(ordering, [2, 3, 1], [1, 2, 3]);
      verify(ordering, [3, 1, 2], [1, 2, 3]);
      verify(ordering, [3, 2, 1], [1, 2, 3]);
    });
    test('comparator (of)', () {
      final ordering = Ordering<String>.of(stringLengthComparator);
      verify(ordering, ['*', '**', '***'], ['*', '**', '***']);
      verify(ordering, ['**', '***', '*'], ['*', '**', '***']);
      verify(ordering, ['***', '*', '**'], ['*', '**', '***']);
      verify(ordering, ['***', '**', '*'], ['*', '**', '***']);
    });
    test('comparator (from)', () {
      final ordering = Ordering<String>.from(stringLengthComparator);
      verify(ordering, ['*', '**', '***'], ['*', '**', '***']);
      verify(ordering, ['**', '***', '*'], ['*', '**', '***']);
      verify(ordering, ['***', '*', '**'], ['*', '**', '***']);
      verify(ordering, ['***', '**', '*'], ['*', '**', '***']);
    });
    test('comparator (toOrdering)', () {
      final ordering = stringLengthComparator.toOrdering();
      verify(ordering, ['*', '**', '***'], ['*', '**', '***']);
      verify(ordering, ['**', '***', '*'], ['*', '**', '***']);
      verify(ordering, ['***', '*', '**'], ['*', '**', '***']);
      verify(ordering, ['***', '**', '*'], ['*', '**', '***']);
    });
    test('explicit', () {
      final ordering = Ordering.explicit(const [2, 3, 1]);
      verify(ordering, [3, 2], [2, 3]);
      verify(ordering, [1, 2], [2, 1]);
      verify(ordering, [1, 2, 3], [2, 3, 1]);
      verify(ordering, [2, 3, 1], [2, 3, 1]);
      expect(() => ordering.binarySearch([2, 3, 1], 4), throwsStateError);
      expect(() => ordering.binarySearch([2, 4, 1], 3), throwsStateError);
    });
  });
  group('operators', () {
    test('reversed', () {
      final ordering = Ordering.natural<num>().lexicographical;
      expect(ordering.reversed.reversed, same(ordering));
    });
    test('natural (reversed)', () {
      final ordering = Ordering.natural<num>().reversed;
      verify(ordering, [1, 2, 3], [3, 2, 1]);
      verify(ordering, [2, 3, 1], [3, 2, 1]);
      verify(ordering, [3, 1, 2], [3, 2, 1]);
      verify(ordering, [3, 2, 1], [3, 2, 1]);
    });
    test('natural (double reversed)', () {
      final ordering = Ordering.natural<num>().reversed.reversed;
      verify(ordering, [1, 2, 3], [1, 2, 3]);
      verify(ordering, [2, 3, 1], [1, 2, 3]);
      verify(ordering, [3, 1, 2], [1, 2, 3]);
      verify(ordering, [3, 2, 1], [1, 2, 3]);
    });
    test('lexicographical', () {
      final ordering = Ordering.natural<num>().lexicographical;
      verify(ordering, [
        <int>[],
        [1],
        [1, 1],
        [1, 2],
        [2]
      ], [
        <int>[],
        [1],
        [1, 1],
        [1, 2],
        [2]
      ]);
      verify(ordering, [
        [2],
        [1, 2],
        [1, 1],
        [1],
        <int>[]
      ], [
        <int>[],
        [1],
        [1, 1],
        [1, 2],
        [2]
      ]);
    });
    test('nullsFirst', () {
      final ordering = Ordering.natural<num>().nullsFirst;
      expect(ordering.nullsFirst, same(ordering));
      verify(ordering, [null, 1, 2, 3], [null, 1, 2, 3]);
      verify(ordering, [2, null, 3, 1], [null, 1, 2, 3]);
      verify(ordering, [3, 1, null, 2], [null, 1, 2, 3]);
      verify(ordering, [3, 2, 1, null], [null, 1, 2, 3]);
      verify(ordering.nullsLast, [1, null, 2], [1, 2, null]);
    });
    test('nullsLast', () {
      final ordering = Ordering.natural<num>().nullsLast;
      expect(ordering.nullsLast, same(ordering));
      verify(ordering, [null, 1, 2, 3], [1, 2, 3, null]);
      verify(ordering, [2, null, 3, 1], [1, 2, 3, null]);
      verify(ordering, [3, 1, null, 2], [1, 2, 3, null]);
      verify(ordering, [3, 2, 1, null], [1, 2, 3, null]);
      verify(ordering.nullsFirst, [1, null, 2], [null, 1, 2]);
    });
    test('compound', () {
      final ordering = Ordering.natural<num>()
          .onResultOf<String>((s) => s.length)
          .compound(Ordering.natural());
      verify(ordering, ['333', '1', '4444', '22'], ['1', '22', '333', '4444']);
      verify(ordering, ['2', '333', '4444', '1', '22'],
          ['1', '2', '22', '333', '4444']);
      verify(ordering, ['33', '333', '2', '22', '1', '4444'],
          ['1', '2', '22', '33', '333', '4444']);
      verify(ordering, ['4444', '44', '2', '1', '333', '22', '33'],
          ['1', '2', '22', '33', '44', '333', '4444']);
    });
    test('compound of compound', () {
      final ordering = Ordering.natural<num>()
          .onResultOf<List<int>>((list) => list[0])
          .compound(
              Ordering.natural<num>().onResultOf<List<int>>((list) => list[1]))
          .compound(
              Ordering.natural<num>().onResultOf<List<int>>((list) => list[2]));
      verify(ordering, [
        [2, 0, 0],
        [1, 0, 0]
      ], [
        [1, 0, 0],
        [2, 0, 0]
      ]);
      verify(ordering, [
        [0, 2, 0],
        [0, 1, 0]
      ], [
        [0, 1, 0],
        [0, 2, 0]
      ]);
      verify(ordering, [
        [0, 0, 2],
        [0, 0, 1]
      ], [
        [0, 0, 1],
        [0, 0, 2]
      ]);
    });
    test('onResultOf', () {
      final ordering =
          Ordering.natural<num>().onResultOf<String>((s) => s.length);
      verify(ordering, ['*', '**', '***'], ['*', '**', '***']);
      verify(ordering, ['**', '***', '*'], ['*', '**', '***']);
      verify(ordering, ['***', '*', '**'], ['*', '**', '***']);
      verify(ordering, ['***', '**', '*'], ['*', '**', '***']);
    });
  });
  group('actions', () {
    final natural = Ordering.natural<num>();
    test('binarySearch empty', () {
      expect(natural.binarySearch([], 5), -1);
    });
    test('binarySearch simple', () {
      expect(natural.binarySearch([5], 5), 0);
      expect(natural.binarySearch([1, 5, 6], 5), 1);
      expect(natural.binarySearch([1, 2, 5, 6, 7], 5), 2);
      expect(natural.binarySearch([1, 2, 3, 5, 6, 7, 8], 5), 3);
      expect(natural.binarySearch([1, 2, 3, 4, 5, 6, 7, 8, 9], 5), 4);
    });
    test('binarySearch right most', () {
      expect(natural.binarySearch([5], 5), 0);
      expect(natural.binarySearch([1, 5], 5), 1);
      expect(natural.binarySearch([1, 2, 5], 5), 2);
      expect(natural.binarySearch([1, 2, 3, 5], 5), 3);
      expect(natural.binarySearch([1, 2, 3, 4, 5], 5), 4);
    });
    test('binarySearch left most', () {
      expect(natural.binarySearch([5], 5), 0);
      expect(natural.binarySearch([5, 6], 5), 0);
      expect(natural.binarySearch([5, 6, 7], 5), 0);
      expect(natural.binarySearch([5, 6, 7, 8], 5), 0);
      expect(natural.binarySearch([5, 6, 7, 8, 9], 5), 0);
    });
    test('sorted', () {
      expect(natural.sorted([]), []);
      expect(natural.sorted([1]), [1]);
      expect(natural.sorted([1, 2]), [1, 2]);
      expect(natural.sorted([2, 1]), [1, 2]);
      expect(natural.sorted([1, 2, 3]), [1, 2, 3]);
      expect(natural.sorted([1, 3, 2]), [1, 2, 3]);
      expect(natural.sorted([2, 1, 3]), [1, 2, 3]);
      expect(natural.sorted([2, 3, 1]), [1, 2, 3]);
      expect(natural.sorted([3, 1, 2]), [1, 2, 3]);
      expect(natural.sorted([3, 2, 1]), [1, 2, 3]);
    });
    test('isOrdered', () {
      expect(natural.isOrdered([]), isTrue);
      expect(natural.isOrdered([1]), isTrue);
      expect(natural.isOrdered([1, 2]), isTrue);
      expect(natural.isOrdered([2, 1]), isFalse);
      expect(natural.isOrdered([1, 1]), isTrue);
      expect(natural.isOrdered([1, 2, 3]), isTrue);
      expect(natural.isOrdered([1, 2, 2]), isTrue);
      expect(natural.isOrdered([2, 2, 3]), isTrue);
      expect(natural.isOrdered([1, 3, 2]), isFalse);
      expect(natural.isOrdered([2, 1, 3]), isFalse);
    });
    test('isStrictlyOrdered', () {
      expect(natural.isStrictlyOrdered([]), isTrue);
      expect(natural.isStrictlyOrdered([1]), isTrue);
      expect(natural.isStrictlyOrdered([1, 2]), isTrue);
      expect(natural.isStrictlyOrdered([2, 1]), isFalse);
      expect(natural.isStrictlyOrdered([1, 1]), isFalse);
      expect(natural.isStrictlyOrdered([1, 2, 3]), isTrue);
      expect(natural.isStrictlyOrdered([1, 2, 2]), isFalse);
      expect(natural.isStrictlyOrdered([2, 2, 3]), isFalse);
      expect(natural.isStrictlyOrdered([1, 3, 2]), isFalse);
      expect(natural.isStrictlyOrdered([2, 1, 3]), isFalse);
    });
    test('max', () {
      expect(natural.max(1, 1), 1);
      expect(natural.max(1, 2), 2);
      expect(natural.max(2, 1), 2);
      expect(natural.max(2, 2), 2);
    });
    test('maxOf', () {
      expect(() => natural.maxOf([]), throwsStateError);
      expect(natural.maxOf([1]), 1);
      expect(natural.maxOf([1, 2]), 2);
      expect(natural.maxOf([2, 1]), 2);
      expect(natural.maxOf([1, 2, 3]), 3);
      expect(natural.maxOf([1, 3, 2]), 3);
      expect(natural.maxOf([2, 1, 3]), 3);
      expect(natural.maxOf([2, 3, 1]), 3);
      expect(natural.maxOf([3, 1, 2]), 3);
      expect(natural.maxOf([3, 2, 1]), 3);
    });
    test('maxOf orElse', () {
      expect(natural.maxOf([], orElse: () => -1), -1);
      expect(natural.maxOf([1], orElse: () => -1), 1);
      expect(natural.maxOf([1, 2], orElse: () => -1), 2);
      expect(natural.maxOf([1, 2, 3], orElse: () => -1), 3);
    });
    test('min', () {
      expect(natural.min(1, 1), 1);
      expect(natural.min(1, 2), 1);
      expect(natural.min(2, 1), 1);
      expect(natural.min(2, 2), 2);
    });
    test('minOf', () {
      expect(() => natural.minOf([]), throwsStateError);
      expect(natural.minOf([1]), 1);
      expect(natural.minOf([1, 2]), 1);
      expect(natural.minOf([2, 1]), 1);
      expect(natural.minOf([1, 2, 3]), 1);
      expect(natural.minOf([1, 3, 2]), 1);
      expect(natural.minOf([2, 1, 3]), 1);
      expect(natural.minOf([2, 3, 1]), 1);
      expect(natural.minOf([3, 1, 2]), 1);
      expect(natural.minOf([3, 2, 1]), 1);
    });
    test('minOf orElse', () {
      expect(natural.minOf([], orElse: () => -1), -1);
      expect(natural.minOf([1], orElse: () => -1), 1);
      expect(natural.minOf([1, 2], orElse: () => -1), 1);
      expect(natural.minOf([1, 2, 3], orElse: () => -1), 1);
    });
  });
  group('regressions', () {
    test('#4', () {
      final input = <String?>['dog', 'ape', null, 'cat'];
      final orderingAsc = Ordering.natural<String>().nullsLast;
      expect(orderingAsc.sorted(input), ['ape', 'cat', 'dog', null]);
      final orderingDesc = Ordering.natural<String>().reversed.nullsLast;
      expect(orderingDesc.sorted(input), ['dog', 'cat', 'ape', null]);
    });
  });
}
