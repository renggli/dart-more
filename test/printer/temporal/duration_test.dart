import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('duration', () {
    const durations = [
      Duration.zero,
      Duration(days: 12345),
      Duration(seconds: 123456789),
      Duration(milliseconds: 123456789),
      Duration(hours: 1, minutes: 10, microseconds: 500),
      Duration(days: 1, hours: 1, minutes: 33, microseconds: 500),
      Duration(days: -2, hours: -3, minutes: -4),
    ];
    test('dart', () {
      final printer = DurationPrinter.dart();
      check(durations.map(printer.print))
          .deepEquals(durations.map((duration) => duration.toString()));
    });
    test('iso8691', () {
      final printer = DurationPrinter.iso8601();
      check(durations.map(printer.print)).deepEquals([
        'P0DT0S',
        'P33Y10M0DT0S',
        'P3Y11M3DT21H33M9S',
        'P1DT10H17M36.789000S',
        'P0DT1H10M0.000500S',
        'P1DT1H33M0.000500S',
        'P-2DT3H4M0S',
      ]);
    });
    group('sign', () {
      test('default', () {
        final printer = DurationPrinter((builder) => builder.sign());
        check(durations.map(printer.print))
            .deepEquals(['', '', '', '', '', '', '-']);
      });
      test('custom', () {
        final printer = DurationPrinter(
          (builder) =>
              builder.sign(const SignNumberPrinter.negativeAndPositiveSign()),
        );
        check(durations.map(printer.print))
            .deepEquals(['+', '+', '+', '+', '+', '+', '-']);
      });
    });
    group('part', () {
      test('default', () {
        final printer = DurationPrinter(
          (builder) => builder
            ..part(TimeUnit.day)
            ..literal('*')
            ..part(TimeUnit.minute),
        );
        check(durations.map(printer.print)).deepEquals([
          '0*0',
          '12345*0',
          '1428*1293',
          '1*617',
          '0*70',
          '1*93',
          '2*184',
        ]);
      });
      test('skipIfZero', () {
        final printer = DurationPrinter(
          (builder) => builder
            ..part(TimeUnit.day, skipIfZero: true)
            ..literal('*')
            ..part(TimeUnit.minute, skipIfZero: true),
        );
        check(durations.map(printer.print)).deepEquals([
          '*',
          '12345*',
          '1428*1293',
          '1*617',
          '*70',
          '1*93',
          '2*184',
        ]);
      });
      test('absoluteValue', () {
        final printer = DurationPrinter(
          (builder) => builder
            ..part(TimeUnit.day, absoluteValue: false)
            ..literal('*')
            ..part(TimeUnit.minute, absoluteValue: false),
        );
        check(durations.map(printer.print)).deepEquals([
          '0*0',
          '12345*0',
          '1428*1293',
          '1*617',
          '0*70',
          '1*93',
          '-2*-184',
        ]);
      });
    });
    group('full', () {
      test('default', () {
        final printer = DurationPrinter(
          (builder) =>
              builder.full(TimeUnit.day, FixedNumberPrinter(precision: 6)),
        );
        check(durations.map(printer.print)).deepEquals([
          '0.000000',
          '12345.000000',
          '1428.898021',
          '1.428898',
          '0.048611',
          '1.064583',
          '-2.127778',
        ]);
      });
      test('skipIfZero', () {
        final printer = DurationPrinter(
          (builder) => builder.full(
            TimeUnit.day,
            FixedNumberPrinter(precision: 6),
            skipIfZero: true,
          ),
        );
        check(durations.map(printer.print)).deepEquals([
          '',
          '12345.000000',
          '1428.898021',
          '1.428898',
          '0.048611',
          '1.064583',
          '-2.127778',
        ]);
      });
      test('absoluteValue', () {
        final printer = DurationPrinter(
          (builder) => builder.full(
            TimeUnit.day,
            FixedNumberPrinter(precision: 6),
            absoluteValue: true,
          ),
        );
        check(durations.map(printer.print)).deepEquals([
          '0.000000',
          '12345.000000',
          '1428.898021',
          '1.428898',
          '0.048611',
          '1.064583',
          '2.127778',
        ]);
      });
    });
  });
}
