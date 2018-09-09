library more.collection.integer_range;

import 'dart:collection' show ListBase;

import 'package:more/src/iterable/mixins/unmodifiable.dart'
    show UnmodifiableListMixin;

/// A virtual range of integers containing an arithmetic progressions.
class IntegerRange extends ListBase<int> with UnmodifiableListMixin<int> {
  /// Creates a virtual range of numbers containing an arithmetic progressions
  /// of integer values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `new IntegerRange()` yields `<int>[]`.
  ///
  /// The constructor called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example, `IntegerRange(3)`
  /// yields `<int>[0, 1, 2]`.
  ///
  /// The constructor called with two arguments returns the range between
  /// the two numbers (including the start, but excluding the end). For example,
  /// `IntegerRange(3, 6)` yields `<int>[3, 4, 5]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `IntegerRange(1, 7, 2)` yields `<int>[1, 3, 5]`.
  factory IntegerRange([int a, int b, int c]) {
    var start = 0;
    var stop = 0;
    var step = 1;
    if (c != null) {
      start = a;
      stop = b;
      step = c;
    } else if (b != null) {
      start = a;
      stop = b;
      step = start <= stop ? 1 : -1;
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
    if (span % step != 0) {
      length++;
    }
    return IntegerRange._(start, stop, step, length);
  }

  IntegerRange._(this.start, this.stop, this.step, this.length);

  /// The start of the range (inclusive).
  final int start;

  /// The stop of the range (exclusive).
  final int stop;

  /// The step size.
  final int step;

  @override
  final int length;

  @override
  Iterator<int> get iterator => IntegerRangeIterator(start, step, length);

  @override
  int operator [](int index) {
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
    if (element is int) {
      if (startIndex < 0) {
        startIndex = 0;
      }
      if (startIndex < length) {
        final value = element - start;
        if (value % step == 0) {
          final index = value ~/ step;
          if (index >= startIndex) {
            return index;
          }
        }
      }
    }
    return -1;
  }

  @override
  int lastIndexOf(Object element, [int startIndex]) {
    if (element is int) {
      if (startIndex == null || length <= startIndex) {
        startIndex = length - 1;
      }
      if (startIndex >= 0) {
        final value = element - start;
        if (value % step == 0) {
          final index = value ~/ step;
          if (index <= startIndex) {
            return index;
          }
        }
      }
    }
    return -1;
  }

  @override
  IntegerRange get reversed =>
      isEmpty ? this : IntegerRange._(last, first - step, -step, length);

  @override
  IntegerRange sublist(int startIndex, [int stopIndex]) =>
      getRange(startIndex, stopIndex ?? length);

  @override
  IntegerRange getRange(int startIndex, int stopIndex) {
    RangeError.checkValidRange(startIndex, stopIndex, length);
    return IntegerRange._(start + startIndex * step, start + stopIndex * step,
        step, stopIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'new IntegerRange()';
    } else if (start == 0 && step == 1) {
      return 'new IntegerRange($stop)';
    } else if (step == 1) {
      return 'new IntegerRange($start, $stop)';
    } else {
      return 'new IntegerRange($start, $stop, $step)';
    }
  }
}

class IntegerRangeIterator extends Iterator<int> {
  final int start;
  final int step;
  final int length;

  int index = 0;

  IntegerRangeIterator(this.start, this.step, this.length);

  @override
  int current;

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
