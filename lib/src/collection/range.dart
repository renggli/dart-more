library more.collection.range;

import 'dart:collection' show ListBase;

import 'package:more/ordering.dart' show Ordering;
import 'package:more/src/iterable/mixins/unmodifiable.dart' show UnmodifiableListMixin;

/// Creates a virtual range of numbers containing an arithmetic progressions.
///
/// The range function called without any arguments returns the empty range.
/// For example, `range()` yields `[]`.
///
/// The range function called with one argument returns the range of all
/// numbers up to, but excluding the end. For example, `range(3)` yields
/// `[0, 1, 2]`.
///
/// The range function called with two arguments returns the range between
/// the two numbers (including the start, but excluding the end). For example,
/// `range(3, 6)` yields `[3, 4, 5]`.
///
/// The range function called with three arguments returns the range between
/// the first two numbers (including the start, but excluding the end) and the
/// step value. For example, `range(1, 7, 2)` yields `[1, 3, 5]`.
List<T> range<T extends num>([T a, T b, T c]) {
  return new Range<T>(a, b, c);
}

/// A virtual range of numbers containing an arithmetic progressions.
class Range<T extends num> extends ListBase<T> with UnmodifiableListMixin<T> {

  /// Creates a virtual range of numbers containing an arithmetic progressions.
  ///
  /// The range function called without any arguments returns the empty range.
  /// For example, `range()` yields `[]`.
  ///
  /// The range function called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example, `range(3)` yields
  /// `[0, 1, 2]`.
  ///
  /// The range function called with two arguments returns the range between
  /// the two numbers (including the start, but excluding the end). For example,
  /// `range(3, 6)` yields `[3, 4, 5]`.
  ///
  /// The range function called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `range(1, 7, 2)` yields `[1, 3, 5]`.
  factory Range([T a, T b, T c]) {
    const num zero = 0;
    const num one = 1;
    T start = zero;
    T stop = zero;
    T step = one;
    if (c != null) {
      start = a;
      stop = b;
      step = c;
    } else if (b != null) {
      start = a;
      stop = b;
      step = start <= stop ? one : -one;
    } else if (a != null) {
      stop = a;
    }
    if (step == 0) {
      throw new ArgumentError('Non-zero step-size expected');
    } else if (start < stop && step < 0) {
      throw new ArgumentError('Positive step-size expected');
    } else if (start > stop && step > 0) {
      throw new ArgumentError('Negative step-size expected');
    }
    var length = (stop - start) ~/ step;
    if (length > 0) {
      // Due to truncation in the division above, it can happen that the last element
      // is still within the requested range. Make sure to include it.
      var last = start + length * step;
      if ((step > zero && last < stop) || (step < zero && last > stop)) {
        length++;
      }
    }
    return new Range._(start, stop, step, length);
  }

  Range._(this.start, this.stop, this.step, this.length);

  /// The start of the range (inclusive).
  final T start;

  /// The stop of the range (exclusive).
  final T stop;

  /// The step size.
  final T step;

  @override
  final int length;

  @override
  Iterator<T> get iterator => new RangeIterator<T>(start, step, length);

  @override
  T operator [](int index) {
    if (0 <= index && index < length) {
      return start + step * index;
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  @override
  bool contains(Object element) => indexOf(element) >= 0;

  @override
  int indexOf(Object element, [int startIndex = 0]) {
    if (element is num) {
      if (startIndex < 0) {
        startIndex = 0;
      }
      var ordering = step > 0
          ? new Ordering<T>.natural()
          : new Ordering<T>.natural().reversed;
      var index = ordering.binarySearch(this, element);
      if (startIndex <= index) {
        return index;
      }
    }
    return -1;
  }

  @override
  int lastIndexOf(Object element, [int stopIndex]) {
    if (element is num) {
      if (stopIndex == null || length <= stopIndex) {
        stopIndex = length - 1;
      }
      if (stopIndex < 0) {
        return -1;
      }
      var ordering = step > 0
          ? new Ordering<T>.natural()
          : new Ordering<T>.natural().reversed;
      var index = ordering.binarySearch(this, element);
      if (0 <= index && index <= stopIndex) {
        return index;
      }
    }
    return -1;
  }

  @override
  List<T> sublist(int startIndex, [int stopIndex]) {
    stopIndex ??= length;
    if (stopIndex < startIndex || stopIndex > length) {
      throw new RangeError.range(stopIndex, startIndex, length);
    }
    return new Range._(
        start + startIndex * step,
        start + stopIndex * step,
        step,
        stopIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'range()';
    } else if (start == 0 && step == 1) {
      return 'range(${stop})';
    } else if (step == 1) {
      return 'range(${start}, ${stop})';
    } else {
      return 'range(${start}, ${stop}, ${step})';
    }
  }

}

class RangeIterator<T extends num> extends Iterator<T> {
  final T start;
  final T step;
  final int length;

  int index = 0;

  RangeIterator(this.start, this.step, this.length);

  @override
  T current;

  @override
  bool moveNext() {
    if (index == length) {
      current = null;
      return false;
    } else {
      current = start + step * index++;
      return true;
    }
  }
}
