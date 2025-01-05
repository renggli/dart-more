// ignore_for_file: avoid_renaming_method_parameters

import 'dart:collection';

import 'package:meta/meta.dart';

import 'iterable/mixins/unmodifiable.dart';

/// Abstract superclass of an arithmetic progressions.
///
/// The progression is defined by a [Range.start], [Range.end] and [Range.step]
/// parameters. A range essentially implements a sequence of values of type [E]
/// as a [List]. The advantage is that a range uses very little memory no matter
/// its size.
@immutable
abstract class Range<E> extends ListBase<E> with UnmodifiableListMixin<E> {
  /// Constructor of the abstract [Range].
  const Range();

  /// The start value of the range (inclusive).
  E get start;

  /// The end value of the range (exclusive).
  E get end;

  /// The step size (non-zero).
  E get step;

  /// Returns the number of elements in the range.
  @override
  int get length;

  /// Returns an iterator positioned at the front of the range.
  @override
  @nonVirtual
  RangeIterator<E> get iterator => RangeIterator<E>.atStart(this);

  /// Returns an iterator positioned at the end of the range.
  @nonVirtual
  RangeIterator<E> get iteratorAtEnd => RangeIterator<E>.atEnd(this);

  @override
  @nonVirtual
  E operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    return getUnchecked(index);
  }

  /// Returns the element at the given [index] in the range.
  ///
  /// Does not perform range checks. The result is undefined, unless the [index]
  /// is within the expected bounds `0 <= index < length`.
  E getUnchecked(int index);

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
  Range<E> get reversed;

  @override
  Range<E> sublist(int startIndex, [int? endIndex]) =>
      getRange(startIndex, endIndex ?? length);

  @override
  Range<E> getRange(int startIndex, int endIndex);
}

/// An [Iterator] over a [Range].
class RangeIterator<T> implements Iterator<T> {
  /// Constructs a [RangeIterator] at the beginning of the range.
  RangeIterator.atStart(this.range) : _index = -1;

  /// Constructs a [RangeIterator] at the end of the range.
  RangeIterator.atEnd(this.range) : _index = range.length;

  /// The underlying range being iterated over.
  final Range<T> range;

  @override
  T get current => _current as T;

  int _index;
  T? _current;

  /// Advances the iterator to the next element of the iteration.
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

  /// Advances the iterator to the previous element of the iteration.
  bool movePrevious() {
    final index = _index - 1;
    if (0 <= index) {
      _current = range.getUnchecked(_index = index);
      return true;
    }
    _current = null;
    return false;
  }
}
