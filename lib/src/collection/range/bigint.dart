import '../range.dart';

/// A range of [BigInt] containing an arithmetic progressions.
///
/// The progression is defined by a [BigIntRange.start], [BigIntRange.end] and
/// [BigIntRange.step] parameters. A range essentially implements a lazy list
/// that is also produced by the following for-loop:
///
/// ```dart
///  for (BigInt i = start; i < end; i += step) {
///    // ...
/// }
/// ```
final class BigIntRange extends Range<BigInt> {
  /// The empty range.
  static final empty = BigIntRange._(BigInt.zero, BigInt.zero, BigInt.one, 0);

  /// Creates an arithmetic progressions of [BigInt] values.
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
  /// `<BigInt>[BigInt.from(3), BigInt.from(4), BigInt.from(5)]`.  If the second
  /// number is smaller than the first return a decreasing range, for example
  /// `BigIntRange(BigInt.from(6), BigInt.from(3))` yields
  /// `<BigInt>[BigInt.from(6), BigInt.from(5), BigInt.from(4)]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example,
  /// `BigIntRange(BigInt.from(1), BigInt.from(7), BigInt.from(2))` yields
  /// `<BigInt>[BigInt.from(1), BigInt.from(3), BigInt.from(5)]`.
  factory BigIntRange([BigInt? a, BigInt? b, BigInt? c]) {
    if (a != null && b != null && c != null) {
      if (c == BigInt.zero) throw ArgumentError.value(c, 'step');
      return BigIntRange.of(start: a, end: b, step: c);
    } else if (a != null && b != null && c == null) {
      return BigIntRange.of(start: a, end: b);
    } else if (a != null && b == null && c == null) {
      return BigIntRange.of(end: a, step: BigInt.one);
    } else if (a == null && b == null && c == null) {
      return empty;
    }
    throw ArgumentError('Invalid range: $a, $b, $c');
  }

  /// Const constructor to create an arithmetic progressions of [int] values
  /// between [start] (inclusive) and [end] (exclusive); and a step-value
  /// [step].
  factory BigIntRange.of({BigInt? start, BigInt? end, BigInt? step}) {
    start ??= BigInt.zero;
    end ??= BigInt.zero;
    step ??= start <= end ? BigInt.one : -BigInt.one;
    return BigIntRange._of1(start, end, step);
  }

  factory BigIntRange._of1(BigInt start, BigInt end, BigInt step) {
    final length = BigInt.zero < step && start < end
        ? BigInt.one + (end - start - BigInt.one) ~/ step
        : BigInt.zero > step && start > end
            ? BigInt.one + (start - end - BigInt.one) ~/ -step
            : BigInt.zero;
    if (!length.isValidInt) {
      throw ArgumentError.value(length, 'length', 'Range exceeds valid length');
    }
    return BigIntRange._(start, end, step, length.toInt());
  }

  /// Const constructor to create an arithmetic progression of [BigInt] values.
  /// The resulting [Range] is of the given [length], starts at [start], and
  /// uses the step-value [step].
  factory BigIntRange.length(int length, {BigInt? start, BigInt? step}) {
    start ??= BigInt.zero;
    step ??= BigInt.one;
    return BigIntRange._(
        start, start + BigInt.from(length) * step, step, length);
  }

  // Internal const-constructor that initializes all state.
  BigIntRange._(this.start, this.end, this.step, this.length)
      : assert(step != BigInt.zero, '`step` must not be zero'),
        assert(step < BigInt.zero || start <= end, '`step` must be positive'),
        assert(step > BigInt.zero || start >= end, '`step` must be negative'),
        assert(0 <= length, '`length` must be positive');

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
  // ignore: avoid_renaming_method_parameters
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
  BigIntRange get reversed => BigIntRange._(
      start + BigInt.from(length - 1) * step, start - step, -step, length);

  @override
  // ignore: avoid_renaming_method_parameters
  BigIntRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return BigIntRange._(start + BigInt.from(startIndex) * step,
        start + BigInt.from(endIndex) * step, step, endIndex - startIndex);
  }
}

extension BigIntRangeExtension on BigInt {
  /// Shorthand to create a range of [BigInt] numbers, starting with the
  /// receiver (inclusive) up to but not including [end] (exclusive).
  BigIntRange to(BigInt end, {BigInt? step}) =>
      BigIntRange.of(start: this, end: end, step: step);
}
