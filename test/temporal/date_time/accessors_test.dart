import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('accessors', () {
    test('isLeapYear', () {
      for (var year = 1950; year <= 2050; year++) {
        final date = DateTime(year, DateTime.february, 29);
        check(date.isLeapYear).equals(date.day == 29);
      }
    });
    test('daysInYear', () {
      for (var year = 1950; year <= 2050; year++) {
        final date = DateTime(year);
        check([365, 366]).contains(date.daysInYear);
        final lastDateOfYear = DateTime(year, 1, date.daysInYear);
        check(lastDateOfYear.year).equals(year);
        final firstDateOfNextYear = DateTime(year, 1, date.daysInYear + 1);
        check(firstDateOfNextYear.year).equals(year + 1);
      }
    });
    test('daysInMonth', () {
      for (var year = 1950; year <= 2050; year++) {
        for (
          var month = DateTime.january;
          month <= DateTime.december;
          month++
        ) {
          final date = DateTime(year, month);
          check([28, 29, 30, 31]).contains(date.daysInMonth);
          final lastDateOfMonth = DateTime(year, month, date.daysInMonth);
          check(lastDateOfMonth.month).equals(month);
          final firstDateOfNextMonth = DateTime(
            year,
            month,
            date.daysInMonth + 1,
          );
          check(firstDateOfNextMonth.month).equals(1 + month % 12);
          check(firstDateOfNextMonth.day).equals(1);
        }
      }
    });
    test('weeksInYear', () {
      for (var year = 1950; year <= 2050; year++) {
        final date = DateTime(year);
        check([52, 53]).contains(date.weeksInYear);
      }
    });
    test('quarter', () {
      for (var day = 1; day <= 365; day++) {
        final date = DateTime(1980, 1, day);
        if (date.month.between(DateTime.january, DateTime.march)) {
          check(date.quarter).equals(1);
        } else if (date.month.between(DateTime.april, DateTime.june)) {
          check(date.quarter).equals(2);
        } else if (date.month.between(DateTime.july, DateTime.september)) {
          check(date.quarter).equals(3);
        } else if (date.month.between(DateTime.october, DateTime.december)) {
          check(date.quarter).equals(4);
        } else {
          throw StateError('Something is broken with the test.');
        }
      }
    });
    test('weekYear & weekNumber', () {
      check(DateTime(2014, 12, 31).weekYear).equals(2015);
      check(DateTime(2017, 5, 25).weekNumber).equals(21);
      for (var year = 1950; year <= 2050; year++) {
        for (var day = 1; ; day++) {
          final date = DateTime(year, 1, day);
          if (date.year != year) break;
          final weekYear = date.weekYear;
          final weekNumber = date.weekNumber;
          if (weekYear == year) {
            check(weekNumber).equals((date.dayOfYear - date.weekday + 10) ~/ 7);
          } else if (weekYear == year - 1) {
            check(weekNumber).equals(DateTime(year - 1).weeksInYear);
          } else if (weekYear == year + 1) {
            check(weekNumber).equals(1);
          } else {
            throw StateError('Invalid week year: $weekYear');
          }
        }
      }
    });
    test('dayOfYear', () {
      check(DateTime(2017, 5, 25).dayOfYear).equals(145);
      for (var year = 1950; year <= 2050; year++) {
        for (var day = 1; ; day++) {
          final date = DateTime(year, 1, day);
          if (date.year != year) break;
          check(date.dayOfYear).equals(day);
        }
      }
    });
    test('hour12', () {
      check(
        DateTime(1980)
            .periodical(TimeUnit.hour)
            .map((dateTime) => dateTime.hour12)
            .take(24),
      ).deepEquals([
        12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // am
        12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // pm
      ]);
    });
  });
}
