import '../range.dart';

/// A range of integers containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///     for (int i = start; i < stop; i += step) {
///       ...
///
class IntegerRange extends Range<int> {
  /// Creates an arithmetic progressions of [int] values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `IntegerRange()` yields `<int>[]`.
  ///
  /// The constructor called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example, `IntegerRange(3)`
  /// yields `<int>[0, 1, 2]`. Negative arguments yield an empty sequence.
  ///
  /// The constructor called with two arguments returns the range between
  /// the two numbers (including the start, but excluding the end). For example,
  /// `IntegerRange(3, 6)` yields `<int>[3, 4, 5]`. If the second number is
  /// smaller than the first return a decreasing range, for example
  /// `IntegerRange(6, 3)` yields `<int>[6, 5, 4]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `IntegerRange(1, 7, 2)` yields `<int>[1, 3, 5]`.
  factory IntegerRange([int? a, int? b, int? c]) {
    if (a != null && b != null && c != null) {
      if (c == 0) throw ArgumentError.value(c, 'step');
      return IntegerRange.of(start: a, end: b, step: c);
    } else if (a != null && b != null && c == null) {
      return IntegerRange.of(start: a, end: b);
    } else if (a != null && b == null && c == null) {
      return IntegerRange.of(end: a, step: 1);
    } else if (a == null && b == null && c == null) {
      return const IntegerRange._c3(0, 0, 1);
    }
    throw ArgumentError('Invalid range: $a, $b, $c');
  }

  /// Const constructor to create an arithmetic progressions of [int] values
  /// between [start] (inclusive) and [end] (exclusive); and a step-value
  /// [step].
  const IntegerRange.of({int start = 0, int end = 0, int? step})
      : this._c3(start, end, step ?? (start <= end ? 1 : -1));

  // Internal const-constructor that infers the length.
  const IntegerRange._c3(int start, int end, int step)
      : this._c4(
            start,
            end,
            step,
            0 < step && start < end
                ? 1 + (end - start - 1) ~/ step
                : 0 > step && start > end
                    ? 1 + (start - end - 1) ~/ -step
                    : 0);

  // Internal const-constructor that initializes all state.
  const IntegerRange._c4(this.start, this.end, this.step, this.length)
      : assert(step != 0, 'step must not be zero');

  @override
  final int start;

  @override
  final int end;

  @override
  final int step;

  @override
  final int length;

  @override
  int getUnchecked(int index) => start + step * index;

  @override
  int indexOf(Object? element, [int startIndex = 0]) {
    if (element is int) {
      if (startIndex < 0) startIndex = 0;
      if (startIndex < length) {
        final value = element - start;
        if (value % step == 0) {
          final index = value ~/ step;
          if (startIndex <= index && index < length) {
            return index;
          }
        }
      }
    }
    return -1;
  }

  @override
  IntegerRange get reversed => IntegerRange._c4(
      start + (length - 1) * step, start - step, -step, length);

  @override
  IntegerRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return IntegerRange._c4(start + startIndex * step, start + endIndex * step,
        step, endIndex - startIndex);
  }
}

extension IntegerRangeExtension on int {
  /// Shorthand to create a range of [int] numbers, starting with the receiver
  /// (inclusive) up to but not including [end] (exclusive).
  Range<int> to(int end, {int? step}) =>
      IntegerRange.of(start: this, end: end, step: step);
}

extension IndicesIterableExtension on Iterable<Object?> {
  /// Returns a [Range] of the indices of this iterable that can be accessed
  /// with the `[]` operator.
  ///
  /// An optional non-zero [step] counter can be provided to skip over
  /// indices. A negative [step] counter returns the indices in reverse
  /// order.
  ///
  /// For example, the expression
  ///
  ///     ['a', 'b', 'c'].indices(step: 2)
  ///
  /// returns
  ///
  ///     [0, 2]
  ///
  Range<int> indices({int step = 1}) => step > 0
      ? IntegerRange._c3(0, length, step)
      : step < 0
          ? IntegerRange._c3(length - 1, -1, step)
          : throw ArgumentError.value(step, 'step');
}
