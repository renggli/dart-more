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
List<E> range<E extends num>([E a, E b, E c]) {
  return new Range<E>(a, b, c);
}

/// A virtual range of numbers containing an arithmetic progressions.
class Range<E extends num> extends ListBase<E> with UnmodifiableListMixin<E> {

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
  factory Range([E a, E b, E c]) {
    const num zero = 0;
    const num one = 1;
    E start = zero;
    E stop = zero;
    E step = one;
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
  final E start;

  /// The stop of the range (exclusive).
  final E stop;

  /// The step size.
  final E step;

  @override
  final int length;

  @override
  Iterator<E> get iterator => new RangeIterator<E>(start, step, length);

  @override
  E operator [](int index) {
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
          ? new Ordering<E>.natural()
          : new Ordering<E>.natural().reversed;
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
          ? new Ordering<E>.natural()
          : new Ordering<E>.natural().reversed;
      var index = ordering.binarySearch(this, element);
      if (0 <= index && index <= stopIndex) {
        return index;
      }
    }
    return -1;
  }

  @override
  Range<E> get reversed => isEmpty ? this : new Range._(last, first - step, -step, length);

  @override
  Range<E> sublist(int startIndex, [int stopIndex]) {
    return getRange(startIndex, stopIndex ?? length);
  }

  @override
  Range<E> getRange(int startIndex, int stopIndex) {
    RangeError.checkValidRange(startIndex, stopIndex, length);
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
      return 'range($stop)';
    } else if (step == 1) {
      return 'range($start, $stop)';
    } else {
      return 'range($start, $stop, $step)';
    }
  }

}

class RangeIterator<E extends num> extends Iterator<E> {
  final E start;
  final E step;
  final int length;

  int index = 0;

  RangeIterator(this.start, this.step, this.length);

  @override
  E current;

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
