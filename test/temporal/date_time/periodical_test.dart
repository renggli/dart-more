import 'package:checks/checks.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('periodical', () {
    final date = DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90);
    test('millennium', () {
      final iterable = date.periodical(TimeUnit.millennium);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(2980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(3980, DateTime.june, 11, 12, 34, 56, 78, 90),
      ]);
    });
    test('century', () {
      final iterable = date.periodical(TimeUnit.century);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(2080, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(2180, DateTime.june, 11, 12, 34, 56, 78, 90),
      ]);
    });
    test('decade', () {
      final iterable = date.periodical(TimeUnit.decade);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1990, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(2000, DateTime.june, 11, 12, 34, 56, 78, 90),
      ]);
    });
    test('year', () {
      final iterable = date.periodical(TimeUnit.year);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1981, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1982, DateTime.june, 11, 12, 34, 56, 78, 90),
      ]);
    });
    test('quarter', () {
      final iterable = date.periodical(TimeUnit.quarter);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.september, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.december, 11, 12, 34, 56, 78, 90),
      ]);
    });
    test('month', () {
      final iterable = date.periodical(TimeUnit.month);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.july, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.august, 11, 12, 34, 56, 78, 90),
      ]);
    });
    test('week', () {
      final iterable = date.periodical(TimeUnit.week);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 18, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 25, 12, 34, 56, 78, 90),
      ]);
    });
    test('day', () {
      final iterable = date.periodical(TimeUnit.day);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 12, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 13, 12, 34, 56, 78, 90),
      ]);
    });
    test('hour', () {
      final iterable = date.periodical(TimeUnit.hour);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 13, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 14, 34, 56, 78, 90),
      ]);
    });
    test('minute', () {
      final iterable = date.periodical(TimeUnit.minute);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 12, 35, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 12, 36, 56, 78, 90),
      ]);
    });
    test('second', () {
      final iterable = date.periodical(TimeUnit.second);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 12, 34, 57, 78, 90),
        DateTime(1980, DateTime.june, 11, 12, 34, 58, 78, 90),
      ]);
    });
    test('millisecond', () {
      final iterable = date.periodical(TimeUnit.millisecond);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 79, 90),
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 80, 90),
      ]);
    });
    test('microsecond', () {
      final iterable = date.periodical(TimeUnit.microsecond);
      check(iterable.take(3)).deepEquals([
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 91),
        DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 92),
      ]);
    });
    test('invalid step', () {
      check(() => date.periodical(TimeUnit.day, step: 0))
          .throws<ArgumentError>();
    });
  });
}
