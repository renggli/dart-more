import '../conversion.dart';
import '../time_unit.dart';

extension ConvertToDurationExtension on Duration {
  /// Converts the [Duration] into a [double] representation of the provided
  /// [TimeUnit] [unit]. The resulting duration has the same sign as this
  /// duration.
  ///
  /// If you are not interested in the fractional part use the preferred
  /// rounding ([double.round], [double.floor], [double.ceil],
  /// [double.truncate]) to convert the result to an [int].
  ///
  /// By default a [casualConversion] is used, to get more accurate results
  /// use [accurateConversion] instead.
  double convertTo(
    TimeUnit unit, {
    UnitConversion conversion = casualConversion,
  }) => inMicroseconds / conversion[unit]!;
}
