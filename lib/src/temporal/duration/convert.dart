import '../conversion.dart';
import '../time_unit.dart';

extension ConvertToDurationExtension on Duration {
  /// Converts the [Duration] into a single [double] representations of the
  /// provided [TimeUnit] `unit`.
  ///
  /// The resulting duration has the same sign as this duration.
  ///
  /// By default a [casualConversion] is used, to get more accurate results
  /// use [accurateConversion] instead.
  double convertTo(
    TimeUnit unit, {
    UnitConversion conversion = casualConversion,
  }) =>
      inMicroseconds / conversion[unit]!;
}
