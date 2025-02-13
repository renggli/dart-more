import 'dart:collection' show ListBase;
import 'dart:math';

import 'package:collection/collection.dart' show PriorityQueue;

import '../../comparator.dart';

/// A sorted-list that remains sorted by a [Comparator] as elements get added.
class SortedList<E> extends ListBase<E> implements PriorityQueue<E> {
  /// Constructs an empty sorted-list with an optional [comparator].
  SortedList({Comparator<E>? comparator, bool growable = true})
    : _values = List.empty(growable: growable),
      _comparator = comparator ?? naturalCompare;

  /// Constructs a sorted-list from an iterable with an optional [comparator].
  SortedList.of(
    Iterable<E> iterable, {
    Comparator<E>? comparator,
    bool growable = true,
  }) : _values = List<E>.of(iterable, growable: growable),
       _comparator = comparator ?? naturalCompare {
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

  /// Returns the number of times [element] appears in the list.
  int occurrences(E element) {
    final lower = _comparator.binarySearchLower(_values, element);
    final upper = _comparator.binarySearchUpper(_values, element);
    return upper - lower;
  }

  @override
  void add(E element) {
    final index = _comparator.binarySearchLower(_values, element).abs();
    _values.insert(index, element);
  }

  @override
  void addAll(Iterable<E> iterable) => iterable.forEach(add);

  @override
  void insert(int index, E element) => _throw();

  @override
  void insertAll(int index, Iterable<E> iterable) => _throw();

  @override
  bool remove(Object? element) {
    if (element is! E) return false;
    final index = _comparator.binarySearch(_values, element);
    if (index < 0) return false;
    _values.removeAt(index);
    return true;
  }

  @override
  Iterable<E> removeAll() {
    final result = _values.toList();
    _values.clear();
    return result;
  }

  @override
  E removeAt(int index) => _values.removeAt(index);

  @override
  E removeFirst() => _values.removeAt(0);

  @override
  E removeLast() => _values.removeLast();

  @override
  void clear() => _values.clear();

  @override
  void sort([int Function(E a, E b)? compare]) => _throw();

  @override
  void shuffle([Random? random]) => _throw();

  @override
  Iterable<E> get unorderedElements => _values;

  @override
  List<E> toUnorderedList() => _values.toList();

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
