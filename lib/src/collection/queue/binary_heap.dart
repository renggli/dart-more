import 'package:collection/collection.dart' show PriorityQueue;

import '../../../comparator.dart';

/// A priority queue implemented using a binary heap.
///
/// This implementation is very similar to the one included with the standard
/// library but for some relevant benchmarks around 25% faster.
class BinaryHeapPriorityQueue<E> implements PriorityQueue<E> {
  /// Constructs an empty min-heap with an optional [comparator]. To create a
  /// max-heap invert the comparator.
  BinaryHeapPriorityQueue([Comparator<E>? comparator])
      : _values = <E>[],
        _comparator = comparator ?? naturalCompare;

  /// Constructs a min-heap with an iterable of elements and an optional
  /// [comparator]. To create a min-heap invert the comparator.
  BinaryHeapPriorityQueue.of(Iterable<E> iterable, [Comparator<E>? comparator])
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

  @override
  int get length => _values.length;

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  bool contains(E object) => _values.contains(object);

  @override
  Iterable<E> get unorderedElements => _values;

  @override
  void add(E value) {
    _values.add(value);
    _siftDown(0, _values.length - 1);
  }

  @override
  void addAll(Iterable<E> values) => values.forEach(add);

  @override
  E get first {
    _checkNotEmpty();
    return _values[0];
  }

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

  @override
  bool remove(E value) => _values.remove(value);

  @override
  Iterable<E> removeAll() {
    final result = _values.toList();
    _values.clear();
    return result;
  }

  @override
  void clear() => _values.clear();

  @override
  List<E> toList() => _values.toList()..sort(_comparator);

  @override
  List<E> toUnorderedList() => _values.toList();

  @override
  Set<E> toSet() => _values.toSet();

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
