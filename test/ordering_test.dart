// ignore_for_file: deprecated_member_use_from_same_package

import 'package:more/collection.dart';
import 'package:more/iterable.dart';
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

  final uniques = sorted.unique().toList();
  for (var i = 0; i < uniques.length - 1; i++) {
    final curr = uniques[i];
    final next = uniques[i + 1];
    // equalTo
    expect(ordering.equalTo(curr)(curr), isTrue);
    expect(ordering.equalTo(curr)(next), isFalse);
    expect(ordering.equalTo(next)(curr), isFalse);
    // equalTo
    expect(ordering.notEqualTo(curr)(curr), isFalse);
    expect(ordering.notEqualTo(curr)(next), isTrue);
    expect(ordering.notEqualTo(next)(curr), isTrue);
    // lessThan
    expect(ordering.lessThan(curr)(curr), isFalse);
    expect(ordering.lessThan(curr)(next), isFalse);
    expect(ordering.lessThan(next)(curr), isTrue);
    // lessThanOrEqualTo
    expect(ordering.lessThanOrEqualTo(curr)(curr), isTrue);
    expect(ordering.lessThanOrEqualTo(curr)(next), isFalse);
    expect(ordering.lessThanOrEqualTo(next)(curr), isTrue);
    // greaterThan
    expect(ordering.greaterThan(curr)(curr), isFalse);
    expect(ordering.greaterThan(curr)(next), isTrue);
    expect(ordering.greaterThan(next)(curr), isFalse);
    // greaterThanOrEqualTo
    expect(ordering.greaterThanOrEqualTo(curr)(curr), isTrue);
    expect(ordering.greaterThanOrEqualTo(curr)(next), isTrue);
    expect(ordering.greaterThanOrEqualTo(next)(curr), isFalse);
  }
  if (sorted.isNotEmpty) {
    expect(ordering.minOf(unsorted), expected.first,
        reason: '$type.percentile');
    expect(ordering.percentile(unsorted, 0.0), expected.first);
    expect(ordering.maxOf(unsorted), expected.last, reason: '$type.maxOf');
    expect(ordering.percentile(unsorted, 1.0), expected.last,
        reason: '$type.percentile');
  }
  expect(ordering.toString(), startsWith(ordering.runtimeType.toString()));
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
  verifyBasic(
    'ordering.reversed.reversed',
    ordering.reversed.reversed,
    unsorted,
    expected,
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
    void binarySearchTest(String name,
        {required List<List<int>> examples,
        required List<int> values,
        required List<int> expected}) {
      test(name, () {
        final results = IntegerRange(examples.length)
            .map((i) => natural.binarySearch(examples[i], values[i]));
        expect(results, expected);
      });
    }

    binarySearchTest(
      'binarySearch empty',
      examples: [[]],
      values: [5],
      expected: [-1],
    );
    binarySearchTest(
      'binarySearch simple',
      examples: [
        [5],
        [1, 5, 6],
        [1, 2, 5, 6, 7],
        [1, 2, 3, 5, 6, 7, 8],
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5, 5],
      expected: [0, 1, 2, 3, 4],
    );
    binarySearchTest(
      'binarySearch simple (absent)',
      examples: [
        [1, 6],
        [1, 2, 6, 7],
        [1, 2, 3, 6, 7, 8],
        [1, 2, 3, 4, 6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5],
      expected: [-2, -3, -4, -5],
    );
    binarySearchTest(
      'binarySearch right most',
      examples: [
        [5],
        [1, 5],
        [1, 2, 5],
        [1, 2, 3, 5],
        [1, 2, 3, 4, 5],
      ],
      values: [5, 5, 5, 5, 5],
      expected: [0, 1, 2, 3, 4],
    );
    binarySearchTest(
      'binarySearch right most (absent)',
      examples: [
        [1],
        [1, 2],
        [1, 2, 3],
        [1, 2, 3, 4],
      ],
      values: [5, 5, 5, 5],
      expected: [-2, -3, -4, -5],
    );
    binarySearchTest(
      'binarySearch left most',
      examples: [
        [5],
        [5, 6],
        [5, 6, 7],
        [5, 6, 7, 8],
        [5, 6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5, 5],
      expected: [0, 0, 0, 0, 0],
    );
    binarySearchTest(
      'binarySearch left most (absent)',
      examples: [
        [6],
        [6, 7],
        [6, 7, 8],
        [6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5],
      expected: [-1, -1, -1, -1],
    );
    binarySearchTest(
      'binarySearch repeated',
      examples: [
        [1, 5, 9],
        [1, 5, 5, 9],
        [1, 5, 5, 5, 9],
        [1, 5, 5, 5, 5, 9],
        [1, 5, 5, 5, 5, 5, 9],
      ],
      values: [5, 5, 5, 5, 5],
      expected: [1, 2, 2, 3, 3],
    );
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
    test('percentile (min = 0)', () {
      expect(natural.percentile([1], 0), 1);
      expect(natural.percentile([1, 2], 0), 1);
      expect(natural.percentile([2, 1], 0), 1);
      expect(natural.percentile([1, 2, 3], 0), 1);
      expect(natural.percentile([1, 3, 2], 0), 1);
      expect(natural.percentile([2, 1, 3], 0), 1);
      expect(natural.percentile([2, 3, 1], 0), 1);
      expect(natural.percentile([3, 1, 2], 0), 1);
      expect(natural.percentile([3, 2, 1], 0), 1);
    });
    test('percentile (median = 50)', () {
      expect(natural.percentile([1], 0.5), 1);
      expect(natural.percentile([1, 2], 0.5), 2);
      expect(natural.percentile([2, 1], 0.5), 2);
      expect(natural.percentile([1, 2, 3], 0.5), 2);
      expect(natural.percentile([1, 3, 2], 0.5), 2);
      expect(natural.percentile([2, 1, 3], 0.5), 2);
      expect(natural.percentile([2, 3, 1], 0.5), 2);
      expect(natural.percentile([3, 1, 2], 0.5), 2);
      expect(natural.percentile([3, 2, 1], 0.5), 2);
    });
    test('percentile (max = 100)', () {
      expect(natural.percentile([1], 1), 1);
      expect(natural.percentile([1, 2], 1), 2);
      expect(natural.percentile([2, 1], 1), 2);
      expect(natural.percentile([1, 2, 3], 1), 3);
      expect(natural.percentile([1, 3, 2], 1), 3);
      expect(natural.percentile([2, 1, 3], 1), 3);
      expect(natural.percentile([2, 3, 1], 1), 3);
      expect(natural.percentile([3, 1, 2], 1), 3);
      expect(natural.percentile([3, 2, 1], 1), 3);
    });

    test('percentile (set)', () {
      expect(natural.percentile({1}, 0.5), 1);
      expect(natural.percentile({1, 2}, 0.5), 2);
      expect(natural.percentile({2, 1}, 0.5), 2);
      expect(natural.percentile({1, 2, 3}, 0.5), 2);
      expect(natural.percentile({1, 3, 2}, 0.5), 2);
      expect(natural.percentile({2, 1, 3}, 0.5), 2);
      expect(natural.percentile({2, 3, 1}, 0.5), 2);
      expect(natural.percentile({3, 1, 2}, 0.5), 2);
      expect(natural.percentile({3, 2, 1}, 0.5), 2);
    });
    test('percentile (isOrdered)', () {
      expect(natural.percentile([1], 0.5, isOrdered: true), 1);
      expect(natural.percentile([1, 2], 0.5, isOrdered: true), 2);
      expect(natural.percentile([2, 1], 0.5, isOrdered: true), 1);
      expect(natural.percentile([1, 2, 3], 0.5, isOrdered: true), 2);
      expect(natural.percentile([1, 3, 2], 0.5, isOrdered: true), 3);
      expect(natural.percentile([2, 1, 3], 0.5, isOrdered: true), 1);
      expect(natural.percentile([2, 3, 1], 0.5, isOrdered: true), 3);
      expect(natural.percentile([3, 1, 2], 0.5, isOrdered: true), 1);
      expect(natural.percentile([3, 2, 1], 0.5, isOrdered: true), 2);
    });
    test('percentile (orElse)', () {
      expect(natural.percentile([1], 0, orElse: () => -1), 1);
      expect(natural.percentile([], 0, orElse: () => -1), -1);
    });
    test('percentile (errors)', () {
      expect(() => natural.percentile([], 0), throwsStateError);
      expect(() => natural.percentile([1], -1), throwsRangeError);
      expect(() => natural.percentile([1], 2), throwsRangeError);
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
