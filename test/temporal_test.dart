import 'package:more/comparator.dart';
import 'package:more/interval.dart';
import 'package:more/math.dart';
import 'package:more/src/temporal/conversion.dart';
import 'package:more/temporal.dart';
import 'package:test/test.dart';

Matcher relativeCloseTo(num expected, num epsilon) => wrapMatcher((num actual) {
      final difference = (expected - actual).abs();
      final relative = difference > 0 ? difference / actual : 0;
      return relative <= epsilon;
    });

void main() {
  group('date & time', () {
    group('accessors', () {
      test('isLeapYear', () {
        for (var year = 1950; year <= 2050; year++) {
          final date = DateTime(year, DateTime.february, 29);
          expect(date.isLeapYear, date.day == 29);
        }
      });
      test('daysInYear', () {
        for (var year = 1950; year <= 2050; year++) {
          final date = DateTime(year);
          expect(date.daysInYear, anyOf(365, 366));
          final lastDateOfYear = DateTime(year, 1, date.daysInYear);
          expect(lastDateOfYear.year, year);
          final firstDateOfNextYear = DateTime(year, 1, date.daysInYear + 1);
          expect(firstDateOfNextYear.year, year + 1);
        }
      });
      test('daysInMonth', () {
        for (var year = 1950; year <= 2050; year++) {
          for (var month = DateTime.january;
              month <= DateTime.december;
              month++) {
            final date = DateTime(year, month);
            expect(date.daysInMonth, anyOf(28, 29, 30, 31));
            final lastDateOfMonth = DateTime(year, month, date.daysInMonth);
            expect(lastDateOfMonth.month, month);
            final firstDateOfNextMonth =
                DateTime(year, month, date.daysInMonth + 1);
            expect(firstDateOfNextMonth.month, 1 + month % 12);
            expect(firstDateOfNextMonth.day, 1);
          }
        }
      });
      test('weeksInYear', () {
        for (var year = 1950; year <= 2050; year++) {
          final date = DateTime(year);
          expect(date.weeksInYear, anyOf(52, 53));
        }
      });
      test('quarter', () {
        for (var day = 1; day <= 365; day++) {
          final date = DateTime(1980, 1, day);
          if (date.month.between(DateTime.january, DateTime.march)) {
            expect(date.quarter, 1);
          } else if (date.month.between(DateTime.april, DateTime.june)) {
            expect(date.quarter, 2);
          } else if (date.month.between(DateTime.july, DateTime.september)) {
            expect(date.quarter, 3);
          } else if (date.month.between(DateTime.october, DateTime.december)) {
            expect(date.quarter, 4);
          } else {
            throw StateError('Something is broken with the test.');
          }
        }
      });
      test('weekYear & weekNumber', () {
        expect(DateTime(2014, 12, 31).weekYear, 2015);
        expect(DateTime(2017, 5, 25).weekNumber, 21);
        for (var year = 1950; year <= 2050; year++) {
          for (var day = 1;; day++) {
            final date = DateTime(year, 1, day);
            if (date.year != year) break;
            final weekYear = date.weekYear;
            final weekNumber = date.weekNumber;
            if (weekYear == year) {
              expect(weekNumber, (date.dayOfYear - date.weekday + 10) ~/ 7);
            } else if (weekYear == year - 1) {
              expect(weekNumber, DateTime(year - 1).weeksInYear);
            } else if (weekYear == year + 1) {
              expect(weekNumber, 1);
            } else {
              throw StateError('Invalid week year: $weekYear');
            }
          }
        }
      });
      test('dayOfYear', () {
        expect(DateTime(2017, 5, 25).dayOfYear, 145);
        for (var year = 1950; year <= 2050; year++) {
          for (var day = 1;; day++) {
            final date = DateTime(year, 1, day);
            if (date.year != year) break;
            expect(date.dayOfYear, day);
          }
        }
      });
      test('hour12', () {
        expect(
            DateTime(1980)
                .periodical(TimeUnit.hour)
                .map((dateTime) => dateTime.hour12)
                .take(24),
            [
              12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // am
              12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // pm
            ]);
      });
    });
    group('periodical', () {
      final date = DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90);
      test('millennium', () {
        final iterable = date.periodical(TimeUnit.millennium);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(3980, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('century', () {
        final iterable = date.periodical(TimeUnit.century);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2080, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2180, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('decade', () {
        final iterable = date.periodical(TimeUnit.decade);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1990, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2000, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('year', () {
        final iterable = date.periodical(TimeUnit.year);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1981, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1982, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('quarter', () {
        final iterable = date.periodical(TimeUnit.quarter);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.september, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.december, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('month', () {
        final iterable = date.periodical(TimeUnit.month);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.july, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.august, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('week', () {
        final iterable = date.periodical(TimeUnit.week);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 18, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 25, 12, 34, 56, 78, 90),
        ]);
      });
      test('day', () {
        final iterable = date.periodical(TimeUnit.day);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 12, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 13, 12, 34, 56, 78, 90),
        ]);
      });
      test('hour', () {
        final iterable = date.periodical(TimeUnit.hour);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 13, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 14, 34, 56, 78, 90),
        ]);
      });
      test('minute', () {
        final iterable = date.periodical(TimeUnit.minute);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 35, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 36, 56, 78, 90),
        ]);
      });
      test('second', () {
        final iterable = date.periodical(TimeUnit.second);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 57, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 58, 78, 90),
        ]);
      });
      test('millisecond', () {
        final iterable = date.periodical(TimeUnit.millisecond);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 79, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 80, 90),
        ]);
      });
      test('microsecond', () {
        final iterable = date.periodical(TimeUnit.microsecond);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 91),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 92),
        ]);
      });
      test('invalid step', () {
        expect(
            () => date.periodical(TimeUnit.day, step: 0), throwsArgumentError);
      });
    });
    group('truncate', () {
      final date = DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90);
      test('millennium', () {
        final truncated = date.truncateTo(TimeUnit.millennium);
        expect(truncated, DateTime(1000));
      });
      test('century', () {
        final truncated = date.truncateTo(TimeUnit.century);
        expect(truncated, DateTime(1900));
      });
      test('decade', () {
        final truncated = date.truncateTo(TimeUnit.decade);
        expect(truncated, DateTime(1980));
      });
      test('year', () {
        final truncated = date.truncateTo(TimeUnit.year);
        expect(truncated, DateTime(1980));
      });
      test('quarter', () {
        final truncated = date.truncateTo(TimeUnit.quarter);
        expect(truncated, DateTime(1980, DateTime.april));
      });
      test('month', () {
        final truncated = date.truncateTo(TimeUnit.month);
        expect(truncated, DateTime(1980, DateTime.june));
      });
      test('week', () {
        final truncated = date.truncateTo(TimeUnit.week);
        expect(truncated, DateTime(1980, DateTime.june, 9));
      });
      test('week (custom start of the week)', () {
        for (var weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++) {
          final truncated =
              date.truncateTo(TimeUnit.week, startWeekday: weekday);
          expect(truncated.isBefore(date), isTrue);
          expect(truncated.weekday, weekday);
        }
      });
      test('day', () {
        final truncated = date.truncateTo(TimeUnit.day);
        expect(truncated, DateTime(1980, DateTime.june, 11));
      });
      test('hour', () {
        final truncated = date.truncateTo(TimeUnit.hour);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12));
      });
      test('minute', () {
        final truncated = date.truncateTo(TimeUnit.minute);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34));
      });
      test('second', () {
        final truncated = date.truncateTo(TimeUnit.second);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56));
      });
      test('millisecond', () {
        final truncated = date.truncateTo(TimeUnit.millisecond);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78));
      });
      test('microsecond', () {
        final truncated = date.truncateTo(TimeUnit.microsecond);
        expect(
            truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90));
      });
      test('invalid start weekday', () {
        expect(
            () => date.truncateTo(TimeUnit.week,
                startWeekday: DateTime.monday - 1),
            throwsArgumentError);
        expect(
            () => date.truncateTo(TimeUnit.week,
                startWeekday: DateTime.sunday + 1),
            throwsArgumentError);
      });
    });
  });
  group('duration', () {
    void verify(String name, Map<TimeUnit, num> conversion) {
      group(name, () {
        test('all units', () {
          final units = conversion.keys;
          expect(units, unorderedEquals(TimeUnit.values));
        });
        test('monotonic increase', () {
          final values = TimeUnit.values.map((unit) => conversion[unit]!);
          expect(naturalComparable<num>.isStrictlyOrdered(values), isTrue);
        });
        test('known values', () {
          const epsilon = 0.1;
          expect(
            conversion[TimeUnit.microsecond],
            relativeCloseTo(1e0, epsilon),
          );
          expect(
            conversion[TimeUnit.millisecond],
            relativeCloseTo(1e3, epsilon),
          );
          expect(
            conversion[TimeUnit.second],
            relativeCloseTo(1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.minute],
            relativeCloseTo(60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.hour],
            relativeCloseTo(60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.day],
            relativeCloseTo(24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.week],
            relativeCloseTo(7 * 24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.month],
            relativeCloseTo(30 * 24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.quarter],
            relativeCloseTo(3 * 30 * 24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.year],
            relativeCloseTo(365 * 24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.decade],
            relativeCloseTo(3650 * 24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.century],
            relativeCloseTo(36500 * 24 * 60 * 60 * 1e6, epsilon),
          );
          expect(
            conversion[TimeUnit.millennium],
            relativeCloseTo(365000 * 24 * 60 * 60 * 1e6, epsilon),
          );
        });
      });
    }

    verify('casual', casualConversion);
    verify('accurate', accurateConversion);
  });
  group('convert', () {
    const epsilon = 1e-6;
    test('convertTo', () {
      const duration = Duration(microseconds: 123456789012345);
      expect(duration.convertTo(TimeUnit.microsecond),
          relativeCloseTo(123456789012345.0, epsilon));
      expect(duration.convertTo(TimeUnit.millisecond),
          relativeCloseTo(123456789012.345, epsilon));
      expect(duration.convertTo(TimeUnit.second),
          relativeCloseTo(123456789.012345, epsilon));
      expect(duration.convertTo(TimeUnit.minute),
          relativeCloseTo(2057613.15020575, epsilon));
      expect(duration.convertTo(TimeUnit.hour),
          relativeCloseTo(34293.552503429164, epsilon));
      expect(duration.convertTo(TimeUnit.day),
          relativeCloseTo(1428.8980209762153, epsilon));
      expect(duration.convertTo(TimeUnit.week),
          relativeCloseTo(204.1282887108879, epsilon));
      expect(duration.convertTo(TimeUnit.month),
          relativeCloseTo(47.62993403254051, epsilon));
      expect(duration.convertTo(TimeUnit.quarter),
          relativeCloseTo(15.876644677513504, epsilon));
      expect(duration.convertTo(TimeUnit.year),
          relativeCloseTo(3.9147890985649734, epsilon));
      expect(duration.convertTo(TimeUnit.decade),
          relativeCloseTo(0.39147890985649736, epsilon));
      expect(duration.convertTo(TimeUnit.century),
          relativeCloseTo(0.03914789098564973, epsilon));
      expect(duration.convertTo(TimeUnit.millennium),
          relativeCloseTo(0.003914789098564973, epsilon));
    });
    test('convertTo (accurate)', () {
      const duration = Duration(microseconds: 123456789012345);
      expect(
          duration.convertTo(TimeUnit.microsecond,
              conversion: accurateConversion),
          relativeCloseTo(123456789012345.0, epsilon));
      expect(
          duration.convertTo(TimeUnit.millisecond,
              conversion: accurateConversion),
          relativeCloseTo(123456789012.345, epsilon));
      expect(
          duration.convertTo(TimeUnit.second, conversion: accurateConversion),
          relativeCloseTo(123456789.012345, epsilon));
      expect(
          duration.convertTo(TimeUnit.minute, conversion: accurateConversion),
          relativeCloseTo(2057613.15020575, epsilon));
      expect(duration.convertTo(TimeUnit.hour, conversion: accurateConversion),
          relativeCloseTo(34293.552503429164, epsilon));
      expect(duration.convertTo(TimeUnit.day, conversion: accurateConversion),
          relativeCloseTo(1428.8980209762153, epsilon));
      expect(duration.convertTo(TimeUnit.week, conversion: accurateConversion),
          relativeCloseTo(204.1282887108879, epsilon));
      expect(duration.convertTo(TimeUnit.month, conversion: accurateConversion),
          relativeCloseTo(46.94627884683349, epsilon));
      expect(
          duration.convertTo(TimeUnit.quarter, conversion: accurateConversion),
          relativeCloseTo(15.648759615611166, epsilon));
      expect(duration.convertTo(TimeUnit.year, conversion: accurateConversion),
          relativeCloseTo(3.9121899039027914, epsilon));
      expect(
          duration.convertTo(TimeUnit.decade, conversion: accurateConversion),
          relativeCloseTo(0.39121899039027913, epsilon));
      expect(
          duration.convertTo(TimeUnit.century, conversion: accurateConversion),
          relativeCloseTo(0.039121899039027914, epsilon));
      expect(
          duration.convertTo(TimeUnit.millennium,
              conversion: accurateConversion),
          relativeCloseTo(0.003912189903902791, epsilon));
    });
    test('convertToAll', () {
      const duration = Duration(days: 140);
      expect(duration.convertToAll({TimeUnit.day}),
          {TimeUnit.day: 140, TimeUnit.microsecond: 0});
      expect(duration.convertToAll({TimeUnit.week, TimeUnit.hour}),
          {TimeUnit.week: 20, TimeUnit.hour: 0, TimeUnit.microsecond: 0});
      expect(duration.convertToAll({TimeUnit.month, TimeUnit.hour}),
          {TimeUnit.month: 4, TimeUnit.hour: 480, TimeUnit.microsecond: 0});
      expect(duration.convertToAll({TimeUnit.year, TimeUnit.day}),
          {TimeUnit.year: 0, TimeUnit.day: 140, TimeUnit.microsecond: 0});
      expect(
          duration.convertToAll({
            TimeUnit.quarter,
            TimeUnit.month,
            TimeUnit.week,
            TimeUnit.day,
          }),
          {
            TimeUnit.quarter: 1,
            TimeUnit.month: 1,
            TimeUnit.week: 2,
            TimeUnit.day: 6,
            TimeUnit.microsecond: 0,
          });
    });
    test('convertToAll (accurate)', () {
      const duration = Duration(days: 140);
      expect(
          duration.convertToAll({TimeUnit.day}, conversion: accurateConversion),
          {TimeUnit.day: 140, TimeUnit.microsecond: 0});
      expect(
          duration.convertToAll({TimeUnit.week, TimeUnit.hour},
              conversion: accurateConversion),
          {TimeUnit.week: 20, TimeUnit.hour: 0, TimeUnit.microsecond: 0});
      expect(
          duration.convertToAll({TimeUnit.month, TimeUnit.hour},
              conversion: accurateConversion),
          {
            TimeUnit.month: 4,
            TimeUnit.hour: 438,
            TimeUnit.microsecond: 216000000
          });
      expect(
          duration.convertToAll({TimeUnit.year, TimeUnit.day},
              conversion: accurateConversion),
          {TimeUnit.year: 0, TimeUnit.day: 140, TimeUnit.microsecond: 0});
      expect(
          duration.convertToAll(
              {TimeUnit.quarter, TimeUnit.month, TimeUnit.week, TimeUnit.day},
              conversion: accurateConversion),
          {
            TimeUnit.quarter: 1,
            TimeUnit.month: 1,
            TimeUnit.week: 2,
            TimeUnit.day: 4,
            TimeUnit.microsecond: 21816000000
          });
    });
  });
  group('interval', () {
    group('toDuration', () {
      test('empty', () {
        final interval = Interval<DateTime>.empty();
        final duration = interval.toDuration();
        expect(duration, Duration.zero);
      });
      test('single', () {
        final interval = Interval<DateTime>.single(DateTime(1980, 6, 11));
        final duration = interval.toDuration();
        expect(duration, Duration.zero);
      });
      test('unbounded', () {
        final interval = Interval<DateTime>.all();
        expect(() => interval.toDuration(), throwsStateError);
      });
      test('normal', () {
        final interval = Interval<DateTime>.openClosed(
            DateTime(2022, 7, 30), DateTime(2022, 7, 31));
        expect(interval.toDuration().inHours, 24);
      });
    });
  });
}
