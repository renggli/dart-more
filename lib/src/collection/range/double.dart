import '../../../comparator.dart';
import '../range.dart';

/// A range of doubles containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///     for (double i = start; i < stop; i += step) {
///       ...
///
class DoubleRange extends Range<double> {
  /// Creates an arithmetic progressions of [double] values.
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
  /// `DoubleRange(3.0, 6.0)` yields `<double>[3.0, 4.0, 5.0]`. If the second
  /// number is smaller than the first return a decreasing range, for example
  /// `DoubleRange(6.0, 3.0)` yields `<double>[6.0, 5.0, 4.0]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `DoubleRange(1.0, 7.0, 2.1)` yields
  /// `<double>[1.0, 3.1, 5.2]`.
  factory DoubleRange([double? a, double? b, double? c]) {
    if (a != null && b != null && c != null) {
      if (c == 0) throw ArgumentError.value(c, 'step');
      return DoubleRange.of(start: a, end: b, step: c);
    } else if (a != null && b != null && c == null) {
      return DoubleRange.of(start: a, end: b);
    } else if (a != null && b == null && c == null) {
      return DoubleRange.of(end: a, step: 1);
    } else if (a == null && b == null && c == null) {
      return const DoubleRange._c3(0, 0, 1);
    }
    throw ArgumentError('Invalid range: $a, $b, $c');
  }

  /// Const constructor to create an arithmetic progressions of [double] values
  /// between [start] (inclusive) and [end] (exclusive); and a step-value
  /// [step].
  const DoubleRange.of({double start = 0, double end = 0, double? step})
      : this._c3(start, end, step ?? (start <= end ? 1 : -1));

  // Internal const-constructor that infers the length.
  const DoubleRange._c3(double start, double end, double step)
      : this._c4(
            start,
            end,
            step,
            0 < step && start < end
                ? (end - start) ~/ step + ((end - start) % step > 0 ? 1 : 0)
                : 0 > step && start > end
                    ? (start - end) ~/ -step +
                        ((start - end) % -step > 0 ? 1 : 0)
                    : 0);

  // Internal const-constructor that initializes all state.
  const DoubleRange._c4(this.start, this.end, this.step, this.length)
      : assert(step != 0, 'step must not be zero');

  @override
  final double start;

  @override
  final double end;

  @override
  final double step;

  @override
  final int length;

  @override
  double getUnchecked(int index) => start + step * index;

  @override
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
      DoubleRange._c4(start + (length - 1) * step, start - step, -step, length);

  @override
  DoubleRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return DoubleRange._c4(start + startIndex * step, start + endIndex * step,
        step, endIndex - startIndex);
  }
}

extension DoubleRangeExtension on double {
  /// Shorthand to create a range of [double] numbers, starting with the
  /// receiver (inclusive) up to but not including [end] (exclusive).
  Range<double> to(double end, {double? step}) =>
      DoubleRange.of(start: this, end: end, step: step);
}

const _naturalComparator = naturalComparable<num>;
const _reverseComparator = reverseComparable<num>;
