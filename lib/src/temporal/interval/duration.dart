import '../../../interval.dart';

extension DurationIntervalDateTimeExtension on Interval<DateTime> {
  /// Converts an [Interval] of [DateTime] objects into a [Duration].
  Duration toDuration() => Duration(
      milliseconds:
          upper.millisecondsSinceEpoch - lower.millisecondsSinceEpoch);
}
