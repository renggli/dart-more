import '../../interval/interval.dart';

extension DurationIntervalDateTimeExtension on Interval<DateTime> {
  /// Converts an [Interval] of [DateTime] objects into a [Duration].
  ///
  /// Returns [Duration.zero] if the interval is empty. Throws an
  /// [ArgumentError] if one of the bounds is unbound (infinite).
  Duration toDuration() {
    if (isEmpty) {
      return Duration.zero;
    } else if (lower.isUnbounded || upper.isUnbounded) {
      throw ArgumentError.value(this, 'interval', 'Interval is unbounded');
    } else {
      return Duration(
          milliseconds: upper.endpoint.millisecondsSinceEpoch -
              lower.endpoint.millisecondsSinceEpoch);
    }
  }
}
