import 'package:collection/collection.dart' show PriorityQueue;

/// A priority queue implemented using a binary min-heap.
///
/// Contrary to the [PriorityQueue] in the Dart standard library, this
/// implementation requires elements to be subclasses of [HeapEntry]. For
/// convenience two standard implementation as provided: [ValueHeapEntry] and
/// [KeyValueHeapEntry].
///
/// This implementation does not only provide amortized logarithmic time for
/// [add] and [removeFirst], but also for [remove]. Furthermore it can not only
/// answer [first], but also [contains] in constant time. It does this by
/// keeping track of the index in the internal element list of all entries.
class Heap<E extends HeapEntry<E>> implements PriorityQueue<E> {
  /// Constructs an empty binary min-heap.
  Heap() : _elements = <E>[];

  /// Constructs a binary min-heap from an [iterable] of elements.
  Heap.of(Iterable<E> iterable) : _elements = List<E>.of(iterable) {
    for (var i = 0; i < _elements.length; i++) {
      final element = _elements[i];
      _checkNoIndex(element);
      element._index = i;
    }
    if (_elements.length > 1) {
      for (var i = _elements.length ~/ 2; i >= 0; i--) {
        _siftUp(i);
      }
    }
  }

  final List<E> _elements;

  @override
  int get length => _elements.length;

  @override
  bool get isEmpty => _elements.isEmpty;

  @override
  bool get isNotEmpty => _elements.isNotEmpty;

  @override
  bool contains(E element) =>
      element._index != HeapEntry._invalidIndex &&
      _elements[element._index] == element;

  @override
  Iterable<E> get unorderedElements => _elements;

  @override
  void add(E element) {
    _checkNoIndex(element);
    element._index = _elements.length;
    _elements.add(element);
    _siftDown(0, _elements.length - 1);
  }

  @override
  void addAll(Iterable<E> elements) => elements.forEach(add);

  @override
  E get first {
    _checkNotEmpty();
    return _elements[0];
  }

  @override
  E removeFirst() {
    _checkNotEmpty();
    final element = _elements.removeLast();
    if (_elements.isNotEmpty) {
      final result = _elements[0];
      _elements[0] = element;
      element._index = 0;
      _siftUp(0);
      result._index = HeapEntry._invalidIndex;
      return result;
    }
    element._index = HeapEntry._invalidIndex;
    return element;
  }

  @override
  bool remove(E element) {
    if (element._index != HeapEntry._invalidIndex &&
        _elements[element._index] == element) {
      _elements.removeAt(element._index);
      for (var i = element._index; i < _elements.length; i++) {
        _elements[i]._index = i;
      }
      element._index = HeapEntry._invalidIndex;
      return true;
    }
    return false;
  }

  @override
  Iterable<E> removeAll() {
    final result = _elements.toList();
    clear();
    return result;
  }

  @override
  void clear() {
    for (final element in _elements) {
      element._index = HeapEntry._invalidIndex;
    }
    _elements.clear();
  }

  @override
  List<E> toList() => _elements.toList()..sort();

  @override
  List<E> toUnorderedList() => _elements.toList();

  @override
  Set<E> toSet() => _elements.toSet();

  void _checkNotEmpty() {
    if (_elements.isEmpty) {
      throw StateError('No element');
    }
  }

  void _checkNoIndex(E element) {
    if (element._index != HeapEntry._invalidIndex) {
      throw StateError('$element is already part of a heap');
    }
  }

  void _siftDown(int start, int stop) {
    final element = _elements[stop];
    while (start < stop) {
      final parentIndex = (stop - 1) >> 1;
      final parent = _elements[parentIndex];
      if (0 < element.compareTo(parent)) {
        break;
      }
      _elements[stop] = parent;
      parent._index = stop;
      stop = parentIndex;
    }
    _elements[stop] = element;
    element._index = stop;
  }

  void _siftUp(int pos) {
    final end = _elements.length;
    final start = pos;
    final element = _elements[pos];
    var childLeft = 2 * pos + 1;
    while (childLeft < end) {
      final childRight = childLeft + 1;
      if (childRight < end &&
          0 < _elements[childLeft].compareTo(_elements[childRight])) {
        childLeft = childRight;
      }
      _elements[pos] = _elements[childLeft];
      _elements[childLeft]._index = pos;
      pos = childLeft;
      childLeft = 2 * pos + 1;
    }
    _elements[pos] = element;
    element._index = pos;
    _siftDown(start, pos);
  }
}

/// The abstract superclass of all elements in a [Heap].
abstract mixin class HeapEntry<T> implements Comparable<T> {
  /// Index marker of an entry that is not currently in a heap.
  static const _invalidIndex = -1;

  /// Internal index of the entry in the heap.
  int _index = _invalidIndex;
}

/// Convenience class providing a [Heap] entry with a single comparable value.
class ValueHeapEntry<V extends Comparable<V>>
    extends HeapEntry<ValueHeapEntry<V>> {
  ValueHeapEntry(this.value);

  final V value;

  @override
  int compareTo(ValueHeapEntry<V> other) => value.compareTo(other.value);

  @override
  String toString() => '$value';
}

/// Convenience class providing a [Heap] entry with a key as its priority and
/// an associated value.
class KeyValueHeapEntry<K extends Comparable<K>, V>
    extends HeapEntry<KeyValueHeapEntry<K, V>> {
  KeyValueHeapEntry(this.key, this.value);

  final K key;
  final V value;

  @override
  int compareTo(KeyValueHeapEntry<K, V> other) => key.compareTo(other.key);

  @override
  String toString() => '$key: $value';
}
