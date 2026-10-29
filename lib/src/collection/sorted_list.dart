import 'dart:collection' show ListBase;
import 'dart:math';

import 'package:collection/collection.dart' show PriorityQueue;

import '../comparator/constructors/natural.dart';
import '../comparator/operations/binary_search.dart';
import '../comparator/operations/sort.dart';
import 'ordered_list.dart';

/// A sorted list that remains sorted by a [Comparator] as elements get added.
///
/// Implements [PriorityQueue]. Exposes elements in sorted order.
class SortedList<E> extends ListBase<E> implements PriorityQueue<E> {
  /// Constructs an empty sorted list with an optional [comparator].
  new({Comparator<E>? comparator, bool growable = true})
    : _comparator = comparator ?? naturalCompare,
      _elements = OrderedList<E>(growable: growable);

  /// Constructs a sorted list from an iterable with an optional [comparator].
  new of(
    Iterable<E> iterable, {
    Comparator<E>? comparator,
    bool growable = true,
  }) : _comparator = comparator ?? naturalCompare,
       _elements = OrderedList<E>.of(
         _sort(iterable, comparator ?? naturalCompare),
         growable: growable,
       );

  static List<E> _sort<E>(Iterable<E> iterable, Comparator<E> comparator) {
    final list = List<E>.of(iterable);
    comparator.sort(list);
    return list;
  }

  // Underlying comparator and circular buffer elements.
  final Comparator<E> _comparator;
  final OrderedList<E> _elements;

  /// Returns the comparator of this list.
  Comparator<E> get comparator => _comparator;

  /// Returns `true` if this list can grow.
  bool get isGrowable => _elements.isGrowable;

  @override
  int get length => _elements.length;

  @override
  set length(int length) => _throw();

  @override
  E operator [](int index) => _elements[index];

  @override
  void operator []=(int index, E value) => _throw();

  @override
  bool contains(Object? element) => indexOf(element) >= 0;

  @override
  int indexOf(Object? element, [int start = 0]) {
    if (element is! E) return -1;
    if (start < 0) start = 0;
    if (start >= length) return -1;
    final index = _comparator.binarySearchLower(
      _elements,
      element,
      start: start,
    );
    for (
      var i = index;
      i < length && _comparator(_elements[i], element) == 0;
      i++
    ) {
      if (_elements[i] == element) return i;
    }
    return -1;
  }

  @override
  int lastIndexOf(Object? element, [int? start]) {
    if (element is! E) return -1;
    if (start != null && start < 0) return -1;
    final end = start == null ? length : min(start + 1, length);
    if (end <= 0) return -1;
    final upper = _comparator.binarySearchUpper(_elements, element, end: end);
    for (
      var i = upper - 1;
      i >= 0 && _comparator(_elements[i], element) == 0;
      i--
    ) {
      if (_elements[i] == element) return i;
    }
    return -1;
  }

  /// Returns the number of times [element] appears in the list.
  int occurrences(E element) {
    final lower = _comparator.binarySearchLower(_elements, element);
    final upper = _comparator.binarySearchUpper(_elements, element);
    return upper - lower;
  }

  @override
  void add(E element) {
    if (!isGrowable) _elements.throwNotGrowable();
    final index = _comparator.binarySearchLower(_elements, element).abs();
    _elements.insert(index, element);
  }

  /// Throws [UnsupportedError] because the order is determined by the comparator.
  void addFirst(E element) => _throw();

  /// Throws [UnsupportedError] because the order is determined by the comparator.
  void addLast(E element) => _throw();

  @override
  void addAll(Iterable<E> iterable) => iterable.forEach(add);

  @override
  void insert(int index, E element) => _throw();

  @override
  void insertAll(int index, Iterable<E> iterable) => _throw();

  @override
  bool remove(Object? element) {
    if (!isGrowable) _elements.throwNotGrowable();
    final index = indexOf(element);
    if (index < 0) return false;
    _elements.removeAt(index);
    return true;
  }

  @override
  E removeAt(int index) => _elements.removeAt(index);

  @override
  void removeRange(int start, int end) => _elements.removeRange(start, end);

  @override
  void removeWhere(bool Function(E element) test) =>
      _elements.removeWhere(test);

  @override
  void retainWhere(bool Function(E element) test) =>
      _elements.retainWhere(test);

  @override
  E removeFirst() => _elements.removeFirst();

  @override
  E removeLast() => _elements.removeLast();

  @override
  Iterable<E> removeAll() {
    final result = toList();
    clear();
    return result;
  }

  @override
  void clear() => _elements.clear();

  @override
  void sort([int Function(E a, E b)? compare]) => _throw();

  @override
  void shuffle([Random? random]) => _throw();

  @override
  Iterable<E> get unorderedElements => _elements;

  @override
  List<E> toUnorderedList() => _elements.toList();

  static void _throw() =>
      throw UnsupportedError('Cannot modify the order of a sorted list');
}

/// Extension on [Iterable] to convert to a [SortedList].
extension SortedListIterableExtension<E> on Iterable<E> {
  /// Converts this [Iterable] to a [SortedList].
  SortedList<E> toSortedList({
    Comparator<E>? comparator,
    bool growable = true,
  }) => SortedList.of(this, comparator: comparator, growable: growable);
}
