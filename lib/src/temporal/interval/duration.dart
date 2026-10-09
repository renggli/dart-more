import '../../../interval.dart';

/// Extension on [Interval] of [DateTime] providing duration conversion.
extension DurationIntervalDateTimeExtension on Interval<DateTime> {
  /// Converts an [Interval] of [DateTime] objects into a [Duration].
  Duration toDuration() => Duration(
    milliseconds: upper.millisecondsSinceEpoch - lower.millisecondsSinceEpoch,
  );
}
