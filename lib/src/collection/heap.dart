import 'package:collection/collection.dart' show PriorityQueue;

import '../../comparator.dart';

/// A priority queue implemented using a binary heap.
class Heap<E> extends Iterable<E> implements PriorityQueue<E> {
  /// Constructs an empty min-heap with an optional [comparator]. To create a
  /// max-heap invert the comparator.
  Heap({Comparator<E>? comparator})
      : _values = <E>[],
        _comparator = comparator ?? naturalCompare;

  /// Constructs a min-heap with an iterable of elements and an optional
  /// [comparator]. To create a min-heap invert the comparator.
  Heap.of(Iterable<E> iterable, {Comparator<E>? comparator})
      : _values = List<E>.of(iterable),
        _comparator = comparator ?? naturalCompare {
    if (_values.length > 1) {
      for (var i = _values.length ~/ 2; i >= 0; i--) {
        _siftUp(i);
      }
    }
  }

  // Underlying list of values.
  final List<E> _values;

  // Underlying comparator.
  final Comparator<E> _comparator;

  /// Returns the number of elements in this heap.
  @override
  int get length => _values.length;

  /// Whether this heap has no elements.
  @override
  bool get isEmpty => _values.isEmpty;

  /// Whether this heap has at least one element.
  @override
  bool get isNotEmpty => _values.isNotEmpty;

  /// Returns the smallest value on this heap.
  @override
  E get first {
    _checkNotEmpty();
    return _values[0];
  }

  /// Adds a new value onto this heap.
  @override
  void add(E value) {
    _values.add(value);
    _siftDown(0, _values.length - 1);
  }

  /// Adds multiple new values onto this heap.
  @override
  void addAll(Iterable<E> values) => values.forEach(add);

  /// Removes all objects from this heap.
  @override
  void clear() => _values.clear();

  /// Removes and returns the smallest value from this heap.
  @override
  E removeFirst() {
    _checkNotEmpty();
    final value = _values.removeLast();
    if (_values.isNotEmpty) {
      final result = _values[0];
      _values[0] = value;
      _siftUp(0);
      return result;
    }
    return value;
  }

  /// Remove an element from the heap.
  @override
  bool remove(E value) => _values.remove(value);

  /// Removes all objects from this heap.
  @override
  Iterable<E> removeAll() {
    final result = _values.toList();
    _values.clear();
    return result;
  }

  /// A pop immediately followed by a push. Contrary to [addAndRemoveFirst] this
  /// requires a non-empty heap and never returns `value`.
  E removeFirstAndAdd(E value) {
    _checkNotEmpty();
    final result = _values[0];
    _values[0] = value;
    _siftUp(0);
    return result;
  }

  /// A push immediately followed by a pop. Contrary to [removeFirstAndAdd] this
  /// works on an empty heap and might directly return `value`.
  E addAndRemoveFirst(E value) {
    if (_values.isEmpty || 0 < _comparator(_values[0], value)) {
      return value;
    }
    final result = _values[0];
    _values[0] = value;
    _siftUp(0);
    return result;
  }

  @override
  Iterator<E> get iterator => _values.iterator;

  @override
  Iterable<E> get unorderedElements => _values;

  @override
  List<E> toUnorderedList() => _values.toList();

  void _checkNotEmpty() {
    if (_values.isEmpty) throw StateError('No element');
  }

  void _siftDown(int start, int stop) {
    final value = _values[stop];
    while (start < stop) {
      final parentIndex = (stop - 1) >> 1;
      final parent = _values[parentIndex];
      if (0 < _comparator(value, parent)) {
        break;
      }
      _values[stop] = parent;
      stop = parentIndex;
    }
    _values[stop] = value;
  }

  void _siftUp(int pos) {
    final end = _values.length;
    final start = pos;
    final value = _values[pos];
    var childLeft = 2 * pos + 1;
    while (childLeft < end) {
      final childRight = childLeft + 1;
      if (childRight < end &&
          0 < _comparator(_values[childLeft], _values[childRight])) {
        childLeft = childRight;
      }
      _values[pos] = _values[childLeft];
      pos = childLeft;
      childLeft = 2 * pos + 1;
    }
    _values[pos] = value;
    _siftDown(start, pos);
  }
}
