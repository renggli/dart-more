// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:test/test.dart' show group, test;

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
    check(list).deepEquals([1, 2, 3, 4, 5]);
  });
  test('custom ordering', () {
    final list = createSortedList<num>([
      5,
      1,
      2,
      4,
      3,
    ], comparator: reverseComparable<num>);
    check(list).deepEquals([5, 4, 3, 2, 1]);
  });
  test('custom comparator', () {
    final list = createSortedList<int>([
      5,
      1,
      2,
      4,
      3,
    ], comparator: (a, b) => b - a);
    check(list).deepEquals([5, 4, 3, 2, 1]);
  });
  test('empty list', () {
    final list = createSortedList<int>([]);
    check(list).isEmpty();
  });
  test('accessors', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.length).equals(3);
    check(list.first).equals(1);
    check(list.last).equals(5);
    check(list[0]).equals(1);
    check(list[2]).equals(5);
  });
  test('contains', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.contains(0)).isFalse();
    check(list.contains(1)).isTrue();
    check(list.contains(2)).isFalse();
    check(list.contains(3)).isTrue();
    check(list.contains(4)).isFalse();
    check(list.contains(5)).isTrue();
    check(list.contains(6)).isFalse();
    check(list.contains(null)).isFalse();
  });
  test('occurrences', () {
    final list = createSortedList<int>([1, 2, 2, 3, 3, 3, 4, 4, 4, 4]);
    check(list.occurrences(0)).equals(0);
    check(list.occurrences(1)).equals(1);
    check(list.occurrences(2)).equals(2);
    check(list.occurrences(3)).equals(3);
    check(list.occurrences(4)).equals(4);
    check(list.occurrences(5)).equals(0);
  });
  test('add', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list).deepEquals([1, 3, 5]);
    list.add(4);
    check(list).deepEquals([1, 3, 4, 5]);
  });
  test('add (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    check(() => list.add(4)).throws<UnsupportedError>();
  });
  test('addAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list).deepEquals([1, 3, 5]);
    list.addAll([2, 4]);
    check(list).deepEquals([1, 2, 3, 4, 5]);
  });
  test('addAll (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    check(() => list.addAll([2, 4])).throws<UnsupportedError>();
  });
  test('clear', () {
    final list = createSortedList<int>([5, 1, 3]);
    list.clear();
    check(list).isEmpty();
  });
  test('remove', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list).deepEquals([1, 3, 5]);
    check(list.remove(3)).isTrue();
    check(list).deepEquals([1, 5]);
    check(list.remove(3)).isFalse();
    check(list.remove(null)).isFalse();
  });
  test('remove (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    check(() => list.remove(3)).throws<UnsupportedError>();
  });
  test('removeAt', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.removeAt(1)).equals(3);
    check(list).deepEquals([1, 5]);
  });
  test('removeFirst', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.removeFirst()).equals(1);
    check(list).deepEquals([3, 5]);
  });
  test('removeLast', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.removeLast()).equals(5);
    check(list).deepEquals([1, 3]);
  });
  test('removeAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.removeAll()).deepEquals([1, 3, 5]);
    check(list).isEmpty();
  });
  test('toUnorderedList', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.toUnorderedList()).deepEquals([1, 3, 5]);
  });
  test('unorderedElements', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(list.unorderedElements).deepEquals([1, 3, 5]);
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
    check(list).length.equals(values.length);
    for (final value in values) {
      check(list.contains(value)).isTrue();
    }
    // Remove values in different order.
    values.shuffle(random);
    for (final value in values) {
      check(list.remove(value)).isTrue();
    }
    // Verify all values are gone.
    check(list).isEmpty();
  });
  test('errors', () {
    final list = createSortedList<int>([5, 1, 3]);
    check(() => list[0] = 2).throws<UnsupportedError>();
    check(() => list.length = 2).throws<UnsupportedError>();
    check(() => list.insert(1, 4)).throws<UnsupportedError>();
    check(() => list.insertAll(1, [2, 4])).throws<UnsupportedError>();
    check(() => list.addFirst(0)).throws<UnsupportedError>();
    check(() => list.addLast(10)).throws<UnsupportedError>();
    check(() => list.sort()).throws<UnsupportedError>();
    check(() => list.shuffle()).throws<UnsupportedError>();
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
