library more.test.cache_test;

import 'package:test/test.dart';

import 'package:more/printer.dart';

void main() {
  group('primitive', () {
    test('standard', () {
      final printer = Printer.standard();
      expect(printer(123), '123');
      expect(printer('abc'), 'abc');
      expect(printer(const Symbol('abc')), 'Symbol("abc")');
    });
    group('sign', () {
      test('default', () {
        final printer = Printer.sign();
        expect(printer(-123), '-');
        expect(printer(123), '');
      });
      test('custom', () {
        final printer = Printer.sign(
          negative: Printer.literal('--'),
          positive: Printer.literal('++'),
        );
        expect(printer(-123), '--');
        expect(printer(123), '++');
      });
    });
    group('number', () {
      group('int', () {
        test('default', () {
          final printer = Printer.number();
          expect(printer(0), '0');
          expect(printer(1234), '1234');
          expect(printer(-1234), '1234');
        });
        test('separator', () {
          final printer = Printer.number(separator: '.');
          expect(printer(1234), '1.234');
          expect(printer(1234567), '1.234.567');
        });
        test('base', () {
          final printer = Printer.number(base: 16);
          expect(printer(1234), '4d2');
          expect(printer(123123), '1e0f3');
        });
        test('characters', () {
          final printer =
              Printer.number(base: 16, characters: '0123456789ABCDEF');
          expect(printer(1234), '4D2');
          expect(printer(123123), '1E0F3');
        });
        test('digits', () {
          final printer = Printer.number(digits: 3);
          expect(printer(1), '  1');
          expect(printer(12), ' 12');
          expect(printer(123), '123');
          expect(printer(1234), '1234');
        });
        test('padding', () {
          final printer = Printer.number(digits: 3, padding: '*');
          expect(printer(1), '**1');
          expect(printer(12), '*12');
          expect(printer(123), '123');
          expect(printer(1234), '1234');
        });
      });
      group('double', () {
        test('precision', () {
          final printer = Printer.number(precision: 2);
          expect(printer(1.009), '1.01');
          expect(printer(1.01), '1.01');
          expect(printer(1.019), '1.02');
          expect(printer(1.25), '1.25');
          expect(printer(1.254), '1.25');
          expect(printer(1.256), '1.26');
          expect(printer(1.009), '1.01');
          expect(printer(0.9), '0.90');
          expect(printer(0.99), '0.99');
          expect(printer(0.999), '1.00');
          expect(printer(0.9999), '1.00');
          expect(printer(-0.9), '0.90');
          expect(printer(-0.99), '0.99');
          expect(printer(-0.999), '1.00');
          expect(printer(-0.9999), '1.00');
        });
        test('infinite', () {
          final printer = Printer.number();
          expect(printer(double.infinity), 'Infinity');
          expect(printer(double.negativeInfinity), 'Infinity');
        });
        test('infinite custom', () {
          final printer = Printer.number(infinity: 'Huge');
          expect(printer(double.infinity), 'Huge');
          expect(printer(double.negativeInfinity), 'Huge');
        });
        test('NaN', () {
          final printer = Printer.number();
          expect(printer(double.nan), 'NaN');
        });
        test('NaN custom', () {
          final printer = Printer.number(nan: 'Not a Number');
          expect(printer(double.nan), 'Not a Number');
        });
        test('separator', () {
          final printer = Printer.number(precision: 8, separator: '!');
          expect(printer(12345.0), '12!345.000!000!00');
          expect(printer(0.6789), '0.678!900!00');
        });
      });
      group('BigInt', () {
        test('default', () {
          final printer = Printer.number();
          expect(printer(BigInt.zero), '0');
          expect(printer(BigInt.from(1234)), '1234');
          expect(printer(BigInt.from(-1234)), '1234');
        });
        test('separator', () {
          final printer = Printer.number(separator: '.');
          expect(printer(BigInt.from(1234)), '1.234');
          expect(printer(BigInt.from(1234567)), '1.234.567');
        });
        test('base', () {
          final printer = Printer.number(base: 16);
          expect(printer(BigInt.from(1234)), '4d2');
          expect(printer(BigInt.from(123123)), '1e0f3');
        });
        test('digits', () {
          final printer = Printer.number(digits: 3);
          expect(printer(BigInt.from(1)), '  1');
          expect(printer(BigInt.from(12)), ' 12');
          expect(printer(BigInt.from(123)), '123');
          expect(printer(BigInt.from(1234)), '1234');
        });
      });
    });
    group('units', () {
      test('binary file size', () {
        final printer = Printer.binaryFileSize();
        expect(printer(1), '1 byte');
        expect(printer(2), '2 bytes');
        expect(printer(30), '30 bytes');
        expect(printer(500), '500 bytes');
        expect(printer(6000), '5.9 KiB');
        expect(printer(70000), '68.4 KiB');
        expect(printer(800000), '781.3 KiB');
        expect(printer(9000000), '8.6 MiB');
        expect(printer(10000000), '9.5 MiB');
        expect(printer(200000000), '190.7 MiB');
        expect(printer(3000000000), '2.8 GiB');
        expect(printer(40000000000), '37.3 GiB');
      });
      test('decimal file size', () {
        final printer = Printer.decimalFileSize();
        expect(printer(1), '1 byte');
        expect(printer(2), '2 bytes');
        expect(printer(30), '30 bytes');
        expect(printer(500), '500 bytes');
        expect(printer(6000), '6.0 kB');
        expect(printer(70000), '70.0 kB');
        expect(printer(800000), '800.0 kB');
        expect(printer(9000000), '9.0 MB');
        expect(printer(10000000), '10.0 MB');
        expect(printer(200000000), '200.0 MB');
        expect(printer(3000000000), '3.0 GB');
        expect(printer(40000000000), '40.0 GB');
      });
    });
  });
  group('operator', () {
    group('trim', () {
      test('both', () {
        final printer = Printer.standard().trim();
        expect(printer(''), '');
        expect(printer(' * '), '*');
        expect(printer('  **  '), '**');
      });
      test('left', () {
        final printer = Printer.standard().trimLeft();
        expect(printer(''), '');
        expect(printer(' * '), '* ');
        expect(printer('  **  '), '**  ');
      });
      test('right', () {
        final printer = Printer.standard().trimRight();
        expect(printer(''), '');
        expect(printer(' * '), ' *');
        expect(printer('  **  '), '  **');
      });
    });
    group('pad', () {
      test('left', () {
        final printer = Printer.standard().padLeft(5);
        expect(printer(''), '     ');
        expect(printer('1'), '    1');
        expect(printer('12'), '   12');
        expect(printer('123'), '  123');
        expect(printer('1234'), ' 1234');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
      });
      test('right', () {
        final printer = Printer.standard().padRight(5);
        expect(printer(''), '     ');
        expect(printer('1'), '1    ');
        expect(printer('12'), '12   ');
        expect(printer('123'), '123  ');
        expect(printer('1234'), '1234 ');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
      });
      test('both', () {
        final printer = Printer.standard().padBoth(5);
        expect(printer(''), '     ');
        expect(printer('1'), '  1  ');
        expect(printer('12'), ' 12  ');
        expect(printer('123'), ' 123 ');
        expect(printer('1234'), '1234 ');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
      });
      test('padding', () {
        final printer = Printer.standard().padLeft(5, '*');
        expect(printer(''), '*****');
        expect(printer('1'), '****1');
        expect(printer('12'), '***12');
        expect(printer('123'), '**123');
        expect(printer('1234'), '*1234');
        expect(printer('12345'), '12345');
        expect(printer('123456'), '123456');
      });
    });
    group('truncate', () {
      test('left', () {
        final printer = Printer.standard().truncateLeft(3);
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '234');
        expect(printer('12345'), '345');
        expect(printer('123456'), '456');
      });
      test('right', () {
        final printer = Printer.standard().truncateRight(3);
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '123');
        expect(printer('12345'), '123');
        expect(printer('123456'), '123');
      });
      test('ellipsis', () {
        final printer = Printer.standard().truncateRight(3, '...');
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '123...');
        expect(printer('12345'), '123...');
        expect(printer('123456'), '123...');
      });
    });
  });
}
