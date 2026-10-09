import 'package:checks/checks.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('convertToAll', () {
    test('casual', () {
      const duration = Duration(days: 140);
      check(duration.convertToAll({TimeUnit.day}))
          .deepEquals({TimeUnit.day: 140, TimeUnit.microsecond: 0});
      check(duration.convertToAll({TimeUnit.week, TimeUnit.hour})).deepEquals({
        TimeUnit.week: 20,
        TimeUnit.hour: 0,
        TimeUnit.microsecond: 0,
      });
      check(duration.convertToAll({TimeUnit.month, TimeUnit.hour})).deepEquals({
        TimeUnit.month: 4,
        TimeUnit.hour: 480,
        TimeUnit.microsecond: 0,
      });
      check(duration.convertToAll({TimeUnit.year, TimeUnit.day})).deepEquals({
        TimeUnit.year: 0,
        TimeUnit.day: 140,
        TimeUnit.microsecond: 0,
      });
      check(
        duration.convertToAll({
          TimeUnit.quarter,
          TimeUnit.month,
          TimeUnit.week,
          TimeUnit.day,
        }),
      ).deepEquals({
        TimeUnit.quarter: 1,
        TimeUnit.month: 1,
        TimeUnit.week: 2,
        TimeUnit.day: 6,
        TimeUnit.microsecond: 0,
      });
    });
    test('accurate', () {
      const duration = Duration(days: 140);
      check(
        duration.convertToAll({TimeUnit.day}, conversion: accurateConversion),
      ).deepEquals({TimeUnit.day: 140, TimeUnit.microsecond: 0});
      check(
        duration.convertToAll({
          TimeUnit.week,
          TimeUnit.hour,
        }, conversion: accurateConversion),
      ).deepEquals({
        TimeUnit.week: 20,
        TimeUnit.hour: 0,
        TimeUnit.microsecond: 0,
      });
      check(
        duration.convertToAll({
          TimeUnit.month,
          TimeUnit.hour,
        }, conversion: accurateConversion),
      ).deepEquals({
        TimeUnit.month: 4,
        TimeUnit.hour: 438,
        TimeUnit.microsecond: 216000000,
      });
      check(
        duration.convertToAll({
          TimeUnit.year,
          TimeUnit.day,
        }, conversion: accurateConversion),
      ).deepEquals({
        TimeUnit.year: 0,
        TimeUnit.day: 140,
        TimeUnit.microsecond: 0,
      });
      check(
        duration.convertToAll({
          TimeUnit.quarter,
          TimeUnit.month,
          TimeUnit.week,
          TimeUnit.day,
        }, conversion: accurateConversion),
      ).deepEquals({
        TimeUnit.quarter: 1,
        TimeUnit.month: 1,
        TimeUnit.week: 2,
        TimeUnit.day: 4,
        TimeUnit.microsecond: 21816000000,
      });
    });
  });
}
