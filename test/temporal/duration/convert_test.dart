import 'package:checks/checks.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('convertTo', () {
    const epsilon = 1e-6;
    test('casual', () {
      const duration = Duration(microseconds: 123456789012345);
      check(duration.convertTo(TimeUnit.microsecond))
          .isRelativeCloseTo(123456789012345.0, epsilon);
      check(duration.convertTo(TimeUnit.millisecond))
          .isRelativeCloseTo(123456789012.345, epsilon);
      check(duration.convertTo(TimeUnit.second))
          .isRelativeCloseTo(123456789.012345, epsilon);
      check(duration.convertTo(TimeUnit.minute))
          .isRelativeCloseTo(2057613.15020575, epsilon);
      check(duration.convertTo(TimeUnit.hour))
          .isRelativeCloseTo(34293.552503429164, epsilon);
      check(duration.convertTo(TimeUnit.day))
          .isRelativeCloseTo(1428.8980209762153, epsilon);
      check(duration.convertTo(TimeUnit.week))
          .isRelativeCloseTo(204.1282887108879, epsilon);
      check(duration.convertTo(TimeUnit.month))
          .isRelativeCloseTo(47.62993403254051, epsilon);
      check(duration.convertTo(TimeUnit.quarter))
          .isRelativeCloseTo(15.876644677513504, epsilon);
      check(duration.convertTo(TimeUnit.year))
          .isRelativeCloseTo(3.9147890985649734, epsilon);
      check(duration.convertTo(TimeUnit.decade))
          .isRelativeCloseTo(0.39147890985649736, epsilon);
      check(duration.convertTo(TimeUnit.century))
          .isRelativeCloseTo(0.03914789098564973, epsilon);
      check(duration.convertTo(TimeUnit.millennium))
          .isRelativeCloseTo(0.003914789098564973, epsilon);
    });
    test('accurate', () {
      const duration = Duration(microseconds: 123456789012345);
      check(
        duration.convertTo(
          TimeUnit.microsecond,
          conversion: accurateConversion,
        ),
      ).isRelativeCloseTo(123456789012345.0, epsilon);
      check(
        duration.convertTo(
          TimeUnit.millisecond,
          conversion: accurateConversion,
        ),
      ).isRelativeCloseTo(123456789012.345, epsilon);
      check(duration.convertTo(TimeUnit.second, conversion: accurateConversion))
          .isRelativeCloseTo(123456789.012345, epsilon);
      check(duration.convertTo(TimeUnit.minute, conversion: accurateConversion))
          .isRelativeCloseTo(2057613.15020575, epsilon);
      check(duration.convertTo(TimeUnit.hour, conversion: accurateConversion))
          .isRelativeCloseTo(34293.552503429164, epsilon);
      check(duration.convertTo(TimeUnit.day, conversion: accurateConversion))
          .isRelativeCloseTo(1428.8980209762153, epsilon);
      check(duration.convertTo(TimeUnit.week, conversion: accurateConversion))
          .isRelativeCloseTo(204.1282887108879, epsilon);
      check(duration.convertTo(TimeUnit.month, conversion: accurateConversion))
          .isRelativeCloseTo(46.94627884683349, epsilon);
      check(
        duration.convertTo(TimeUnit.quarter, conversion: accurateConversion),
      ).isRelativeCloseTo(15.648759615611166, epsilon);
      check(duration.convertTo(TimeUnit.year, conversion: accurateConversion))
          .isRelativeCloseTo(3.9121899039027914, epsilon);
      check(duration.convertTo(TimeUnit.decade, conversion: accurateConversion))
          .isRelativeCloseTo(0.39121899039027913, epsilon);
      check(
        duration.convertTo(TimeUnit.century, conversion: accurateConversion),
      ).isRelativeCloseTo(0.039121899039027914, epsilon);
      check(
        duration.convertTo(TimeUnit.millennium, conversion: accurateConversion),
      ).isRelativeCloseTo(0.003912189903902791, epsilon);
    });
  });
}
