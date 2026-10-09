import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('date & time', () {
    final dateTimes = [
      DateTime.utc(0),
      DateTime.utc(1980, 11, 6, 8, 25),
      DateTime.utc(1969, 7, 20, 20, 18, 4, 12),
      DateTime.utc(2023, 10, 24, 18, 8, 32, 271, 828),
    ];
    test('date', () {
      final printer = DateTimePrinter.date(separator: '.');
      check(dateTimes.map(printer.print))
          .deepEquals(['0000.01.01', '1980.11.06', '1969.07.20', '2023.10.24']);
    });
    test('time', () {
      final printer = DateTimePrinter.time(separator: '.', milliseconds: false);
      check(dateTimes.map(printer.print))
          .deepEquals(['00.00.00', '08.25.00', '20.18.04', '18.08.32']);
    });
    test('dateTime', () {
      final printer = DateTimePrinter.dateTime(
        dateSeparator: '.',
        timeSeparator: '.',
        dateTimeSeparator: ' ',
        microseconds: false,
      );
      check(dateTimes.map(printer.print)).deepEquals([
        '0000.01.01 00.00.00.000',
        '1980.11.06 08.25.00.000',
        '1969.07.20 20.18.04.012',
        '2023.10.24 18.08.32.271',
      ]);
    });
    test('iso8601', () {
      final printer = DateTimePrinter.iso8601();
      check(dateTimes.map(printer.print)).deepEquals([
        '0000-01-01T00:00:00.000',
        '1980-11-06T08:25:00.000',
        '1969-07-20T20:18:04.012',
        '2023-10-24T18:08:32.271828',
      ]);
    });
    test('iso8691 (deprecated)', () {
      // ignore: deprecated_member_use_from_same_package
      final printer = DateTimePrinter.iso8691();
      check(dateTimes.map(printer.print)).deepEquals([
        '0000-01-01T00:00:00.000',
        '1980-11-06T08:25:00.000',
        '1969-07-20T20:18:04.012',
        '2023-10-24T18:08:32.271828',
      ]);
    });
    group('era', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.era());
        check(dateTimes.map(printer.print))
            .deepEquals(['BC', 'AD', 'AD', 'AD']);
      });
    });
    group('year', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.year());
        check(dateTimes.map(printer.print))
            .deepEquals(['0', '1980', '1969', '2023']);
      });
      test('width: 6', () {
        final printer = DateTimePrinter((builder) => builder.year(width: 6));
        check(dateTimes.map(printer.print))
            .deepEquals(['000000', '001980', '001969', '002023']);
      });
    });
    group('quarter', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.quarter());
        check(dateTimes.map(printer.print)).deepEquals(['1', '4', '3', '4']);
      });
      test('names', () {
        final names = ['Q1', 'Q2', 'Q3', 'Q4'];
        final printer = DateTimePrinter(
          (builder) => builder.quarter(names: names),
        );
        check(dateTimes.map(printer.print))
            .deepEquals(['Q1', 'Q4', 'Q3', 'Q4']);
      });
    });
    group('month', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.month());
        check(dateTimes.map(printer.print)).deepEquals(['1', '11', '7', '10']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.month(width: 2));
        check(dateTimes.map(printer.print))
            .deepEquals(['01', '11', '07', '10']);
      });
      test('names', () {
        final names = 'JFMAMJJASOND'.split('');
        final printer = DateTimePrinter(
          (builder) => builder.month(names: names),
        );
        check(dateTimes.map(printer.print)).deepEquals(['J', 'N', 'J', 'O']);
      });
    });
    group('weekday', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.weekday());
        check(dateTimes.map(printer.print)).deepEquals(['6', '4', '7', '2']);
      });
      test('names', () {
        final names = 'MTWTFSS'.split('');
        final printer = DateTimePrinter(
          (builder) => builder.weekday(names: names),
        );
        check(dateTimes.map(printer.print)).deepEquals(['S', 'T', 'S', 'T']);
      });
    });
    group('weekNumber', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.weekNumber());
        check(dateTimes.map(printer.print))
            .deepEquals(['52', '45', '29', '43']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter(
          (builder) => builder.weekNumber(width: 2),
        );
        check(dateTimes.map(printer.print))
            .deepEquals(['52', '45', '29', '43']);
      });
    });
    group('day', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.day());
        check(dateTimes.map(printer.print)).deepEquals(['1', '6', '20', '24']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.day(width: 2));
        check(dateTimes.map(printer.print))
            .deepEquals(['01', '06', '20', '24']);
      });
    });
    group('dayOfYear', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.dayOfYear());
        check(dateTimes.map(printer.print))
            .deepEquals(['1', '311', '201', '297']);
      });
      test('width: 3', () {
        final printer = DateTimePrinter(
          (builder) => builder.dayOfYear(width: 3),
        );
        check(dateTimes.map(printer.print))
            .deepEquals(['001', '311', '201', '297']);
      });
    });
    group('meridiem', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.meridiem());
        check(dateTimes.map(printer.print))
            .deepEquals(['am', 'am', 'pm', 'pm']);
      });
    });
    group('hour', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.hour());
        check(dateTimes.map(printer.print)).deepEquals(['0', '8', '20', '18']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.hour(width: 2));
        check(dateTimes.map(printer.print))
            .deepEquals(['00', '08', '20', '18']);
      });
    });
    group('hour12', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.hour12());
        check(dateTimes.map(printer.print)).deepEquals(['12', '8', '8', '6']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.hour12(width: 2));
        check(dateTimes.map(printer.print))
            .deepEquals(['12', '08', '08', '06']);
      });
    });
    group('minute', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.minute());
        check(dateTimes.map(printer.print)).deepEquals(['0', '25', '18', '8']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.minute(width: 2));
        check(dateTimes.map(printer.print))
            .deepEquals(['00', '25', '18', '08']);
      });
    });
    group('second', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.second());
        check(dateTimes.map(printer.print)).deepEquals(['0', '0', '4', '32']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter((builder) => builder.second(width: 2));
        check(dateTimes.map(printer.print))
            .deepEquals(['00', '00', '04', '32']);
      });
    });
    group('millisecond', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.millisecond());
        check(dateTimes.map(printer.print))
            .deepEquals(['000', '000', '012', '271']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter(
          (builder) => builder.millisecond(width: 2),
        );
        check(dateTimes.map(printer.print))
            .deepEquals(['00', '00', '01', '27']);
      });
    });
    group('microsecond', () {
      test('default', () {
        final printer = DateTimePrinter((builder) => builder.microsecond());
        check(dateTimes.map(printer.print))
            .deepEquals(['000', '000', '000', '828']);
      });
      test('width: 2', () {
        final printer = DateTimePrinter(
          (builder) => builder.microsecond(width: 2),
        );
        check(dateTimes.map(printer.print))
            .deepEquals(['00', '00', '00', '82']);
      });
      test('skipIfZero', () {
        final printer = DateTimePrinter(
          (builder) => builder.microsecond(skipIfZero: true),
        );
        check(dateTimes.map(printer.print)).deepEquals(['', '', '', '828']);
      });
    });
    test('toString', () {
      final printer = DateTimePrinter.iso8601();
      check(printer.toString()).startsWith('DateTimePrinter');
    });
  });
}
