import 'dart:collection' show ListBase;
import 'dart:math' as math;

import 'package:meta/meta.dart' show internal;

/// A list with amortized constant-time addition and removal at both ends,
/// backed by a circular buffer.
///
/// Implements [List].
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
class OrderedList<E> extends ListBase<E> {
  /// Constructs an empty ordered list.
  new({this._growable = true})
    : _buffer = List<E?>.filled(_initialCapacity, null);

  /// Constructs an ordered list from an [iterable].
  ///
  /// The list is growable by default; pass `growable: false` for a
  /// fixed-length list.
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
  ///
  /// The list is fixed-length by default; pass `growable: true` for a growable
  /// list. Throws a [RangeError] if [length] is negative.
  new filled(int length, E fill, {this._growable = false})
    : _length = length,
      _buffer = List<E?>.filled(_computeCapacity(length), null) {
    _buffer.fillRange(0, length, fill);
  }

  static const int _initialCapacity = 8;

  static int _computeCapacity(int length) {
    RangeError.checkNotNegative(length, 'length');
    if (length <= _initialCapacity) return _initialCapacity;
    return 1 << (length - 1).bitLength;
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
  @internal
  int get startIndex => _head;

  /// Returns the end index of this list in the internal buffer.
  @internal
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
      _ensureCapacity(newLength);
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
  ///
  /// Throws an [UnsupportedError] if this list is fixed-length.
  void addFirst(E element) => _addFirst(element);

  /// Adds [element] to the end of this list.
  ///
  /// Throws an [UnsupportedError] if this list is fixed-length.
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
    final elements = identical(iterable, this) ? toList() : iterable;
    if (elements is List<E> || elements is Set<E>) {
      _ensureCapacity(_length + elements.length);
    }
    for (final element in elements) {
      if (_length == _capacity) _grow();
      _buffer[(_head + _length++) & _mask] = element;
    }
  }

  @override
  void insert(int index, E element) {
    if (!_growable) throwNotGrowable();
    RangeError.checkValueInInterval(index, 0, _length, 'index');
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
    if (!_growable) throwNotGrowable();
    RangeError.checkValueInInterval(index, 0, _length, 'index');
    final elements = identical(iterable, this)
        ? toList()
        : (iterable is List<E> ? iterable : iterable.toList());
    final count = elements.length;
    if (count == 0) return;
    _ensureCapacity(_length + count);
    if (index < _length ~/ 2) {
      _head = (_head - count) & _mask;
      for (var i = 0; i < index; i++) {
        _buffer[(_head + i) & _mask] = _buffer[(_head + i + count) & _mask];
      }
    } else {
      for (var i = _length - 1; i >= index; i--) {
        _buffer[(_head + i + count) & _mask] = _buffer[(_head + i) & _mask];
      }
    }
    for (var i = 0; i < count; i++) {
      _buffer[(_head + index + i) & _mask] = elements[i];
    }
    _length += count;
  }

  @override
  void removeRange(int start, int end) {
    if (!_growable) throwNotGrowable();
    RangeError.checkValidRange(start, end, _length);
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
    } else if (start < _length - end) {
      for (var i = start - 1; i >= 0; i--) {
        _buffer[(_head + i + count) & _mask] = _buffer[(_head + i) & _mask];
      }
      for (var i = 0; i < count; i++) {
        _buffer[(_head + i) & _mask] = null;
      }
      _head = (_head + count) & _mask;
      _length -= count;
    } else {
      for (var i = start; i < _length - count; i++) {
        _buffer[(_head + i) & _mask] = _buffer[(_head + i + count) & _mask];
      }
      for (var i = _length - count; i < _length; i++) {
        _buffer[(_head + i) & _mask] = null;
      }
      _length -= count;
    }
  }

  @override
  void removeWhere(bool Function(E element) test) {
    if (!_growable) throwNotGrowable();
    final retained = <E>[];
    final startLength = _length;
    final startHead = _head;
    for (var i = 0; i < startLength; i++) {
      final element = _buffer[(startHead + i) & _mask] as E;
      if (!test(element)) {
        retained.add(element);
      }
      if (_length != startLength || _head != startHead) {
        throw ConcurrentModificationError(this);
      }
    }
    if (retained.length == startLength) return;
    for (var i = 0; i < retained.length; i++) {
      _buffer[(_head + i) & _mask] = retained[i];
    }
    for (var i = retained.length; i < _length; i++) {
      _buffer[(_head + i) & _mask] = null;
    }
    _length = retained.length;
  }

  @override
  void retainWhere(bool Function(E element) test) =>
      removeWhere((element) => !test(element));

  @override
  E removeAt(int index) {
    if (!_growable) throwNotGrowable();
    RangeError.checkValidIndex(index, this);
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

  /// Removes and returns the first element of this list.
  ///
  /// Throws an [UnsupportedError] if this list is fixed-length, or a
  /// [StateError] if this list is empty.
  E removeFirst() {
    if (!_growable) throwNotGrowable();
    if (_length == 0) throw StateError('No element');
    final result = _buffer[_head] as E;
    _buffer[_head] = null;
    _head = (_head + 1) & _mask;
    _length--;
    return result;
  }

  /// Removes and returns the last element of this list.
  ///
  /// Throws an [UnsupportedError] if this list is fixed-length, or a
  /// [StateError] if this list is empty.
  @override
  E removeLast() {
    if (!_growable) throwNotGrowable();
    if (_length == 0) throw StateError('No element');
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
      if (_buffer[(_head + i) & _mask] == element) {
        removeAt(i);
        return true;
      }
    }
    return false;
  }

  /// Removes all elements and returns them in a new list.
  ///
  /// Throws an [UnsupportedError] if this list is fixed-length.
  Iterable<E> removeAll() {
    if (!_growable) throwNotGrowable();
    final result = toList();
    clear();
    return result;
  }

  @override
  void clear() {
    if (!_growable) throwNotGrowable();
    if (_head + _length <= _capacity) {
      _buffer.fillRange(_head, _head + _length, null);
    } else {
      _buffer.fillRange(_head, _capacity, null);
      _buffer.fillRange(0, (_head + _length) & _mask, null);
    }
    _head = 0;
    _length = 0;
  }

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length > 0;

  @override
  E get first => isEmpty ? throw StateError('No element') : _buffer[_head] as E;

  @override
  E get last => isEmpty
      ? throw StateError('No element')
      : _buffer[(_head + _length - 1) & _mask] as E;

  /// Elements in list order.
  Iterable<E> get unorderedElements => this;

  /// Returns elements in list order as a list.
  List<E> toUnorderedList() => toList();

  void _ensureCapacity(int minCapacity) {
    if (_capacity >= minCapacity) return;
    _resize(_computeCapacity(minCapacity));
  }

  void _grow() => _resize(math.max(_initialCapacity, _capacity * 2));

  void _resize(int newCapacity) {
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

  @internal
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
