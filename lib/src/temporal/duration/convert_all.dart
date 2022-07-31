import '../conversion.dart';
import '../time_unit.dart';

extension ConverToAllDurationExtension on Duration {
  /// Converts the [Duration] into a numeric representation of different units.
  ///
  /// The result is a [Map] of all selected [TimeUnits] `units`. The smallest
  /// unit [TimeUnit.microsecond] is always included to contain the remainder.
  Map<TimeUnit, int> convertToAll(
    Set<TimeUnit> units, {
    Map<TimeUnit, num> conversion = casualConversion,
  }) {
    final result = <TimeUnit, int>{};
    var remainder = inMicroseconds.abs().toDouble();
    for (final unit in TimeUnit.values.reversed) {
      if (TimeUnit.microsecond == unit) {
        result[TimeUnit.microsecond] = remainder.truncate();
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
