import '../conversion.dart';
import '../time_unit.dart';

extension ConvertToAllDurationExtension on Duration {
  /// Converts this [Duration] into one or more [int] representations over the
  /// provided [TimeUnit] `units`.
  ///
  /// The result is a [Map] with the selected [TimeUnit] `units` as the key,
  /// including [TimeUnit.microsecond] with the remainder of the conversion.
  ///
  /// If this [Duration] is negative the resulting values are all negative too.
  ///
  /// By default a [casualConversion] is used, to get more accurate results
  /// use [accurateConversion] instead.
  Map<TimeUnit, int> convertToAll(
    Set<TimeUnit> units, {
    UnitConversion conversion = casualConversion,
  }) {
    final result = <TimeUnit, int>{};
    final smallest = TimeUnit.values.first;
    var remainder = inMicroseconds.toDouble();
    for (final unit in TimeUnit.values.reversed) {
      if (smallest == unit) {
        result[smallest] = remainder.truncate();
      } else if (units.contains(unit)) {
        final micros = conversion[unit]!;
        final value = (remainder / micros).truncate();
        remainder -= value * micros;
        result[unit] = value;
      }
    }
    return result;
  }
}
