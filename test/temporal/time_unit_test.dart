import 'package:checks/checks.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('time_unit', () {
    test('values ordering', () {
      check(TimeUnit.values).deepEquals([
        TimeUnit.microsecond,
        TimeUnit.millisecond,
        TimeUnit.second,
        TimeUnit.minute,
        TimeUnit.hour,
        TimeUnit.day,
        TimeUnit.week,
        TimeUnit.month,
        TimeUnit.quarter,
        TimeUnit.year,
        TimeUnit.decade,
        TimeUnit.century,
        TimeUnit.millennium,
      ]);
    });
    test('count', () {
      check(TimeUnit.values).length.equals(13);
    });
    test('names', () {
      check(TimeUnit.microsecond.name).equals('microsecond');
      check(TimeUnit.millennium.name).equals('millennium');
    });
  });
}
