import 'package:checks/checks.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('truncate', () {
    final date = DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90);
    test('millennium', () {
      final truncated = date.truncateTo(TimeUnit.millennium);
      check(truncated).equals(DateTime(1000));
    });
    test('century', () {
      final truncated = date.truncateTo(TimeUnit.century);
      check(truncated).equals(DateTime(1900));
    });
    test('decade', () {
      final truncated = date.truncateTo(TimeUnit.decade);
      check(truncated).equals(DateTime(1980));
    });
    test('year', () {
      final truncated = date.truncateTo(TimeUnit.year);
      check(truncated).equals(DateTime(1980));
    });
    test('quarter', () {
      final truncated = date.truncateTo(TimeUnit.quarter);
      check(truncated).equals(DateTime(1980, DateTime.april));
    });
    test('month', () {
      final truncated = date.truncateTo(TimeUnit.month);
      check(truncated).equals(DateTime(1980, DateTime.june));
    });
    test('week', () {
      final truncated = date.truncateTo(TimeUnit.week);
      check(truncated).equals(DateTime(1980, DateTime.june, 9));
    });
    test('week (custom start of the week)', () {
      for (
        var weekday = DateTime.monday;
        weekday <= DateTime.sunday;
        weekday++
      ) {
        final truncated = date.truncateTo(TimeUnit.week, startWeekday: weekday);
        check(truncated.isBefore(date)).isTrue();
        check(truncated.weekday).equals(weekday);
      }
    });
    test('day', () {
      final truncated = date.truncateTo(TimeUnit.day);
      check(truncated).equals(DateTime(1980, DateTime.june, 11));
    });
    test('hour', () {
      final truncated = date.truncateTo(TimeUnit.hour);
      check(truncated).equals(DateTime(1980, DateTime.june, 11, 12));
    });
    test('minute', () {
      final truncated = date.truncateTo(TimeUnit.minute);
      check(truncated).equals(DateTime(1980, DateTime.june, 11, 12, 34));
    });
    test('second', () {
      final truncated = date.truncateTo(TimeUnit.second);
      check(truncated).equals(DateTime(1980, DateTime.june, 11, 12, 34, 56));
    });
    test('millisecond', () {
      final truncated = date.truncateTo(TimeUnit.millisecond);
      check(truncated)
          .equals(DateTime(1980, DateTime.june, 11, 12, 34, 56, 78));
    });
    test('microsecond', () {
      final truncated = date.truncateTo(TimeUnit.microsecond);
      check(truncated)
          .equals(DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90));
    });
    test('invalid start weekday', () {
      check(
        () => date.truncateTo(TimeUnit.week, startWeekday: DateTime.monday - 1),
      ).throws<ArgumentError>();
      check(
        () => date.truncateTo(TimeUnit.week, startWeekday: DateTime.sunday + 1),
      ).throws<ArgumentError>();
    });
  });
}
