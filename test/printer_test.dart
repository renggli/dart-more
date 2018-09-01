library more.test.printer_test;

import 'package:more/printer.dart';
import 'package:test/test.dart';

void main() {
  test('standard', () {
    final printer = Printer.standard();
    expect(printer(123), '123');
    expect(printer('abc'), 'abc');
    expect(printer(const Symbol('abc')), 'Symbol("abc")');
  });
  group('sign', () {
    test('default', () {
      final printer = Printer.sign();
      expect(printer(-1), '-');
      expect(printer(1), '');
    });
    test('custom', () {
      final printer = Printer.sign(
        negative: Printer.literal('--'),
        positive: Printer.literal('++'),
      );
      expect(printer(-1), '--');
      expect(printer(1), '++');
    });
    test('omitPositiveSign', () {
      final printer = Printer.omitPositiveSign();
      expect(printer(-1), '-');
      expect(printer(1), '');
    });
    test('spacePositiveSign', () {
      final printer = Printer.spacePositiveSign();
      expect(printer(-1), '-');
      expect(printer(1), ' ');
    });
    test('negativeAndPositiveSign', () {
      final printer = Printer.negativeAndPositiveSign();
      expect(printer(-1), '-');
      expect(printer(1), '+');
    });
  });
  group('fixed', () {
    group('int', () {
      test('default', () {
        final printer = Printer.fixed();
        expect(printer(0), '0');
        expect(printer(1234), '1234');
        expect(printer(-1234), '-1234');
      });
      test('base', () {
        final printer = Printer.fixed(base: 16);
        expect(printer(1234), '4d2');
        expect(printer(123123), '1e0f3');
      });
      test('characters', () {
        final printer = Printer.fixed(base: 16, characters: '0123456789ABCDEF');
        expect(printer(1234), '4D2');
        expect(printer(123123), '1E0F3');
      });
      test('padding', () {
        final printer = Printer.fixed(padding: 3);
        expect(printer(1), '001');
        expect(printer(-12), '-012');
      });
      test('separator', () {
        final printer = Printer.fixed(separator: '.');
        expect(printer(1234), '1.234');
        expect(printer(1234567), '1.234.567');
      });
      test('sign', () {
        final printer = Printer.fixed(sign: Printer.negativeAndPositiveSign());
        expect(printer(0), '+0');
        expect(printer(1234), '+1234');
        expect(printer(-1234), '-1234');
      });
    });
    group('double', () {
      test('precision', () {
        final printer = Printer.fixed(precision: 2);
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
        expect(printer(-0.9), '-0.90');
        expect(printer(-0.99), '-0.99');
        expect(printer(-0.999), '-1.00');
        expect(printer(-0.9999), '-1.00');
      });
      test('infinite', () {
        final printer = Printer.fixed();
        expect(printer(double.infinity), 'Infinity');
        expect(printer(double.negativeInfinity), '-Infinity');
      });
      test('infinite custom', () {
        final printer = Printer.fixed(infinity: 'Huge');
        expect(printer(double.infinity), 'Huge');
        expect(printer(double.negativeInfinity), '-Huge');
      });
      test('NaN', () {
        final printer = Printer.fixed();
        expect(printer(double.nan), 'NaN');
      });
      test('NaN custom', () {
        final printer = Printer.fixed(nan: 'Not a Number');
        expect(printer(double.nan), 'Not a Number');
      });
      test('separator', () {
        final printer = Printer.fixed(precision: 8, separator: '!');
        expect(printer(12345.0), '12!345.000!000!00');
        expect(printer(0.6789), '0.678!900!00');
      });
      test('sign', () {
        final printer = Printer.fixed(
            precision: 1, sign: Printer.negativeAndPositiveSign());
        expect(printer(-1), '-1.0');
        expect(printer(0), '+0.0');
        expect(printer(1), '+1.0');
      });
    });
    group('BigInt', () {
      test('default', () {
        final printer = Printer.fixed();
        expect(printer(BigInt.zero), '0');
        expect(printer(BigInt.from(1234)), '1234');
        expect(printer(BigInt.from(-1234)), '-1234');
      });
      test('base', () {
        final printer = Printer.fixed(base: 16);
        expect(printer(BigInt.from(1234)), '4d2');
        expect(printer(BigInt.from(123123)), '1e0f3');
      });
      test('separator', () {
        final printer = Printer.fixed(separator: '.');
        expect(printer(BigInt.from(1234)), '1.234');
        expect(printer(BigInt.from(1234567)), '1.234.567');
      });
      test('sign', () {
        final printer = Printer.fixed(sign: Printer.negativeAndPositiveSign());
        expect(printer(BigInt.from(-1)), '-1');
        expect(printer(BigInt.from(0)), '+0');
        expect(printer(BigInt.from(1)), '+1');
      });
    });
    test('invalid', () {
      final printer = Printer.fixed();
      expect(() => printer('invalid'), throwsArgumentError);
    });
  });
  group('scientific', () {
    final m12 = BigInt.from(2).pow(127) - BigInt.one;
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
      expect(printer(m12), '1.701e38');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
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
      expect(printer(m12), '8.000e1f');
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
      expect(printer(m12), '8.000e1F');
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
      expect(printer(m12), '1,701e38');
    });
    test('exponentPadding', () {
      final printer = Printer.scientific(exponentPadding: 3);
      expect(printer(0), '0.000e000');
      expect(printer(2), '2.000e000');
      expect(printer(300), '3.000e002');
      expect(printer(4321.768), '4.322e003');
      expect(printer(-53000), '-5.300e004');
      expect(printer(6720000000), '6.720e009');
      expect(printer(0.2), '2.000e-001');
      expect(printer(0.00000000751), '7.510e-009');
      expect(printer(m12), '1.701e038');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('exponentSign', () {
      final printer =
          Printer.scientific(exponentSign: Printer.negativeAndPositiveSign());
      expect(printer(0), '0.000e+0');
      expect(printer(2), '2.000e+0');
      expect(printer(300), '3.000e+2');
      expect(printer(4321.768), '4.322e+3');
      expect(printer(-53000), '-5.300e+4');
      expect(printer(6720000000), '6.720e+9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
      expect(printer(m12), '1.701e+38');
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
      expect(printer(m12), '1.701e38');
    });
    test('mantissaPadding', () {
      final printer = Printer.scientific(mantissaPadding: 3);
      expect(printer(0), '000.000e0');
      expect(printer(2), '002.000e0');
      expect(printer(300), '003.000e2');
      expect(printer(4321.768), '004.322e3');
      expect(printer(-53000), '-005.300e4');
      expect(printer(6720000000), '006.720e9');
      expect(printer(0.2), '002.000e-1');
      expect(printer(0.00000000751), '007.510e-9');
      expect(printer(m12), '001.701e38');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('mantissaSign', () {
      final printer =
          Printer.scientific(mantissaSign: Printer.negativeAndPositiveSign());
      expect(printer(0), '+0.000e0');
      expect(printer(2), '+2.000e0');
      expect(printer(300), '+3.000e2');
      expect(printer(4321.768), '+4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '+6.720e9');
      expect(printer(0.2), '+2.000e-1');
      expect(printer(0.00000000751), '+7.510e-9');
      expect(printer(m12), '+1.701e38');
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
      expect(printer(m12), '1.701e38');
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
      expect(printer(m12), '1.701E38');
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
      expect(printer(m12), '1.701412e38');
    });
    test('separator', () {
      final printer =
          Printer.scientific(precision: 4, separator: ',', significant: 4);
      expect(printer(0), '0.000,0e0');
      expect(printer(2), '2,000.000,0e-3');
      expect(printer(300), '3,000.000,0e-1');
      expect(printer(4321.768), '4,321.768,0e0');
      expect(printer(-53000), '-5,300.000,0e1');
      expect(printer(6720000000), '6,720.000,0e6');
      expect(printer(0.2), '2,000.000,0e-4');
      expect(printer(0.00000000751), '7,510.000,0e-12');
      expect(printer(m12), '1,701.411,8e35');
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
      expect(printer(m12), '170.141e36');
    });
    test('invalid', () {
      final printer = Printer.scientific();
      expect(() => printer('invalid'), throwsArgumentError);
    });
  });
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
  group('undefined', () {
    test('default', () {
      final printer = Printer.standard().undefined();
      expect(printer(null), 'null');
      expect(printer('foo'), 'foo');
    });
    test('custom', () {
      final printer = Printer.standard().undefined('n/a');
      expect(printer(null), 'n/a');
      expect(printer('foo'), 'foo');
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
      final printer =
          Printer.standard() + (object) => ((object as int) + 1).toString();
      expect(printer(3), '34');
    });
    test('multiple', () {
      final printer = Printer.standard() + '--' + Printer.standard() + '!';
      expect(printer(4), '4--4!');
    });
  });
}
