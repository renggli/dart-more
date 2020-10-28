import 'dart:collection' show ListBase;

import '../../feature.dart';
import '../iterable/mixins/unmodifiable.dart' show UnmodifiableListMixin;

/// A virtual range of [BigInt] containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///   for (BigInt i = start; i < stop; i += step) {
///     ...
///
class BigIntRange extends ListBase<BigInt> with UnmodifiableListMixin<BigInt> {
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
      step = start <= end ? BigInt.one : -BigInt.one;
    } else if (a != null) {
      end = a;
    }
    if (step == BigInt.zero) {
      throw ArgumentError.value(step, 'step', 'Non-zero step-size expected');
    } else if (start < end && step < BigInt.zero) {
      throw ArgumentError.value(step, 'step', 'Positive step-size expected');
    } else if (start > end && step > BigInt.zero) {
      throw ArgumentError.value(step, 'step', 'Negative step-size expected');
    }
    final span = end - start;
    var length = span ~/ step;
    if (span % step != BigInt.zero) {
      length += BigInt.one;
    }
    if (maxLength <= length) {
      throw ArgumentError('The list has a length ($length) that can\'t be '
          'represented as an `int` without losing precision ($maxLength). This '
          'breaks the Dart collection API.');
    }
    return BigIntRange._(start, end, step, length.toInt());
  }

  BigIntRange._(this.start, this.end, this.step, this.length);

  /// The start of the range (inclusive).
  final BigInt start;

  /// The end of the range (exclusive).
  final BigInt end;

  /// The step size.
  final BigInt step;

  @override
  final int length;

  @override
  Iterator<BigInt> get iterator => step > BigInt.zero
      ? PositiveStepBigIntRangeIterator(start, end, step)
      : NegativeStepBigIntRangeIterator(start, end, step);

  @override
  BigInt operator [](int index) {
    if (0 <= index && index < length) {
      return start + step * BigInt.from(index);
    } else {
      throw RangeError.range(index, 0, length);
    }
  }

  @override
  bool contains(Object? element) => indexOf(element) >= 0;

  @override
  // ignore: avoid_renaming_method_parameters
  int indexOf(Object? element, [int startIndex = 0]) {
    if (element is BigInt) {
      if (startIndex < 0) {
        startIndex = 0;
      }
      if (startIndex < length) {
        final value = element - start;
        if (value % step == BigInt.zero) {
          final index = (value ~/ step).toInt();
          if (index >= startIndex) {
            return index;
          }
        }
      }
    }
    return -1;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  int lastIndexOf(Object? element, [int? endIndex]) {
    if (element is BigInt) {
      if (endIndex == null || length <= endIndex) {
        endIndex = length - 1;
      }
      if (endIndex >= 0) {
        final value = element - start;
        if (value % step == BigInt.zero) {
          final index = (value ~/ step).toInt();
          if (index <= endIndex) {
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
  // ignore: avoid_renaming_method_parameters
  BigIntRange sublist(int startIndex, [int? endIndex]) =>
      getRange(startIndex, endIndex ?? length);

  @override
  // ignore: avoid_renaming_method_parameters
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

class PositiveStepBigIntRangeIterator extends Iterator<BigInt> {
  BigInt start;
  final BigInt end;
  final BigInt step;

  PositiveStepBigIntRangeIterator(this.start, this.end, this.step)
      : assert(step > BigInt.zero, 'Step size must be positive.');

  @override
  late BigInt current;

  @override
  bool moveNext() {
    if (start < end) {
      current = start;
      start += step;
      return true;
    }
    return false;
  }
}

class NegativeStepBigIntRangeIterator extends Iterator<BigInt> {
  BigInt start;
  final BigInt end;
  final BigInt step;

  NegativeStepBigIntRangeIterator(this.start, this.end, this.step)
      : assert(step < BigInt.zero, 'Step size must be negative.');

  @override
  late BigInt current;

  @override
  bool moveNext() {
    if (start > end) {
      current = start;
      start += step;
      return true;
    }
    return false;
  }
}

final maxLength = isJavaScript ? BigInt.two.pow(32) : BigInt.two.pow(64);
