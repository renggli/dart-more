import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('conversion', () {
    void verify(String name, Map<TimeUnit, num> conversion) {
      group(name, () {
        test('all units', () {
          final units = conversion.keys;
          check(units).unorderedEquals(TimeUnit.values);
        });
        test('monotonic increase', () {
          final values = TimeUnit.values.map((unit) => conversion[unit]!);
          check(naturalComparable<num>.isStrictlyOrdered(values)).isTrue();
        });
        test('known values', () {
          const epsilon = 0.1;
          check(conversion[TimeUnit.microsecond]!)
              .isRelativeCloseTo(1e0, epsilon);
          check(conversion[TimeUnit.millisecond]!)
              .isRelativeCloseTo(1e3, epsilon);
          check(conversion[TimeUnit.second]!).isRelativeCloseTo(1e6, epsilon);
          check(conversion[TimeUnit.minute]!)
              .isRelativeCloseTo(60 * 1e6, epsilon);
          check(conversion[TimeUnit.hour]!)
              .isRelativeCloseTo(60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.day]!)
              .isRelativeCloseTo(24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.week]!)
              .isRelativeCloseTo(7 * 24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.month]!)
              .isRelativeCloseTo(30 * 24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.quarter]!)
              .isRelativeCloseTo(3 * 30 * 24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.year]!)
              .isRelativeCloseTo(365 * 24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.decade]!)
              .isRelativeCloseTo(3650 * 24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.century]!)
              .isRelativeCloseTo(36500 * 24 * 60 * 60 * 1e6, epsilon);
          check(conversion[TimeUnit.millennium]!)
              .isRelativeCloseTo(365000 * 24 * 60 * 60 * 1e6, epsilon);
        });
      });
    }

    verify('casual', casualConversion);
    verify('accurate', accurateConversion);
  });
}
