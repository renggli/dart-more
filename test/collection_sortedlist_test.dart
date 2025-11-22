// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:test/test.dart';

void allSortedListTests(
  SortedList<E> Function<E>(
    Iterable<E> list, {
    Comparator<E>? comparator,
    bool growable,
  })
  createSortedList,
) {
  test('default ordering', () {
    final list = createSortedList<int>([5, 1, 2, 4, 3]);
    expect(list, [1, 2, 3, 4, 5]);
  });
  test('custom ordering', () {
    final list = createSortedList<num>([
      5,
      1,
      2,
      4,
      3,
    ], comparator: reverseComparable<num>);
    expect(list, [5, 4, 3, 2, 1]);
  });
  test('custom comparator', () {
    final list = createSortedList<int>([
      5,
      1,
      2,
      4,
      3,
    ], comparator: (a, b) => b - a);
    expect(list, [5, 4, 3, 2, 1]);
  });
  test('empty list', () {
    final list = createSortedList<int>([]);
    expect(list, isEmpty);
  });
  test('accessors', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.length, 3);
    expect(list.first, 1);
    expect(list.last, 5);
    expect(list[0], 1);
    expect(list[2], 5);
  });
  test('contains', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.contains(0), isFalse);
    expect(list.contains(1), isTrue);
    expect(list.contains(2), isFalse);
    expect(list.contains(3), isTrue);
    expect(list.contains(4), isFalse);
    expect(list.contains(5), isTrue);
    expect(list.contains(6), isFalse);
    expect(list.contains(null), isFalse);
  });
  test('occurrences', () {
    final list = createSortedList<int>([1, 2, 2, 3, 3, 3, 4, 4, 4, 4]);
    expect(list.occurrences(0), 0);
    expect(list.occurrences(1), 1);
    expect(list.occurrences(2), 2);
    expect(list.occurrences(3), 3);
    expect(list.occurrences(4), 4);
    expect(list.occurrences(5), 0);
  });
  test('add', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    list.add(4);
    expect(list, [1, 3, 4, 5]);
  });
  test('add (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    expect(() => list.add(4), throwsUnsupportedError);
  });
  test('addAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    list.addAll([2, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });
  test('addAll (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    expect(() => list.addAll([2, 4]), throwsUnsupportedError);
  });
  test('clear', () {
    final list = createSortedList<int>([5, 1, 3]);
    list.clear();
    expect(list, isEmpty);
  });
  test('remove', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    expect(list.remove(3), isTrue);
    expect(list, [1, 5]);
    expect(list.remove(3), isFalse);
    expect(list.remove(null), isFalse);
  });
  test('remove (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    expect(() => list.remove(3), throwsUnsupportedError);
  });
  test('removeAt', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeAt(1), 3);
    expect(list, [1, 5]);
  });
  test('removeFirst', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeFirst(), 1);
    expect(list, [3, 5]);
  });
  test('removeLast', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeLast(), 5);
    expect(list, [1, 3]);
  });
  test('removeAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeAll(), [1, 3, 5]);
    expect(list, isEmpty);
  });
  test('toUnorderedList', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.toUnorderedList(), [1, 3, 5]);
  });
  test('unorderedElements', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.unorderedElements, [1, 3, 5]);
  });
  test('stress', () {
    final random = Random(6412);
    final numbers = <int>{};
    // Create 1000 unique numbers.
    while (numbers.length < 1000) {
      numbers.add(random.nextInt(0xffffff));
    }
    final values = List.of(numbers);
    // Create a list from digit of the values.
    final list = createSortedList<int>(values);
    // Verify all values are present.
    expect(list, hasLength(values.length));
    for (final value in values) {
      expect(list.contains(value), isTrue);
    }
    // Remove values in different order.
    values.shuffle(random);
    for (final value in values) {
      expect(list.remove(value), isTrue);
    }
    // Verify all values are gone.
    expect(list, isEmpty);
  });
  test('errors', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(() => list[0] = 2, throwsUnsupportedError);
    expect(() => list.length = 2, throwsUnsupportedError);
    expect(() => list.insert(1, 4), throwsUnsupportedError);
    expect(() => list.insertAll(1, [2, 4]), throwsUnsupportedError);
    expect(() => list.sort(), throwsUnsupportedError);
    expect(() => list.shuffle(), throwsUnsupportedError);
  });
}

void main() {
  group('default constructor', () {
    allSortedListTests(<E>(
      Iterable<E> elements, {
      Comparator<E>? comparator,
      bool growable = true,
    }) {
      final list = SortedList<E>(comparator: comparator)..addAll(elements);
      return growable == false
          ? list.toSortedList(comparator: comparator, growable: growable)
          : list;
    });
  });
  group('iterable constructor', () {
    allSortedListTests(
      <E>(
        Iterable<E> elements, {
        Comparator<E>? comparator,
        bool growable = true,
      }) => SortedList<E>.of(
        elements,
        comparator: comparator,
        growable: growable,
      ),
    );
  });
  group('converting constructor', () {
    allSortedListTests(
      <E>(
        Iterable<E> elements, {
        Comparator<E>? comparator,
        bool growable = true,
      }) => elements.toSortedList(comparator: comparator, growable: growable),
    );
  });
}
