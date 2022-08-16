import 'dart:collection' show ListBase;
import 'dart:math';

import '../../ordering.dart';
import 'comparator.dart';

/// A sorted-list that remains sorted using an [Ordering] or [Comparator] as
/// elements get added.
class SortedList<E> extends ListBase<E> {
  /// Constructs an empty sorted-list with an optional `ordering`.
  SortedList({Ordering<E>? ordering, Comparator<E>? comparator})
      : _values = <E>[],
        _ordering =
            getDefaultOrdering(ordering: ordering, comparator: comparator);

  /// Constructs a sorted-list from an iterable with an optional `ordering`.
  SortedList.of(Iterable<E> iterable,
      {Ordering<E>? ordering, Comparator<E>? comparator})
      : _values = List<E>.of(iterable),
        _ordering =
            getDefaultOrdering(ordering: ordering, comparator: comparator) {
    _ordering.sort(_values);
  }

  // Underlying list of values.
  final List<E> _values;

  // Underlying ordering/comparator.
  final Ordering<E> _ordering;

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
      element is E && _ordering.binarySearch(_values, element) >= 0;

  @override
  void add(E element) {
    final index = _ordering.binarySearchLower(_values, element).abs();
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
    final index = _ordering.binarySearch(_values, element);
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
  SortedList<E> toSortedList(
          {Ordering<E>? ordering, Comparator<E>? comparator}) =>
      SortedList.of(this, ordering: ordering, comparator: comparator);
}
