import '../conversion.dart';
import '../time_unit.dart';

extension ConvertToDurationExtension on Duration {
  /// Converts the duration into a fractional [unit].
  double convertTo(
    TimeUnit unit, {
    Map<TimeUnit, num> conversion = casualConversion,
  }) =>
      inMicroseconds / conversion[unit]!;
}
