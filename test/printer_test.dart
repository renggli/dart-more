library more.test.printer_test;

import 'package:more/printer.dart';
import 'package:test/test.dart';

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
      });
    });
    group('scientific', () {
      test('default', () {
        final printer = Printer.scientific();
        expect(printer(0), '0.000e0');
        expect(printer(2), '2.000e0');
        expect(printer(300), '3.000e2');
        expect(printer(4321.768), '4.322e3');
        expect(printer(-53000), '-5.300e4');
        expect(printer(6720000000), '6.720e9');
        expect(printer(0.2), '2.000e-1');
        expect(printer(0.00000000751), '7.510e-9');
      });
      test('base', () {
        final printer = Printer.scientific(base: 16);
        expect(printer(0), '0.000e0');
        expect(printer(2), '2.000e0');
        expect(printer(300), '1.2c0e2');
        expect(printer(4321.768), '1.0e2e3');
        expect(printer(-53000), '-c.f08e3');
        expect(printer(6720000000), '1.909e8');
        expect(printer(0.2), '3.333e-1');
        expect(printer(0.00000000751), '2.041e-7');
      });
      test('characters', () {
        final printer =
            Printer.scientific(base: 16, characters: '0123456789ABCDEF');
        expect(printer(0), '0.000e0');
        expect(printer(2), '2.000e0');
        expect(printer(300), '1.2C0e2');
        expect(printer(4321.768), '1.0E2e3');
        expect(printer(-53000), '-C.F08e3');
        expect(printer(6720000000), '1.909e8');
        expect(printer(0.2), '3.333e-1');
        expect(printer(0.00000000751), '2.041e-7');
      });
      test('delimiter', () {
        final printer = Printer.scientific(delimiter: ',');
        expect(printer(0), '0,000e0');
        expect(printer(2), '2,000e0');
        expect(printer(300), '3,000e2');
        expect(printer(4321.768), '4,322e3');
        expect(printer(-53000), '-5,300e4');
        expect(printer(6720000000), '6,720e9');
        expect(printer(0.2), '2,000e-1');
        expect(printer(0.00000000751), '7,510e-9');
      });
      test('infinity', () {
        final printer = Printer.scientific(infinity: 'huge');
        expect(printer(0), '0.000e0');
        expect(printer(2), '2.000e0');
        expect(printer(300), '3.000e2');
        expect(printer(4321.768), '4.322e3');
        expect(printer(-53000), '-5.300e4');
        expect(printer(6720000000), '6.720e9');
        expect(printer(0.2), '2.000e-1');
        expect(printer(0.00000000751), '7.510e-9');
      });
      test('nan', () {
        final printer = Printer.scientific(nan: 'n/a');
        expect(printer(0), '0.000e0');
        expect(printer(2), '2.000e0');
        expect(printer(300), '3.000e2');
        expect(printer(4321.768), '4.322e3');
        expect(printer(-53000), '-5.300e4');
        expect(printer(6720000000), '6.720e9');
        expect(printer(0.2), '2.000e-1');
        expect(printer(0.00000000751), '7.510e-9');
      });
      test('notation', () {
        final printer = Printer.scientific(notation: 'E');
        expect(printer(0), '0.000E0');
        expect(printer(2), '2.000E0');
        expect(printer(300), '3.000E2');
        expect(printer(4321.768), '4.322E3');
        expect(printer(-53000), '-5.300E4');
        expect(printer(6720000000), '6.720E9');
        expect(printer(0.2), '2.000E-1');
        expect(printer(0.00000000751), '7.510E-9');
      });
      test('precision', () {
        final printer = Printer.scientific(precision: 6);
        expect(printer(0), '0.000000e0');
        expect(printer(2), '2.000000e0');
        expect(printer(300), '3.000000e2');
        expect(printer(4321.768), '4.321768e3');
        expect(printer(-53000), '-5.300000e4');
        expect(printer(6720000000), '6.720000e9');
        expect(printer(0.2), '2.000000e-1');
        expect(printer(0.00000000751), '7.510000e-9');
      });
      test('separator', () {
        final printer = Printer.scientific(separator: ' ');
        expect(printer(0), '0.000e0');
        expect(printer(2), '2.000e0');
        expect(printer(300), '3.000e2');
        expect(printer(4321.768), '4.322e3');
        expect(printer(-53000), '-5.300e4');
        expect(printer(6720000000), '6.720e9');
        expect(printer(0.2), '2.000e-1');
        expect(printer(0.00000000751), '7.510e-9');
      });
      test('significant', () {
        final printer = Printer.scientific(significant: 3);
        expect(printer(0), '0.000e0');
        expect(printer(2), '200.000e-2');
        expect(printer(300), '300.000e0');
        expect(printer(4321.768), '432.177e1');
        expect(printer(-53000), '-530.000e2');
        expect(printer(6720000000), '672.000e7');
        expect(printer(0.2), '200.000e-3');
        expect(printer(0.00000000751), '751.000e-11');
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
    group('separate', () {
      test('left', () {
        final printer = Printer.standard().separateLeft(3, 0, '_');
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '123_4');
        expect(printer('12345'), '123_45');
        expect(printer('123456'), '123_456');
        expect(printer('1234567'), '123_456_7');
        expect(printer('12345678'), '123_456_78');
        expect(printer('123456789'), '123_456_789');
        expect(printer('1234567890'), '123_456_789_0');
      });
      test('right', () {
        final printer = Printer.standard().separateRight(3, 0, '_');
        expect(printer(''), '');
        expect(printer('1'), '1');
        expect(printer('12'), '12');
        expect(printer('123'), '123');
        expect(printer('1234'), '1_234');
        expect(printer('12345'), '12_345');
        expect(printer('123456'), '123_456');
        expect(printer('1234567'), '1_234_567');
        expect(printer('12345678'), '12_345_678');
        expect(printer('123456789'), '123_456_789');
        expect(printer('1234567890'), '1_234_567_890');
      });
      test('offset left', () {
        final left0 = Printer.standard().separateLeft(3, 0, '_');
        expect(left0('1234567890'), '123_456_789_0');
        final left1 = Printer.standard().separateLeft(3, 1, '_');
        expect(left1('1234567890'), '1_234_567_890');
        final left2 = Printer.standard().separateLeft(3, 2, '_');
        expect(left2('1234567890'), '12_345_678_90');
      });
      test('offset right', () {
        final right0 = Printer.standard().separateRight(3, 0, '_');
        expect(right0('1234567890'), '1_234_567_890');
        final right1 = Printer.standard().separateRight(3, 1, '_');
        expect(right1('1234567890'), '123_456_789_0');
        final right2 = Printer.standard().separateRight(3, 2, '_');
        expect(right2('1234567890'), '12_345_678_90');
      });
    });
    group('sequence', () {
      test('simple', () {
        final printer = Printer.standard() + Printer.standard();
        expect(printer(1), '11');
      });
      test('coerce literal', () {
        final printer = Printer.standard() + '<--';
        expect(printer(2), '2<--');
      });
      test('coerce function', () {
        final printer = Printer.standard() +
                (object) => ((object as int) + 1).toString();
        expect(printer(3), '34');
      });
      test('multiple', () {
        final printer = Printer.standard() + '--' + Printer.standard() + '!';
        expect(printer(4), '4--4!');
      });
    });
  });
}
