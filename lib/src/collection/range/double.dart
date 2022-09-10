import 'dart:collection' show ListBase;

import '../../../comparator.dart';
import '../../iterable/mixins/unmodifiable.dart' show UnmodifiableListMixin;
import '../range.dart';

/// A virtual range of doubles containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///   for (double i = start; i < stop; i += step) {
///     ...
///
class DoubleRange extends ListBase<double>
    with Range<double>, UnmodifiableListMixin<double> {
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
    if (start <= end) {
      if (step == 1.0) {
        return DoubleRange._(start, end, step, (end - start).ceil());
      } else if (step > 0.0) {
        return DoubleRange._(start, end, step, ((end - start) / step).ceil());
      }
    } else {
      if (step == -1.0) {
        return DoubleRange._(start, end, step, (start - end).ceil());
      } else if (step < 0.0) {
        return DoubleRange._(start, end, step, ((start - end) / -step).ceil());
      }
    }
    throw ArgumentError.value(
        step, 'step', 'Invalid step size for range $start..$end');
  }

  DoubleRange._(this.start, this.end, this.step, this.length);

  @override
  final double start;

  @override
  final double end;

  @override
  final double step;

  @override
  final int length;

  @override
  Iterator<double> get iterator => DoubleRangeIterator(start, step, length);

  @override
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    return start + step * index;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  int indexOf(Object? element, [int startIndex = 0]) {
    if (element is double) {
      if (startIndex < 0) startIndex = 0;
      if (startIndex < length) {
        final comparator = step > 0 ? _naturalComparator : _reverseComparator;
        final index = comparator.binarySearch(this, element);
        if (startIndex <= index && index < length) {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  DoubleRange get reversed =>
      isEmpty ? this : DoubleRange._(last, first - step, -step, length);

  @override
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

class DoubleRangeIterator extends Iterator<double> {
  DoubleRangeIterator(this.start, this.step, this.length);

  final double start;
  final double step;
  final int length;

  int index = 0;

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

extension DoubleRangeExtension on double {
  /// Shorthand to create a range of [double] numbers, starting with the
  /// receiver (inclusive) up to but not including [end] (exclusive).
  Range<double> to(double end, {double? step}) => DoubleRange(this, end, step);
}

final _naturalComparator = naturalComparator<double>();
final _reverseComparator = reverseComparator<double>();
