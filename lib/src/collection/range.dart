// ignore_for_file: avoid_renaming_method_parameters

import 'dart:collection';

import 'package:meta/meta.dart';

import 'iterable/mixins/unmodifiable.dart';

/// Abstract superclass of an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a sequence of values of type [T] as a [List].
/// The advantage is that a range uses little memory no matter its size.
abstract class Range<T> extends ListBase<T> with UnmodifiableListMixin<T> {
  /// Constructor of the abstract [Range].
  const Range();

  /// The start value of the range (inclusive).
  T get start;

  /// The end value of the range (exclusive).
  T get end;

  /// The step size (non-zero).
  T get step;

  @override
  @nonVirtual
  RangeIterator<T> get iterator => RangeIterator<T>(this);

  @override
  @nonVirtual
  T operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    return getUnchecked(index);
  }

  /// Returns the element at the given [index] in the range.
  ///
  /// Does not perform range checks. The result is undefined, unless the [index]
  /// is within the expected bounds `0 <= index < length`.
  T getUnchecked(int index);

  @override
  bool contains(Object? element) => indexOf(element) >= 0;

  @override
  int indexOf(Object? element, [int startIndex = 0]);

  @override
  int lastIndexOf(Object? element, [int? endIndex]) {
    // Since elements appear only once, we can use `indexOf`.
    final index = indexOf(element);
    return 0 <= index && index <= (endIndex ?? length - 1) ? index : -1;
  }

  @override
  Range<T> get reversed;

  @override
  Range<T> sublist(int startIndex, [int? endIndex]) =>
      getRange(startIndex, endIndex ?? length);

  @override
  Range<T> getRange(int startIndex, int endIndex);
}

/// An [Iterator] over a [Range], provides various additional accessors of the
/// standard collection iterator.
class RangeIterator<T> implements Iterator<T> {
  /// Constructs a [RangeIterator] at the beginning of the range.
  RangeIterator(this.range) : _index = -1;

  /// The underlying range being iterated over.
  final Range<T> range;

  @override
  T get current => _current as T;

  int _index;
  T? _current;

  @override
  bool moveNext() {
    final index = _index + 1;
    if (index < range.length) {
      _current = range.getUnchecked(_index = index);
      return true;
    }
    _current = null;
    return false;
  }
}
