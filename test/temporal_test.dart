import 'package:more/math.dart';
import 'package:more/temporal.dart';
import 'package:test/test.dart';

void main() {
  group('date & time', () {
    final date = DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90);
    group('accessors', () {
      test('quarter', () {
        final iterable = DateTime(1980).periodical(TimeUnit.day).take(365);
        for (final dateTime in iterable) {
          final month = dateTime.month;
          if (month.between(DateTime.january, DateTime.march)) {
            expect(dateTime.quarter, 1);
          } else if (month.between(DateTime.april, DateTime.june)) {
            expect(dateTime.quarter, 2);
          } else if (month.between(DateTime.july, DateTime.september)) {
            expect(dateTime.quarter, 3);
          } else if (month.between(DateTime.october, DateTime.december)) {
            expect(dateTime.quarter, 4);
          } else {
            throw StateError('Something is broken with the test.');
          }
        }
      });
      test('dayOfYear', () {
        final iterable = DateTime(1980).periodical(TimeUnit.day).iterator;
        for (var i = 1; i <= 366; i++) {
          iterable.moveNext();
          expect(iterable.current.dayOfYear, i);
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
      test('millennium', () {
        final truncated = date.truncate(TimeUnit.millennium);
        expect(truncated, DateTime(1000));
      });
      test('century', () {
        final truncated = date.truncate(TimeUnit.century);
        expect(truncated, DateTime(1900));
      });
      test('decade', () {
        final truncated = date.truncate(TimeUnit.decade);
        expect(truncated, DateTime(1980));
      });
      test('year', () {
        final truncated = date.truncate(TimeUnit.year);
        expect(truncated, DateTime(1980));
      });
      test('quarter', () {
        final truncated = date.truncate(TimeUnit.quarter);
        expect(truncated, DateTime(1980, DateTime.april));
      });
      test('month', () {
        final truncated = date.truncate(TimeUnit.month);
        expect(truncated, DateTime(1980, DateTime.june));
      });
      test('week', () {
        final truncated = date.truncate(TimeUnit.week);
        expect(truncated, DateTime(1980, DateTime.june, 9));
      });
      test('week (custom start of the week)', () {
        for (var weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++) {
          final truncated = date.truncate(TimeUnit.week, startWeekday: weekday);
          expect(truncated.isBefore(date), isTrue);
          expect(truncated.weekday, weekday);
        }
      });
      test('day', () {
        final truncated = date.truncate(TimeUnit.day);
        expect(truncated, DateTime(1980, DateTime.june, 11));
      });
      test('hour', () {
        final truncated = date.truncate(TimeUnit.hour);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12));
      });
      test('minute', () {
        final truncated = date.truncate(TimeUnit.minute);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34));
      });
      test('second', () {
        final truncated = date.truncate(TimeUnit.second);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56));
      });
      test('millisecond', () {
        final truncated = date.truncate(TimeUnit.millisecond);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78));
      });
      test('microsecond', () {
        final truncated = date.truncate(TimeUnit.microsecond);
        expect(
            truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90));
      });
      test('invalid start weekday', () {
        expect(
            () =>
                date.truncate(TimeUnit.week, startWeekday: DateTime.monday - 1),
            throwsArgumentError);
        expect(
            () =>
                date.truncate(TimeUnit.week, startWeekday: DateTime.sunday + 1),
            throwsArgumentError);
      });
    });
  });
}
