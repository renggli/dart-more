import 'dart:collection' show ListBase;

import '../../ordering.dart' show Ordering;
import '../iterable/mixins/unmodifiable.dart' show UnmodifiableListMixin;

/// A virtual range of doubles containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///   for (double i = start; i < stop; i += step) {
///     ...
///
class DoubleRange extends ListBase<double> with UnmodifiableListMixin<double> {
  /// Creates a virtual range of numbers containing an arithmetic progressions
  /// of double values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `DoubleRange()` yields `<double>[]`.
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
  factory DoubleRange([double? a, double? b, double? c]) {
    var start = 0.0;
    var end = 0.0;
    var step = 1.0;
    if (c != null) {
      start = a!;
      end = b!;
      step = c;
    } else if (b != null) {
      start = a!;
      end = b;
      step = start <= end ? 1.0 : -1.0;
    } else if (a != null) {
      end = a;
    }
    if (step == 0) {
      throw ArgumentError.value(step, 'step', 'Non-zero step-size expected');
    } else if (start < end && step < 0) {
      throw ArgumentError.value(step, 'step', 'Positive step-size expected');
    } else if (start > end && step > 0) {
      throw ArgumentError.value(step, 'step', 'Negative step-size expected');
    }
    final span = end - start;
    var length = span ~/ step;
    if (length > 0) {
      // Due to truncation in the division above, it can happen that the last
      // element is still within the requested range. Make sure to include it.
      final last = start + length * step;
      if ((step > 0.0 && last < end) || (step < 0.0 && last > end)) {
        length++;
      }
    }
    return DoubleRange._(start, end, step, length);
  }

  DoubleRange._(this.start, this.end, this.step, this.length);

  /// The start of the range (inclusive).
  final double start;

  /// The end of the range (exclusive).
  final double end;

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
  bool contains(Object? element) => indexOf(element) >= 0;

  @override
  // ignore: avoid_renaming_method_parameters
  int indexOf(Object? element, [int startIndex = 0]) {
    if (element is double) {
      if (startIndex < 0) {
        startIndex = 0;
      }
      final ordering =
          step > 0 ? Ordering.natural<num>() : Ordering.natural<num>().reversed;
      final index = ordering.binarySearch(this, element);
      if (startIndex <= index) {
        return index;
      }
    }
    return -1;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  int lastIndexOf(Object? element, [int? endIndex]) {
    if (element is double) {
      if (endIndex == null || length <= endIndex) {
        endIndex = length - 1;
      }
      if (endIndex < 0) {
        return -1;
      }
      final ordering =
          step > 0 ? Ordering.natural<num>() : Ordering.natural<num>().reversed;
      final index = ordering.binarySearch(this, element);
      if (0 <= index && index <= endIndex) {
        return index;
      }
    }
    return -1;
  }

  @override
  DoubleRange get reversed =>
      isEmpty ? this : DoubleRange._(last, first - step, -step, length);

  @override
  // ignore: avoid_renaming_method_parameters
  DoubleRange sublist(int startIndex, [int? endIndex]) =>
      getRange(startIndex, endIndex ?? length);

  @override
  // ignore: avoid_renaming_method_parameters
  DoubleRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return DoubleRange._(start + startIndex * step, start + endIndex * step,
        step, endIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'DoubleRange()';
    } else if (start == 0.0 && step == 1.0) {
      return 'DoubleRange($end)';
    } else if (step == 1.0) {
      return 'DoubleRange($start, $end)';
    } else {
      return 'DoubleRange($start, $end, $step)';
    }
  }
}

extension DoubleRangeExtension on double {
  /// Shorthand to create a range of [double] numbers, starting with the
  /// receiver (inclusive) up to but not including [end] (exclusive).
  DoubleRange to(double end, {double? step}) => DoubleRange(this, end, step);
}

class DoubleRangeIterator extends Iterator<double> {
  final double start;
  final double step;
  final int length;

  int index = 0;

  DoubleRangeIterator(this.start, this.step, this.length);

  @override
  late double current;

  @override
  bool moveNext() {
    if (index == length) {
      return false;
    } else {
      current = start + step * index++;
      return true;
    }
  }
}
