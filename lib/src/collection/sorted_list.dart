import 'dart:math';

import '../../comparator.dart';
import 'ordered_list.dart';

/// A sorted list that remains sorted by a [Comparator] as elements get added.
class SortedList<E> extends OrderedList<E> {
  /// Constructs an empty sorted list with an optional [comparator].
  new({Comparator<E>? comparator, super.growable})
    : _comparator = comparator ?? naturalCompare;

  /// Constructs a sorted list from an iterable with an optional [comparator].
  new of(Iterable<E> iterable, {Comparator<E>? comparator, super.growable})
    : _comparator = comparator ?? naturalCompare,
      super.of(_sort(iterable, comparator ?? naturalCompare));

  static List<E> _sort<E>(Iterable<E> iterable, Comparator<E> comparator) {
    final list = List<E>.of(iterable);
    comparator.sort(list);
    return list;
  }

  // Underlying comparator.
  final Comparator<E> _comparator;

  /// Returns the comparator of this list.
  Comparator<E> get comparator => _comparator;

  @override
  set length(int length) => _throw();

  @override
  void operator []=(int index, E value) => _throw();

  @override
  bool contains(Object? element) =>
      element is E && _comparator.binarySearch(this, element) >= 0;

  /// Returns the number of times [element] appears in the list.
  int occurrences(E element) {
    final lower = _comparator.binarySearchLower(this, element);
    final upper = _comparator.binarySearchUpper(this, element);
    return upper - lower;
  }

  @override
  void add(E element) {
    if (!isGrowable) throwNotGrowable();
    final index = _comparator.binarySearchLower(this, element).abs();
    super.insert(index, element);
  }

  @override
  void addFirst(E element) => _throw();

  @override
  void addLast(E element) => _throw();

  @override
  void addAll(Iterable<E> iterable) => iterable.forEach(add);

  @override
  void insert(int index, E element) => _throw();

  @override
  void insertAll(int index, Iterable<E> iterable) => _throw();

  @override
  bool remove(Object? element) {
    if (!isGrowable) throwNotGrowable();
    if (element is! E) return false;
    final index = _comparator.binarySearch(this, element);
    if (index < 0) return false;
    super.removeAt(index);
    return true;
  }

  @override
  void sort([int Function(E a, E b)? compare]) => _throw();

  @override
  void shuffle([Random? random]) => _throw();

  static void _throw() =>
      throw UnsupportedError('Cannot modify the order of a sorted list');
}

extension SortedListIterableExtension<E> on Iterable<E> {
  /// Converts this [Iterable] to a [SortedList].
  SortedList<E> toSortedList({
    Comparator<E>? comparator,
    bool growable = true,
  }) => SortedList.of(this, comparator: comparator, growable: growable);
}
