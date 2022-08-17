import '../../comparator.dart';

/// A priority queue implemented using a binary heap.
class Heap<E> extends Iterable<E> {
  /// Constructs an empty max-heap with an optional [comparator]. To create a
  /// min-heap invert the comparator.
  Heap({Comparator<E>? comparator})
      : _values = <E>[],
        _comparator = comparator ?? naturalComparator<E>();

  /// Constructs a max-heap with an iterable of elements and an optional
  /// [comparator]. To create a min-heap invert the comparator.
  Heap.of(Iterable<E> iterable, {Comparator<E>? comparator})
      : _values = List<E>.of(iterable),
        _comparator = comparator ?? naturalComparator<E>() {
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

  /// Returns an [Iterator] over the underlying values.
  @override
  Iterator<E> get iterator => _values.iterator;

  /// Returns the last/largest value from this heap.
  E get peek {
    _checkNotEmpty();
    return _values[0];
  }

  /// Adds a new value onto this heap.
  void push(E value) {
    _values.add(value);
    _siftDown(0, _values.length - 1);
  }

  /// Adds multiple new values onto this heap.
  void pushAll(Iterable<E> values) => values.forEach(push);

  /// Removes and returns the last/largest value from this heap.
  E pop() {
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

  /// A pop immediately followed by a push. Contrary to [pushAndPop] this
  /// requires a non-empty heap and never returns `value`.
  E popAndPush(E value) {
    _checkNotEmpty();
    final result = _values[0];
    _values[0] = value;
    _siftUp(0);
    return result;
  }

  /// A push immediately followed by a pop. Contrary to [popAndPush] this
  /// works on an empty heap and might directly return `value`.
  E pushAndPop(E value) {
    if (_values.isEmpty || _comparator(_values[0], value) < 0) {
      return value;
    }
    final result = _values[0];
    _values[0] = value;
    _siftUp(0);
    return result;
  }

  /// Removes all objects from this heap.
  void clear() => _values.clear();

  void _checkNotEmpty() {
    if (_values.isEmpty) {
      throw StateError('No element');
    }
  }

  void _siftDown(int start, int stop) {
    final value = _values[stop];
    while (start < stop) {
      final parentIndex = (stop - 1) >> 1;
      final parent = _values[parentIndex];
      if (_comparator(value, parent) < 0) {
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
          _comparator(_values[childLeft], _values[childRight]) < 0) {
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
