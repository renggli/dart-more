// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library ordering_test;

import 'package:unittest/unittest.dart';
import 'package:more/ordering.dart';

void verify(Ordering ordering, Iterable unsorted, Iterable expected) {
  var sorted = ordering.sorted(unsorted);
  expect(sorted, expected);
  expect(ordering.isOrdered(sorted), isTrue);
  for (var element in unsorted) {
    expect(ordering.binarySearch(sorted, element), (index) => (index) >= 0);
  }
  if (!sorted.isEmpty) {
    expect(ordering.minOf(unsorted), expected.first);
    expect(ordering.maxOf(unsorted), expected.last);
  }
  expect(!ordering.toString().isEmpty, isTrue);
}

final natural = new Ordering.natural();

void main() {
  group('ordering', () {
    group('orders', () {
      test('natural', () {
        var ordering = natural;
        verify(ordering, [1, 2, 3], [1, 2, 3]);
        verify(ordering, [2, 3, 1], [1, 2, 3]);
        verify(ordering, [3, 1, 2], [1, 2, 3]);
        verify(ordering, [3, 2, 1], [1, 2, 3]);
      });
      test('comparator', () {
        var ordering = new Ordering.from((a, b) => a.length - b.length);
        verify(ordering, ['*', '**', '***'], ['*', '**', '***']);
        verify(ordering, ['**', '***', '*'], ['*', '**', '***']);
        verify(ordering, ['***', '*', '**'], ['*', '**', '***']);
        verify(ordering, ['***', '**', '*'], ['*', '**', '***']);
      });
      test('explicit', () {
        var ordering = new Ordering.explicit([2, 3, 1]);
        verify(ordering, [3, 2], [2, 3]);
        verify(ordering, [1, 2], [2, 1]);
        verify(ordering, [1, 2, 3], [2, 3, 1]);
        verify(ordering, [2, 3, 1], [2, 3, 1]);
        expect(() => ordering.binarySearch([2, 3, 1], 4), throws);
        expect(() => ordering.binarySearch([2, 4, 1], 3), throws);
      });
    });
    group('operators', () {
      test('reverse', () {
        var ordering = natural.reverse();
        verify(ordering, [1, 2, 3], [3, 2, 1]);
        verify(ordering, [2, 3, 1], [3, 2, 1]);
        verify(ordering, [3, 1, 2], [3, 2, 1]);
        verify(ordering, [3, 2, 1], [3, 2, 1]);
      });
      test('lexicographical', () {
        var ordering = natural.lexicographical();
        verify(ordering, [[], [1], [1, 1], [1, 2], [2]],
            [[], [1], [1, 1], [1, 2], [2]]);
        verify(ordering, [[2], [1, 2], [1, 1], [1], []],
            [[], [1], [1, 1], [1, 2], [2]]);
      });
      test('nullsFirst', () {
        var ordering = natural.nullsFirst();
        verify(ordering, [null, 1, 2, 3], [null, 1, 2, 3]);
        verify(ordering, [2, null, 3, 1], [null, 1, 2, 3]);
        verify(ordering, [3, 1, null, 2], [null, 1, 2, 3]);
        verify(ordering, [3, 2, 1, null], [null, 1, 2, 3]);
      });
      test('nullsLast', () {
        var ordering = natural.nullsLast();
        verify(ordering, [null, 1, 2, 3], [1, 2, 3, null]);
        verify(ordering, [2, null, 3, 1], [1, 2, 3, null]);
        verify(ordering, [3, 1, null, 2], [1, 2, 3, null]);
        verify(ordering, [3, 2, 1, null], [1, 2, 3, null]);
      });
      test('compound', () {
        var ordering = natural.onResultOf((str) => str.length).compound(natural);
        verify(ordering, ['333', '1', '4444', '22'],
            ['1', '22', '333', '4444']);
        verify(ordering, ['2', '333', '4444', '1', '22'],
            ['1', '2', '22', '333', '4444']);
        verify(ordering, ['33', '333', '2', '22', '1', '4444'],
            ['1', '2', '22', '33', '333', '4444']);
        verify(ordering, ['4444', '44', '2', '1', '333', '22', '33'],
            ['1', '2', '22', '33', '44', '333', '4444']);
      });
      test('onResultOf', () {
        var ordering = natural.onResultOf((str) => str.length);
        verify(ordering, ['*', '**', '***'], ['*', '**', '***']);
        verify(ordering, ['**', '***', '*'], ['*', '**', '***']);
        verify(ordering, ['***', '*', '**'], ['*', '**', '***']);
        verify(ordering, ['***', '**', '*'], ['*', '**', '***']);
      });
    });
    group('actions', () {
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
        expect(() => natural.maxOf([]), throws);
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
        expect(() => natural.minOf([]), throws);
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
  });
}