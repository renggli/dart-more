import 'dart:collection' show ListBase;
import 'dart:math' as math;

import 'package:collection/collection.dart' show PriorityQueue;
import 'package:meta/meta.dart' show protected;

/// A list with constant time addition and removal at both ends, backed by a
/// circular buffer.
///
/// Implements [List] and [PriorityQueue].
///
/// Example:
/// ```dart
/// final list = OrderedList<int>();
/// list.addLast(2);
/// list.addFirst(1);
/// list.addLast(3);
/// print(list); // [1, 2, 3]
/// print(list.removeFirst()); // 1
/// ```
class OrderedList<E> extends ListBase<E> implements PriorityQueue<E> {
  /// Constructs an empty ordered list.
  new({this._growable = true})
    : _buffer = List<E?>.filled(_initialCapacity, null);

  /// Constructs an ordered list from an [iterable].
  new of(Iterable<E> iterable, {this._growable = true})
    : _buffer = List<E?>.filled(
        _computeCapacity(
          iterable is List || iterable is Set
              ? iterable.length
              : _initialCapacity,
        ),
        null,
      ) {
    for (final element in iterable) {
      if (_length == _capacity) _grow();
      _buffer[(_head + _length++) & _mask] = element;
    }
  }

  /// Constructs an ordered list of the given [length] filled with [fill].
  new filled(int length, E fill, {this._growable = false})
    : _length = length,
      _buffer = List<E?>.filled(_computeCapacity(length), null) {
    RangeError.checkNotNegative(length, 'length');
    _buffer.fillRange(0, length, fill);
  }

  static const int _initialCapacity = 8;

  static int _computeCapacity(int length) {
    if (length <= _initialCapacity) return _initialCapacity;
    var v = length - 1;
    v |= v >> 1;
    v |= v >> 2;
    v |= v >> 4;
    v |= v >> 8;
    v |= v >> 16;
    v |= v >> 32;
    return v + 1;
  }

  final bool _growable;
  List<E?> _buffer;
  int _head = 0;
  int _length = 0;

  int get _capacity => _buffer.length;
  int get _mask => _capacity - 1;

  /// Returns `true` if this list can grow.
  bool get isGrowable => _growable;

  /// Returns the start index of this list in the internal buffer.
  int get startIndex => _head;

  /// Returns the end index of this list in the internal buffer.
  int get endIndex => (_head + _length) & _mask;

  @override
  int get length => _length;

  @override
  set length(int newLength) {
    if (!_growable) throwNotGrowable();
    RangeError.checkNotNegative(newLength, 'length');
    if (newLength < _length) {
      for (var i = newLength; i < _length; i++) {
        _buffer[(_head + i) & _mask] = null;
      }
      _length = newLength;
    } else if (newLength > _length) {
      if (null is! E) {
        throw UnsupportedError('Cannot enlarge a list without a fill value');
      }
      while (_capacity < newLength) {
        _grow();
      }
      _length = newLength;
    }
  }

  @override
  E operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return _buffer[(_head + index) & _mask] as E;
  }

  @override
  void operator []=(int index, E value) {
    RangeError.checkValidIndex(index, this);
    _buffer[(_head + index) & _mask] = value;
  }

  /// Adds [element] to the beginning of this list.
  void addFirst(E element) => _addFirst(element);

  /// Adds [element] to the end of this list.
  void addLast(E element) => _addLast(element);

  void _addFirst(E element) {
    if (!_growable) throwNotGrowable();
    if (_length == _capacity) _grow();
    _head = (_head - 1) & _mask;
    _buffer[_head] = element;
    _length++;
  }

  void _addLast(E element) {
    if (!_growable) throwNotGrowable();
    if (_length == _capacity) _grow();
    _buffer[(_head + _length) & _mask] = element;
    _length++;
  }

  @override
  void add(E element) => _addLast(element);

  @override
  void addAll(Iterable<E> iterable) {
    if (!_growable) throwNotGrowable();
    for (final element in iterable) {
      _addLast(element);
    }
  }

  @override
  void insert(int index, E element) {
    RangeError.checkValueInInterval(index, 0, _length, 'index');
    if (!_growable) throwNotGrowable();
    if (index == 0) {
      _addFirst(element);
    } else if (index == _length) {
      _addLast(element);
    } else {
      if (_length == _capacity) _grow();
      if (index < _length ~/ 2) {
        _head = (_head - 1) & _mask;
        for (var i = 0; i < index; i++) {
          _buffer[(_head + i) & _mask] = _buffer[(_head + i + 1) & _mask];
        }
        _buffer[(_head + index) & _mask] = element;
      } else {
        for (var i = _length; i > index; i--) {
          _buffer[(_head + i) & _mask] = _buffer[(_head + i - 1) & _mask];
        }
        _buffer[(_head + index) & _mask] = element;
      }
      _length++;
    }
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    RangeError.checkValueInInterval(index, 0, _length, 'index');
    if (!_growable) throwNotGrowable();
    final elements = identical(iterable, this) ? toList() : iterable;
    for (final element in elements) {
      insert(index++, element);
    }
  }

  @override
  void removeRange(int start, int end) {
    RangeError.checkValidRange(start, end, _length);
    if (!_growable) throwNotGrowable();
    final count = end - start;
    if (count == 0) return;
    if (start == 0) {
      for (var i = 0; i < count; i++) {
        _buffer[(_head + i) & _mask] = null;
      }
      _head = (_head + count) & _mask;
      _length -= count;
    } else if (end == _length) {
      for (var i = start; i < _length; i++) {
        _buffer[(_head + i) & _mask] = null;
      }
      _length -= count;
    } else {
      for (var i = 0; i < count; i++) {
        removeAt(start);
      }
    }
  }

  @override
  E removeAt(int index) {
    RangeError.checkValidIndex(index, this);
    if (!_growable) throwNotGrowable();
    final result = _buffer[(_head + index) & _mask] as E;
    if (index == 0) {
      _buffer[_head] = null;
      _head = (_head + 1) & _mask;
    } else if (index == _length - 1) {
      _buffer[(_head + _length - 1) & _mask] = null;
    } else if (index < _length ~/ 2) {
      for (var i = index; i > 0; i--) {
        _buffer[(_head + i) & _mask] = _buffer[(_head + i - 1) & _mask];
      }
      _buffer[_head] = null;
      _head = (_head + 1) & _mask;
    } else {
      for (var i = index; i < _length - 1; i++) {
        _buffer[(_head + i) & _mask] = _buffer[(_head + i + 1) & _mask];
      }
      _buffer[(_head + _length - 1) & _mask] = null;
    }
    _length--;
    return result;
  }

  @override
  E removeFirst() {
    if (_length == 0) throw StateError('No element');
    if (!_growable) throwNotGrowable();
    final result = _buffer[_head] as E;
    _buffer[_head] = null;
    _head = (_head + 1) & _mask;
    _length--;
    return result;
  }

  @override
  E removeLast() {
    if (_length == 0) throw StateError('No element');
    if (!_growable) throwNotGrowable();
    final index = (_head + _length - 1) & _mask;
    final result = _buffer[index] as E;
    _buffer[index] = null;
    _length--;
    return result;
  }

  @override
  bool remove(Object? element) {
    if (!_growable) throwNotGrowable();
    for (var i = 0; i < _length; i++) {
      if (this[i] == element) {
        removeAt(i);
        return true;
      }
    }
    return false;
  }

  @override
  Iterable<E> removeAll() {
    final result = toList();
    clear();
    return result;
  }

  @override
  void clear() {
    if (!_growable) throwNotGrowable();
    _buffer.fillRange(0, _capacity, null);
    _head = 0;
    _length = 0;
  }

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length > 0;

  @override
  E get first => isEmpty ? throw StateError('No element') : this[0];

  @override
  E get last => isEmpty ? throw StateError('No element') : this[_length - 1];

  @override
  Iterable<E> get unorderedElements => this;

  @override
  List<E> toUnorderedList() => toList();

  void _grow() {
    final newCapacity = math.max(_initialCapacity, _capacity * 2);
    final newBuffer = List<E?>.filled(newCapacity, null);
    final firstPart = _capacity - _head;
    if (_head + _length <= _capacity) {
      newBuffer.setRange(0, _length, _buffer, _head);
    } else {
      newBuffer.setRange(0, firstPart, _buffer, _head);
      newBuffer.setRange(firstPart, _length, _buffer, 0);
    }
    _head = 0;
    _buffer = newBuffer;
  }

  @protected
  Never throwNotGrowable() => throw UnsupportedError(
    'Cannot add to or remove from a fixed-length list',
  );
}

/// Extension on [Iterable] to convert to an [OrderedList].
extension OrderedListIterableExtension<E> on Iterable<E> {
  /// Converts this [Iterable] to an [OrderedList].
  OrderedList<E> toOrderedList({bool growable = true}) =>
      OrderedList<E>.of(this, growable: growable);
}
