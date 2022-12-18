import 'dart:collection' show ListBase;

import '../iterable/mixins/unmodifiable.dart';
import '../range.dart';

/// A virtual range of integers containing an arithmetic progressions.
///
/// The progression is defined by a `start`, `stop` and `step` parameter. A
/// range essentially implements a lazy list that is also produced by the
/// following for-loop:
///
///   for (int i = start; i < stop; i += step) {
///     ...
///
class IntegerRange extends ListBase<int>
    with Range<int>, UnmodifiableListMixin<int> {
  /// Creates a virtual range of numbers containing an arithmetic progressions
  /// of integer values.
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
  /// `IntegerRange(3, 6)` yields `<int>[3, 4, 5]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `IntegerRange(1, 7, 2)` yields `<int>[1, 3, 5]`.
  factory IntegerRange([int? a, int? b, int? c]) {
    var start = 0;
    var end = 0;
    var step = 1;
    if (c != null) {
      start = a!;
      end = b!;
      step = c;
    } else if (b != null) {
      start = a!;
      end = b;
      step = start <= end ? 1 : -1;
    } else if (a != null) {
      end = a;
    }
    if (start < end) {
      if (step == 1) {
        return IntegerRange._(start, end, step, end - start);
      } else if (step > 1) {
        return IntegerRange._(
            start, end, step, (end - start + step - 1) ~/ step);
      }
    } else if (start > end) {
      if (step == -1) {
        return IntegerRange._(start, end, step, start - end);
      } else if (step < -1) {
        return IntegerRange._(
            start, end, step, (start - end - step - 1) ~/ -step);
      }
    } else {
      if (step != 0) {
        return IntegerRange._(start, end, step, 0);
      }
    }
    throw ArgumentError.value(
        step, 'step', 'Invalid step size for range $start..$end');
  }

  IntegerRange._(this.start, this.end, this.step, this.length);

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
  IntegerRange get reversed =>
      isEmpty ? this : IntegerRange._(last, first - step, -step, length);

  @override
  IntegerRange getRange(int startIndex, int endIndex) {
    RangeError.checkValidRange(startIndex, endIndex, length);
    return IntegerRange._(start + startIndex * step, start + endIndex * step,
        step, endIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'IntegerRange()';
    } else if (start == 0 && step == 1) {
      return 'IntegerRange($end)';
    } else if (step == 1) {
      return 'IntegerRange($start, $end)';
    } else {
      return 'IntegerRange($start, $end, $step)';
    }
  }
}

extension IntegerRangeExtension on int {
  /// Shorthand to create a range of [int] numbers, starting with the receiver
  /// (inclusive) up to but not including [end] (exclusive).
  Range<int> to(int end, {int? step}) => IntegerRange(this, end, step);
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
  Range<int> indices({int step = 1}) {
    final count = length;
    if (step == 1) {
      return IntegerRange._(0, count, 1, count);
    } else if (step == -1) {
      return IntegerRange._(count - 1, -1, -1, count);
    } else if (step > 1) {
      return IntegerRange._(0, count, step, (count + 1) ~/ step);
    } else if (step < -1) {
      return IntegerRange._(count - 1, -1, step, (count + 1) ~/ -step);
    } else {
      throw ArgumentError.value(step, 'step', 'Non-zero step-size expected');
    }
  }
}
