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
    test('negative, zero, empty units, and missing unit', () {
      check(
        const Duration(
          hours: -25,
          microseconds: -5,
        ).convertToAll({TimeUnit.day, TimeUnit.hour}),
      ).deepEquals({
        TimeUnit.day: -1,
        TimeUnit.hour: -1,
        TimeUnit.microsecond: -5,
      });
      check(Duration.zero.convertToAll({TimeUnit.day}))
          .deepEquals({TimeUnit.day: 0, TimeUnit.microsecond: 0});
      check(const Duration(seconds: 5).convertToAll({}))
          .deepEquals({TimeUnit.microsecond: 5000000});
      check(
        () => const Duration(seconds: 1).convertToAll(
          {TimeUnit.day},
          conversion: const {TimeUnit.second: 1000000},
        ),
      ).throws<ArgumentError>();
    });
    test('large duration precision', () {
      final micros = int.parse('9007199254740993'); // 2^53 + 1
      final duration = Duration(microseconds: micros);
      final result = duration.convertToAll({TimeUnit.second});
      check(result[TimeUnit.second]).equals(micros ~/ 1000000);
      check(result[TimeUnit.microsecond]).equals(micros % 1000000);
    }, testOn: '!js');
  });
}
