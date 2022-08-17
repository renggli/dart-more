import 'dart:collection' show ListBase;
import 'dart:math';

import '../../comparator.dart';

/// A sorted-list that remains sorted by a [Comparator] as elements get added.
class SortedList<E> extends ListBase<E> {
  /// Constructs an empty sorted-list with an optional `ordering`.
  SortedList({Comparator<E>? comparator})
      : _values = <E>[],
        _comparator = comparator ?? naturalComparator<E>();

  /// Constructs a sorted-list from an iterable with an optional `ordering`.
  SortedList.of(Iterable<E> iterable, {Comparator<E>? comparator})
      : _values = List<E>.of(iterable),
        _comparator = comparator ?? naturalComparator<E>() {
    _comparator.sort(_values);
  }

  // Underlying list of values.
  final List<E> _values;

  // Underlying comparator.
  final Comparator<E> _comparator;

  @override
  int get length => _values.length;

  @override
  set length(int length) => _throw();

  @override
  E operator [](int index) => _values[index];

  @override
  void operator []=(int index, E value) => _throw();

  @override
  bool contains(Object? element) =>
      element is E && _comparator.binarySearch(_values, element) >= 0;

  @override
  void add(E element) {
    final index = _comparator.binarySearchLower(_values, element).abs();
    _values.insert(index, element);
  }

  @override
  void addAll(Iterable<E> iterable) {
    for (final element in iterable) {
      add(element);
    }
  }

  @override
  bool remove(Object? element) {
    if (element is! E) return false;
    final index = _comparator.binarySearch(_values, element);
    if (index < 0) return false;
    _values.removeAt(index);
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
  SortedList<E> toSortedList({Comparator<E>? comparator}) =>
      SortedList.of(this, comparator: comparator);
}
