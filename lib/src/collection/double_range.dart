library more.collection.double_range;

import 'dart:collection' show ListBase;

import 'package:more/ordering.dart' show Ordering;
import 'package:more/src/iterable/mixins/unmodifiable.dart'
    show UnmodifiableListMixin;

/// A virtual range of doubles containing an arithmetic progressions.
class DoubleRange extends ListBase<double> with UnmodifiableListMixin<double> {
  /// Creates a virtual range of numbers containing an arithmetic progressions
  /// of double values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `new DoubleRange()` yields `<double>[]`.
  ///
  /// The constructor called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example, `DoubleRange(3.0)`
  /// yields `<double>[0.0, 1.0, 2.0]`.
  ///
  /// The constructor called with two arguments returns the range between
  /// the two numbers (including the start, but excluding the end). For example,
  /// `DoubleRange(3.0, 6.0)` yields `<double>[3.0, 4.0, 5.0]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `DoubleRange(1.0, 7.0, 2.1)` yields
  /// `<double>[1.0, 3.1, 5.2]`.
  factory DoubleRange([double a, double b, double c]) {
    var start = 0.0;
    var stop = 0.0;
    var step = 1.0;
    if (c != null) {
      start = a;
      stop = b;
      step = c;
    } else if (b != null) {
      start = a;
      stop = b;
      step = start <= stop ? 1.0 : -1.0;
    } else if (a != null) {
      stop = a;
    }
    if (step == 0) {
      throw ArgumentError('Non-zero step-size expected');
    } else if (start < stop && step < 0) {
      throw ArgumentError('Positive step-size expected');
    } else if (start > stop && step > 0) {
      throw ArgumentError('Negative step-size expected');
    }
    final span = stop - start;
    var length = span ~/ step;
    if (length > 0) {
      // Due to truncation in the division above, it can happen that the last
      // element is still within the requested range. Make sure to include it.
      final last = start + length * step;
      if ((step > 0.0 && last < stop) || (step < 0.0 && last > stop)) {
        length++;
      }
    }
    return DoubleRange._(start, stop, step, length);
  }

  DoubleRange._(this.start, this.stop, this.step, this.length);

  /// The start of the range (inclusive).
  final double start;

  /// The stop of the range (exclusive).
  final double stop;

  /// The step size.
  final double step;

  @override
  final int length;

  @override
  Iterator<double> get iterator => DoubleRangeIterator(start, step, length);

  @override
  double operator [](int index) {
    if (0 <= index && index < length) {
      return start + step * index;
    } else {
      throw RangeError.range(index, 0, length);
    }
  }

  @override
  bool contains(Object element) => indexOf(element) >= 0;

  @override
  int indexOf(Object element, [int startIndex = 0]) {
    if (element is double) {
      if (startIndex < 0) {
        startIndex = 0;
      }
      final ordering = step > 0
          ? Ordering<double>.natural()
          : Ordering<double>.natural().reversed;
      final index = ordering.binarySearch(this, element);
      if (startIndex <= index) {
        return index;
      }
    }
    return -1;
  }

  @override
  int lastIndexOf(Object element, [int stopIndex]) {
    if (element is double) {
      if (stopIndex == null || length <= stopIndex) {
        stopIndex = length - 1;
      }
      if (stopIndex < 0) {
        return -1;
      }
      final ordering = step > 0
          ? Ordering<double>.natural()
          : Ordering<double>.natural().reversed;
      final index = ordering.binarySearch(this, element);
      if (0 <= index && index <= stopIndex) {
        return index;
      }
    }
    return -1;
  }

  @override
  DoubleRange get reversed =>
      isEmpty ? this : DoubleRange._(last, first - step, -step, length);

  @override
  DoubleRange sublist(int startIndex, [int stopIndex]) =>
      getRange(startIndex, stopIndex ?? length);

  @override
  DoubleRange getRange(int startIndex, int stopIndex) {
    RangeError.checkValidRange(startIndex, stopIndex, length);
    return DoubleRange._(start + startIndex * step, start + stopIndex * step,
        step, stopIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'new DoubleRange()';
    } else if (start == 0.0 && step == 1) {
      return 'new DoubleRange($stop)';
    } else if (step == 1.0) {
      return 'new DoubleRange($start, $stop)';
    } else {
      return 'new DoubleRange($start, $stop, $step)';
    }
  }
}

class DoubleRangeIterator extends Iterator<double> {
  final double start;
  final double step;
  final int length;

  int index = 0;

  DoubleRangeIterator(this.start, this.step, this.length);

  @override
  double current;

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
