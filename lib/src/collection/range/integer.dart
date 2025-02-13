import '../range.dart';

/// A range of integers containing an arithmetic progressions.
///
/// The progression is defined by a [IntegerRange.start], [IntegerRange.end]
/// and [IntegerRange.step] parameters. A range essentially implements a lazy
/// list that is also produced by the following for-loop:
///
/// ```dart
/// for (int i = start; i < end; i += step) {
///    // ...
/// }
/// ```
final class IntegerRange extends Range<int> {
  /// The empty range.
  static const empty = IntegerRange._(0, 0, 1, 0);

  /// Creates an arithmetic progressions of [int] values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `IntegerRange()` yields `<int>[]`.
  ///
  /// The constructor called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example, `IntegerRange(3)`
  /// yields `<int>[0, 1, 2]`.
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
      return empty;
    }
    throw ArgumentError('Invalid range: $a, $b, $c');
  }

  /// Const constructor to create an arithmetic progressions of [int] values
  /// between [start] (inclusive) and [end] (exclusive); and a step-value
  /// [step].
  const IntegerRange.of({int start = 0, int end = 0, int? step})
      : this._of1(start, end, step ?? (start <= end ? 1 : -1));

  const IntegerRange._of1(int start, int end, int step)
      : this._(
            start,
            end,
            step,
            0 < step && start < end
                ? 1 + (end - start - 1) ~/ step
                : 0 > step && start > end
                    ? 1 + (start - end - 1) ~/ -step
                    : 0);

  /// Const constructor to create an arithmetic progression of [int] values.
  /// The resulting [Range] is of the given [length], starts at [start], and
  /// uses the step-value [step].
  const IntegerRange.length(int length, {int start = 0, int step = 1})
      : this._(start, start + length * step, step, length);

  // Internal const-constructor that initializes the state.
  const IntegerRange._(this.start, this.end, this.step, this.length)
      : assert(step != 0, '`step` must not be zero'),
        assert(step < 0 || start <= end, '`step` must be positive'),
        assert(step > 0 || start >= end, '`step` must be negative'),
        assert(0 <= length, '`length` must be positive');

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
  // ignore: avoid_renaming_method_parameters
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
  IntegerRange get reversed =>
      IntegerRange._(start + (length - 1) * step, start - step, -step, length);

  @override
  // ignore: avoid_renaming_method_parameters
  IntegerRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return IntegerRange._(start + startIndex * step, start + endIndex * step,
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
  /// For example:
  ///
  /// ```dart
  /// final input = ['a', 'b', 'c'];
  /// print(input.indices(step: 2));  // [0, 2]
  /// ```
  Range<int> indices({int step = 1}) => step > 0
      ? IntegerRange.of(start: 0, end: length, step: step)
      : IntegerRange.of(start: length - 1, end: -1, step: step);
}
