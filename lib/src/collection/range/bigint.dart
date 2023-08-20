import '../../../feature.dart';
import '../../number/bigint.dart';
import '../range.dart';

/// A virtual range of [BigInt] containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///     for (BigInt i = start; i < stop; i += step) {
///       ...
///
class BigIntRange extends Range<BigInt> {
  /// Creates a virtual range of numbers containing an arithmetic progressions
  /// of [BigInt] values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `BigIntRange()` yields `<BigInt>[]`.
  ///
  /// The constructor called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example,
  /// `BigIntRange(BigInt.from(3))` yields
  /// `<BigInt>[BigInt.zero, BigInt.one, BigInt.two]`.
  ///
  /// The constructor called with two arguments returns the range between
  /// the two numbers (including the start, but excluding the end). For example,
  /// `BigIntRange(BigInt.from(3), BigInt.from(6))` yields
  /// `<BigInt>[BigInt.from(3), BigInt.from(4), BigInt.from(5)]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example,
  /// `BigIntRange(BigInt.from(1), BigInt.from(7), BigInt.from(2))` yields
  /// `<BigInt>[BigInt.from(1), BigInt.from(3), BigInt.from(5)]`.
  factory BigIntRange([BigInt? a, BigInt? b, BigInt? c]) {
    var start = BigInt.zero;
    var end = BigInt.zero;
    var step = BigInt.one;
    if (c != null) {
      start = a!;
      end = b!;
      step = c;
    } else if (b != null) {
      start = a!;
      end = b;
      step = start <= end ? BigInt.one : BigIntExtension.negativeOne;
    } else if (a != null) {
      end = a;
    }
    if (start < end) {
      if (step == BigInt.one) {
        return BigIntRange._(start, end, step, _toSafeLength(end - start));
      } else if (step > BigInt.one) {
        return BigIntRange._(start, end, step,
            _toSafeLength((end - start + step - BigInt.one) ~/ step));
      }
    } else if (start > end) {
      if (step == BigIntExtension.negativeOne) {
        return BigIntRange._(start, end, step, _toSafeLength(start - end));
      } else if (step < BigIntExtension.negativeOne) {
        return BigIntRange._(start, end, step,
            _toSafeLength((start - end - step - BigInt.one) ~/ -step));
      }
    } else {
      if (step != BigInt.zero) {
        return BigIntRange._(start, end, step, 0);
      }
    }
    throw ArgumentError.value(
        step, 'step', 'Invalid step size for range $start..$end');
  }

  BigIntRange._(this.start, this.end, this.step, this.length);

  @override
  final BigInt start;

  @override
  final BigInt end;

  @override
  final BigInt step;

  @override
  final int length;

  @override
  BigInt getUnchecked(int index) => start + step * BigInt.from(index);

  @override
  int indexOf(Object? element, [int startIndex = 0]) {
    if (element is BigInt) {
      if (startIndex < 0) startIndex = 0;
      if (startIndex < length) {
        final value = element - start;
        if (value % step == BigInt.zero) {
          final index = (value ~/ step).toInt();
          if (startIndex <= index && index < length) {
            return index;
          }
        }
      }
    }
    return -1;
  }

  @override
  BigIntRange get reversed =>
      isEmpty ? this : BigIntRange._(last, first - step, -step, length);

  @override
  BigIntRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return BigIntRange._(start + BigInt.from(startIndex) * step,
        start + BigInt.from(endIndex) * step, step, endIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'BigIntRange()';
    } else if (start == BigInt.zero && step == BigInt.one) {
      return 'BigIntRange($end)';
    } else if (step == BigInt.one) {
      return 'BigIntRange($start, $end)';
    } else {
      return 'BigIntRange($start, $end, $step)';
    }
  }
}

extension BigIntRangeExtension on BigInt {
  /// Shorthand to create a range of [BigInt] numbers, starting with the
  /// receiver (inclusive) up to but not including [end] (exclusive).
  BigIntRange to(BigInt end, {BigInt? step}) => BigIntRange(this, end, step);
}

final _safeLength = isJavaScript ? BigInt.two.pow(32) : BigInt.two.pow(64);

int _toSafeLength(BigInt length) {
  if (length <= _safeLength) {
    return length.toInt();
  }
  throw ArgumentError.value(
      length, 'length', 'Length cannot be represented using int');
}
