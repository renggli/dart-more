import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/iterable.dart';
import 'package:more/tuple.dart';
import 'package:test/test.dart';

void verifyBasic<T>(String type, Comparator<T> comparator, Iterable<T> unsorted,
    Iterable<T> expected) {
  final sorted = comparator.sorted(unsorted);
  expect(sorted, expected, reason: '$type.sorted');
  expect(comparator.isOrdered(sorted), isTrue, reason: '$type.isOrdered');
  for (final element in unsorted) {
    expect(comparator.binarySearch(sorted, element),
        (index) => index is int && index >= 0,
        reason: '$type.binarySearch');
  }

  final uniques = sorted.unique().toList();
  for (var i = 0; i < uniques.length - 1; i++) {
    final curr = uniques[i];
    final next = uniques[i + 1];
    // equalTo
    expect(comparator.equalTo(curr)(curr), isTrue);
    expect(comparator.equalTo(curr)(next), isFalse);
    expect(comparator.equalTo(next)(curr), isFalse);
    // equalTo
    expect(comparator.notEqualTo(curr)(curr), isFalse);
    expect(comparator.notEqualTo(curr)(next), isTrue);
    expect(comparator.notEqualTo(next)(curr), isTrue);
    // lessThan
    expect(comparator.lessThan(curr)(curr), isFalse);
    expect(comparator.lessThan(curr)(next), isFalse);
    expect(comparator.lessThan(next)(curr), isTrue);
    // lessThanOrEqualTo
    expect(comparator.lessThanOrEqualTo(curr)(curr), isTrue);
    expect(comparator.lessThanOrEqualTo(curr)(next), isFalse);
    expect(comparator.lessThanOrEqualTo(next)(curr), isTrue);
    // greaterThan
    expect(comparator.greaterThan(curr)(curr), isFalse);
    expect(comparator.greaterThan(curr)(next), isTrue);
    expect(comparator.greaterThan(next)(curr), isFalse);
    // greaterThanOrEqualTo
    expect(comparator.greaterThanOrEqualTo(curr)(curr), isTrue);
    expect(comparator.greaterThanOrEqualTo(curr)(next), isTrue);
    expect(comparator.greaterThanOrEqualTo(next)(curr), isFalse);
  }
  if (sorted.isNotEmpty) {
    expect(comparator.minOf(unsorted), expected.first,
        reason: '$type.percentile');
    //expect(comparator.percentile(unsorted, 0.0), expected.first);
    expect(comparator.maxOf(unsorted), expected.last, reason: '$type.maxOf');
    // expect(comparator.percentile(unsorted, 1.0), expected.last,
    //     reason: '$type.percentile');
  }
}

void verify<T>(
    Comparator<T> comparator, Iterable<T> unsorted, Iterable<T> expected) {
  verifyBasic<T>(
    'comparator',
    comparator,
    unsorted,
    expected,
  );
  verifyBasic<T>(
    'comparator.reversed',
    comparator.reversed,
    unsorted,
    expected.toList().reversed,
  );
}

void binarySearchTests<T>(
  String name, {
  required List<List<T>> examples,
  required List<T> values,
  required List<T> binarySearch,
  required List<T> binarySearchLower,
  required List<T> binarySearchUpper,
}) {
  group(name, () {
    final comparator = naturalComparator<T>();
    test('binarySearch', () {
      final results = IntegerRange(examples.length)
          .map((i) => comparator.binarySearch(examples[i], values[i]));
      expect(results, binarySearch);
    });
    test('binarySearchLower', () {
      final results = IntegerRange(examples.length)
          .map((i) => comparator.binarySearchLower(examples[i], values[i]));
      expect(results, binarySearchLower);
    });
    test('binarySearchUpper', () {
      final results = IntegerRange(examples.length)
          .map((i) => comparator.binarySearchUpper(examples[i], values[i]));
      expect(results, binarySearchUpper);
    });
  });
}

void main() {
  final naturalInt = naturalComparator<int>();
  final naturalString = naturalComparator<String>();
  group('constructors', () {
    test('explicit', () {
      final comparator = explicitComparator(const [2, 3, 1]);
      verify(comparator, [3, 2], [2, 3]);
      verify(comparator, [1, 2], [2, 1]);
      verify(comparator, [1, 2, 3], [2, 3, 1]);
      verify(comparator, [2, 3, 1], [2, 3, 1]);
      expect(() => comparator.binarySearch([2, 3, 1], 4), throwsStateError);
      expect(() => comparator.binarySearch([2, 4, 1], 3), throwsStateError);
    });
    group('natural', () {
      test('int', () {
        final comparator = naturalComparator<int>();
        verify(comparator, [1, 2, 3], [1, 2, 3]);
        verify(comparator, [2, 3, 1], [1, 2, 3]);
        verify(comparator, [3, 1, 2], [1, 2, 3]);
        verify(comparator, [3, 2, 1], [1, 2, 3]);
      });
      test('num', () {
        final comparator = naturalComparator<num>();
        verify(comparator, [1, 2, 3], [1, 2, 3]);
        verify(comparator, [2, 3, 1], [1, 2, 3]);
        verify(comparator, [3, 1, 2], [1, 2, 3]);
        verify(comparator, [3, 2, 1], [1, 2, 3]);
      });
      test('dynamic', () {
        final comparator = naturalComparator();
        verify(comparator, [1, 2, 3], [1, 2, 3]);
        verify(comparator, [2, 3, 1], [1, 2, 3]);
        verify(comparator, [3, 1, 2], [1, 2, 3]);
        verify(comparator, [3, 2, 1], [1, 2, 3]);
      });
    });
    group('reverse', () {
      test('int', () {
        final comparator = reverseComparator<int>();
        verify(comparator, [1, 2, 3], [3, 2, 1]);
        verify(comparator, [2, 3, 1], [3, 2, 1]);
        verify(comparator, [3, 1, 2], [3, 2, 1]);
        verify(comparator, [3, 2, 1], [3, 2, 1]);
      });
      test('num', () {
        final comparator = reverseComparator<num>();
        verify(comparator, [1, 2, 3], [3, 2, 1]);
        verify(comparator, [2, 3, 1], [3, 2, 1]);
        verify(comparator, [3, 1, 2], [3, 2, 1]);
        verify(comparator, [3, 2, 1], [3, 2, 1]);
      });
      test('dynamic', () {
        final comparator = reverseComparator();
        verify(comparator, [1, 2, 3], [3, 2, 1]);
        verify(comparator, [2, 3, 1], [3, 2, 1]);
        verify(comparator, [3, 1, 2], [3, 2, 1]);
        verify(comparator, [3, 2, 1], [3, 2, 1]);
      });
    });
  });
  group('modifiers', () {
    group('compound', () {
      test('default', () {
        final comparator = naturalInt
            .onResultOf<String>((s) => s.length)
            .thenCompare(naturalString);
        verify(
            comparator, ['333', '1', '4444', '22'], ['1', '22', '333', '4444']);
        verify(comparator, ['2', '333', '4444', '1', '22'],
            ['1', '2', '22', '333', '4444']);
        verify(comparator, ['33', '333', '2', '22', '1', '4444'],
            ['1', '2', '22', '33', '333', '4444']);
        verify(comparator, ['4444', '44', '2', '1', '333', '22', '33'],
            ['1', '2', '22', '33', '44', '333', '4444']);
      });
      test('input', () {
        final comparator = [
          naturalInt.onResultOf<List<int>>((value) => value[0]),
          naturalInt.onResultOf<List<int>>((value) => value[1]),
          naturalInt.onResultOf<List<int>>((value) => value[2]),
        ].toComparator();
        verify(comparator, [
          [2, 0, 0],
          [1, 0, 0]
        ], [
          [1, 0, 0],
          [2, 0, 0]
        ]);
        verify(comparator, [
          [0, 2, 0],
          [0, 1, 0]
        ], [
          [0, 1, 0],
          [0, 2, 0]
        ]);
        verify(comparator, [
          [0, 0, 2],
          [0, 0, 1]
        ], [
          [0, 0, 1],
          [0, 0, 2]
        ]);
      });
    });
    test('nullsFirst', () {
      final comparator = naturalInt.nullsFirst;
      verify(comparator, [null, 1, 2, 3], [null, 1, 2, 3]);
      verify(comparator, [2, null, 3, 1], [null, 1, 2, 3]);
      verify(comparator, [3, 1, null, 2], [null, 1, 2, 3]);
      verify(comparator, [3, 2, 1, null], [null, 1, 2, 3]);
      verify(comparator.nullsLast, [1, null, 2], [1, 2, null]);
    });
    test('nullsLast', () {
      final comparator = naturalInt.nullsLast;
      verify(comparator, [null, 1, 2, 3], [1, 2, 3, null]);
      verify(comparator, [2, null, 3, 1], [1, 2, 3, null]);
      verify(comparator, [3, 1, null, 2], [1, 2, 3, null]);
      verify(comparator, [3, 2, 1, null], [1, 2, 3, null]);
      verify(comparator.nullsFirst, [1, null, 2], [null, 1, 2]);
    });
    test('onResultOf', () {
      final comparator = naturalInt.onResultOf<String>((s) => s.length);
      verify(comparator, ['*', '**', '***'], ['*', '**', '***']);
      verify(comparator, ['**', '***', '*'], ['*', '**', '***']);
      verify(comparator, ['***', '*', '**'], ['*', '**', '***']);
      verify(comparator, ['***', '**', '*'], ['*', '**', '***']);
    });
    group('reversed', () {
      test('default', () {
        final comparator = naturalInt.reversed;
        verify(comparator, [1, 2, 3], [3, 2, 1]);
        verify(comparator, [2, 3, 1], [3, 2, 1]);
        verify(comparator, [3, 1, 2], [3, 2, 1]);
        verify(comparator, [3, 2, 1], [3, 2, 1]);
      });
      test('double', () {
        final comparator = naturalInt.reversed.reversed;
        verify(comparator, [1, 2, 3], [1, 2, 3]);
        verify(comparator, [2, 3, 1], [1, 2, 3]);
        verify(comparator, [3, 1, 2], [1, 2, 3]);
        verify(comparator, [3, 2, 1], [1, 2, 3]);
      });
    });
  });
  group('operations', () {
    group('binarySearch', () {
      binarySearchTests(
        'empty',
        examples: [[], [], []],
        values: [-5, 0, 5],
        binarySearch: [-1, -1, -1],
        binarySearchLower: [0, 0, 0],
        binarySearchUpper: [0, 0, 0],
      );
      binarySearchTests(
        'simple present',
        examples: [
          [5],
          [1, 5, 6],
          [1, 2, 5, 6, 7],
          [1, 2, 3, 5, 6, 7, 8],
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
        ],
        values: [5, 5, 5, 5, 5],
        binarySearch: [0, 1, 2, 3, 4],
        binarySearchLower: [0, 1, 2, 3, 4],
        binarySearchUpper: [1, 2, 3, 4, 5],
      );
      binarySearchTests(
        'simple absent',
        examples: [
          [1, 6],
          [1, 2, 6, 7],
          [1, 2, 3, 6, 7, 8],
          [1, 2, 3, 4, 6, 7, 8, 9],
        ],
        values: [5, 5, 5, 5],
        binarySearch: [-1, -1, -1, -1],
        binarySearchLower: [1, 2, 3, 4],
        binarySearchUpper: [1, 2, 3, 4],
      );
      binarySearchTests(
        'right most present',
        examples: [
          [5],
          [1, 5],
          [1, 2, 5],
          [1, 2, 3, 5],
          [1, 2, 3, 4, 5],
        ],
        values: [5, 5, 5, 5, 5],
        binarySearch: [0, 1, 2, 3, 4],
        binarySearchLower: [0, 1, 2, 3, 4],
        binarySearchUpper: [1, 2, 3, 4, 5],
      );
      binarySearchTests(
        'right most absent',
        examples: [
          [1],
          [1, 2],
          [1, 2, 3],
          [1, 2, 3, 4],
        ],
        values: [5, 5, 5, 5],
        binarySearch: [-1, -1, -1, -1],
        binarySearchLower: [1, 2, 3, 4],
        binarySearchUpper: [1, 2, 3, 4],
      );
      binarySearchTests(
        'left most present',
        examples: [
          [5],
          [5, 6],
          [5, 6, 7],
          [5, 6, 7, 8],
          [5, 6, 7, 8, 9],
        ],
        values: [5, 5, 5, 5, 5],
        binarySearch: [0, 0, 0, 0, 0],
        binarySearchLower: [0, 0, 0, 0, 0],
        binarySearchUpper: [1, 1, 1, 1, 1],
      );
      binarySearchTests(
        'left most absent',
        examples: [
          [6],
          [6, 7],
          [6, 7, 8],
          [6, 7, 8, 9],
        ],
        values: [5, 5, 5, 5],
        binarySearch: [-1, -1, -1, -1],
        binarySearchLower: [0, 0, 0, 0],
        binarySearchUpper: [0, 0, 0, 0],
      );
      binarySearchTests(
        'binarySearch repeated',
        examples: [
          [1, 5, 9],
          [1, 5, 5, 9],
          [1, 5, 5, 5, 9],
          [1, 5, 5, 5, 5, 9],
          [1, 5, 5, 5, 5, 5, 9],
        ],
        values: [5, 5, 5, 5, 5],
        binarySearch: [1, 2, 2, 3, 3],
        binarySearchLower: [1, 1, 1, 1, 1],
        binarySearchUpper: [2, 3, 4, 5, 6],
      );
    });
    test('largest', () {
      expect(naturalInt.largest([], 0), []);
      expect(naturalInt.largest([2, 3, 1], 0), []);
      expect(naturalInt.largest([], 3), []);
      expect(naturalInt.largest([2, 3, 1], 3), [3, 2, 1]);
      expect(naturalInt.largest([2, 3, 1, 5, 4], 3), [5, 4, 3]);
      expect(naturalInt.largest([], 5), []);
      expect(naturalInt.largest([2, 3, 1], 5), [3, 2, 1]);
      expect(naturalInt.largest([2, 3, 1, 5, 4], 5), [5, 4, 3, 2, 1]);
    });
    group('max', () {
      test('max', () {
        expect(naturalInt.max(1, 1), 1);
        expect(naturalInt.max(1, 2), 2);
        expect(naturalInt.max(2, 1), 2);
        expect(naturalInt.max(2, 2), 2);
      });
      test('maxOf', () {
        expect(() => naturalInt.maxOf([]), throwsStateError);
        expect(naturalInt.maxOf([1]), 1);
        expect(naturalInt.maxOf([1, 2]), 2);
        expect(naturalInt.maxOf([2, 1]), 2);
        expect(naturalInt.maxOf([1, 2, 3]), 3);
        expect(naturalInt.maxOf([1, 3, 2]), 3);
        expect(naturalInt.maxOf([2, 1, 3]), 3);
        expect(naturalInt.maxOf([2, 3, 1]), 3);
        expect(naturalInt.maxOf([3, 1, 2]), 3);
        expect(naturalInt.maxOf([3, 2, 1]), 3);
      });
      test('maxOf orElse', () {
        expect(naturalInt.maxOf([], orElse: () => -1), -1);
        expect(naturalInt.maxOf([1], orElse: () => -1), 1);
        expect(naturalInt.maxOf([1, 2], orElse: () => -1), 2);
        expect(naturalInt.maxOf([1, 2, 3], orElse: () => -1), 3);
      });
    });
    group('min', () {
      test('min', () {
        expect(naturalInt.min(1, 1), 1);
        expect(naturalInt.min(1, 2), 1);
        expect(naturalInt.min(2, 1), 1);
        expect(naturalInt.min(2, 2), 2);
      });
      test('minOf', () {
        expect(() => naturalInt.minOf([]), throwsStateError);
        expect(naturalInt.minOf([1]), 1);
        expect(naturalInt.minOf([1, 2]), 1);
        expect(naturalInt.minOf([2, 1]), 1);
        expect(naturalInt.minOf([1, 2, 3]), 1);
        expect(naturalInt.minOf([1, 3, 2]), 1);
        expect(naturalInt.minOf([2, 1, 3]), 1);
        expect(naturalInt.minOf([2, 3, 1]), 1);
        expect(naturalInt.minOf([3, 1, 2]), 1);
        expect(naturalInt.minOf([3, 2, 1]), 1);
      });
      test('minOf orElse', () {
        expect(naturalInt.minOf([], orElse: () => -1), -1);
        expect(naturalInt.minOf([1], orElse: () => -1), 1);
        expect(naturalInt.minOf([1, 2], orElse: () => -1), 1);
        expect(naturalInt.minOf([1, 2, 3], orElse: () => -1), 1);
      });
    });
    group('ordered', () {
      test('isOrdered', () {
        expect(naturalInt.isOrdered([]), isTrue);
        expect(naturalInt.isOrdered([1]), isTrue);
        expect(naturalInt.isOrdered([1, 2]), isTrue);
        expect(naturalInt.isOrdered([2, 1]), isFalse);
        expect(naturalInt.isOrdered([1, 1]), isTrue);
        expect(naturalInt.isOrdered([1, 2, 3]), isTrue);
        expect(naturalInt.isOrdered([1, 2, 2]), isTrue);
        expect(naturalInt.isOrdered([2, 2, 3]), isTrue);
        expect(naturalInt.isOrdered([1, 3, 2]), isFalse);
        expect(naturalInt.isOrdered([2, 1, 3]), isFalse);
      });
      test('isOrdered', () {
        expect(naturalInt.isStrictlyOrdered([]), isTrue);
        expect(naturalInt.isStrictlyOrdered([1]), isTrue);
        expect(naturalInt.isStrictlyOrdered([1, 2]), isTrue);
        expect(naturalInt.isStrictlyOrdered([2, 1]), isFalse);
        expect(naturalInt.isStrictlyOrdered([1, 1]), isFalse);
        expect(naturalInt.isStrictlyOrdered([1, 2, 3]), isTrue);
        expect(naturalInt.isStrictlyOrdered([1, 2, 2]), isFalse);
        expect(naturalInt.isStrictlyOrdered([2, 2, 3]), isFalse);
        expect(naturalInt.isStrictlyOrdered([1, 3, 2]), isFalse);
        expect(naturalInt.isStrictlyOrdered([2, 1, 3]), isFalse);
      });
    });
    test('smallest', () {
      expect(naturalInt.smallest([], 0), []);
      expect(naturalInt.smallest([2, 3, 1], 0), []);
      expect(naturalInt.smallest([], 3), []);
      expect(naturalInt.smallest([2, 3, 1], 3), [1, 2, 3]);
      expect(naturalInt.smallest([2, 3, 1, 5, 4], 3), [1, 2, 3]);
      expect(naturalInt.smallest([], 5), []);
      expect(naturalInt.smallest([2, 3, 1], 5), [1, 2, 3]);
      expect(naturalInt.smallest([2, 3, 1, 5, 4], 5), [1, 2, 3, 4, 5]);
    });
    group('sort', () {
      test('default', () {
        expect(naturalInt.sorted([]), []);
        expect(naturalInt.sorted([1]), [1]);
        expect(naturalInt.sorted([1, 2]), [1, 2]);
        expect(naturalInt.sorted([2, 1]), [1, 2]);
        expect(naturalInt.sorted([1, 2, 3]), [1, 2, 3]);
        expect(naturalInt.sorted([1, 3, 2]), [1, 2, 3]);
        expect(naturalInt.sorted([2, 1, 3]), [1, 2, 3]);
        expect(naturalInt.sorted([2, 3, 1]), [1, 2, 3]);
        expect(naturalInt.sorted([3, 1, 2]), [1, 2, 3]);
        expect(naturalInt.sorted([3, 2, 1]), [1, 2, 3]);
      });
      test('stable', () {
        final input = IntegerRange(10)
            .reversed
            .expand((x) => IntegerRange(10).map((y) => Tuple2(x, y)));
        final actual = naturalInt
            .onResultOf<Tuple2<int, int>>((tuple) => tuple.first)
            .sorted(input, stable: true);
        final expected = IntegerRange(10)
            .expand((x) => IntegerRange(10).map((y) => Tuple2(x, y)));
        expect(actual, expected);
      });
      test('copy', () {
        final input = [5, 4, 3, 2, 1];
        final output = naturalInt.sorted(input);
        expect(input, isNot(same(output)));
        expect(input, [5, 4, 3, 2, 1]);
        expect(output, [1, 2, 3, 4, 5]);
      });
      test('copy range', () {
        final input = [5, 4, 3, 2, 1];
        final output = naturalInt.sorted(input, start: 1, end: 4);
        expect(input, isNot(same(output)));
        expect(input, [5, 4, 3, 2, 1]);
        expect(output, [5, 2, 3, 4, 1]);
      });
      test('in-place', () {
        final input = [5, 4, 3, 2, 1];
        naturalInt.sort(input);
        expect(input, [1, 2, 3, 4, 5]);
      });
      test('in-place range', () {
        final input = [5, 4, 3, 2, 1];
        naturalInt.sort(input, start: 1, end: 4);
        expect(input, [5, 2, 3, 4, 1]);
      });
    });
  });
  group('regressions', () {
    test('#4', () {
      final input = <String?>['dog', 'ape', null, 'cat'];
      final comparatorAsc = naturalString.nullsLast;
      expect(comparatorAsc.sorted(input), ['ape', 'cat', 'dog', null]);
      final comparatorDesc = naturalString.reversed.nullsLast;
      expect(comparatorDesc.sorted(input), ['dog', 'cat', 'ape', null]);
    });
  });
}
