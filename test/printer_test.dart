import 'package:more/math.dart';
import 'package:more/printer.dart';
import 'package:test/test.dart';

const standardString = StandardPrinter<String>();
const standardInt = StandardPrinter<int>();

void main() {
  group('standard', () {
    test('untyped', () {
      const printer = StandardPrinter();
      expect(printer(123), '123');
      expect(printer('abc'), 'abc');
    });
    test('typed', () {
      const printer = StandardPrinter<num>();
      expect(printer(123), '123');
      expect(printer(123.4), '123.4');
    });
  });
  group('literal', () {
    test('default', () {
      const printer = LiteralPrinter<int>();
      expect(printer(123), '');
    });
    test('untyped', () {
      const printer = LiteralPrinter('hello');
      expect(printer(123), 'hello');
      expect(printer('abc'), 'hello');
    });
    test('typed', () {
      const printer = LiteralPrinter<num>('hello');
      expect(printer(123), 'hello');
      expect(printer(123.4), 'hello');
    });
  });
  group('sign', () {
    group('int', () {
      test('default', () {
        const printer = SignNumberPrinter<int>();
        expect(printer(-1), '-');
        expect(printer(1), '');
      });
      test('custom', () {
        const printer = SignNumberPrinter<int>(
          negative: LiteralPrinter('--'),
          positive: LiteralPrinter('++'),
        );
        expect(printer(-1), '--');
        expect(printer(1), '++');
      });
      test('omitPositiveSign', () {
        const printer = SignNumberPrinter<int>.omitPositiveSign();
        expect(printer(-1), '-');
        expect(printer(1), '');
      });
      test('spacePositiveSign', () {
        const printer = SignNumberPrinter<int>.spacePositiveSign();
        expect(printer(-1), '-');
        expect(printer(1), ' ');
      });
      test('negativeAndPositiveSign', () {
        const printer = SignNumberPrinter<int>.negativeAndPositiveSign();
        expect(printer(-1), '-');
        expect(printer(1), '+');
      });
    });
    group('double', () {
      test('default', () {
        const printer = SignNumberPrinter<double>();
        expect(printer(-1.1), '-');
        expect(printer(1.1), '');
      });
      test('custom', () {
        const printer = SignNumberPrinter<double>(
          negative: LiteralPrinter('--'),
          positive: LiteralPrinter('++'),
        );
        expect(printer(-1.1), '--');
        expect(printer(1.1), '++');
      });
      test('omitPositiveSign', () {
        const printer = SignNumberPrinter<double>.omitPositiveSign();
        expect(printer(-1.1), '-');
        expect(printer(1.1), '');
      });
      test('spacePositiveSign', () {
        const printer = SignNumberPrinter<double>.spacePositiveSign();
        expect(printer(-1.1), '-');
        expect(printer(1.1), ' ');
      });
      test('negativeAndPositiveSign', () {
        const printer = SignNumberPrinter<double>.negativeAndPositiveSign();
        expect(printer(-1.1), '-');
        expect(printer(1.1), '+');
      });
    });
  });
  group('fixed', () {
    group('int', () {
      test('default', () {
        final printer = FixedNumberPrinter<int>();
        expect(printer(0), '0');
        expect(printer(1234), '1234');
        expect(printer(-1234), '-1234');
      });
      test('base', () {
        final printer = FixedNumberPrinter<int>(base: 16);
        expect(printer(1234), '4d2');
        expect(printer(123123), '1e0f3');
      });
      test('characters', () {
        final printer =
            FixedNumberPrinter<int>(base: 16, characters: '0123456789ABCDEF');
        expect(printer(1234), '4D2');
        expect(printer(123123), '1E0F3');
      });
      test('padding', () {
        final printer = FixedNumberPrinter<int>(padding: 3);
        expect(printer(1), '001');
        expect(printer(-12), '-012');
      });
      test('separator', () {
        final printer = FixedNumberPrinter<int>(separator: '.');
        expect(printer(1234), '1.234');
        expect(printer(1234567), '1.234.567');
      });
      test('sign', () {
        final printer = FixedNumberPrinter<int>(
            sign: const SignNumberPrinter<int>.negativeAndPositiveSign());
        expect(printer(0), '+0');
        expect(printer(1234), '+1234');
        expect(printer(-1234), '-1234');
      });
    });
    group('double', () {
      test('precision: 0', () {
        final printer = FixedNumberPrinter<double>();
        expect(printer(1.4), '1');
        expect(printer(1.5), '2');
        expect(printer(-1.4), '-1');
        expect(printer(-1.5), '-2');
      });
      test('precision: 2', () {
        final printer = FixedNumberPrinter<double>(precision: 2);
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
        final printer = FixedNumberPrinter<double>();
        expect(printer(double.infinity), 'Infinity');
        expect(printer(double.negativeInfinity), '-Infinity');
      });
      test('infinite custom', () {
        final printer = FixedNumberPrinter<double>(infinity: 'Huge');
        expect(printer(double.infinity), 'Huge');
        expect(printer(double.negativeInfinity), '-Huge');
      });
      test('NaN', () {
        final printer = FixedNumberPrinter<double>();
        expect(printer(double.nan), 'NaN');
      });
      test('NaN custom', () {
        final printer = FixedNumberPrinter<double>(nan: 'Not a Number');
        expect(printer(double.nan), 'Not a Number');
      });
      test('separator', () {
        final printer =
            FixedNumberPrinter<double>(precision: 8, separator: '!');
        expect(printer(12345.0), '12!345.000!000!00');
        expect(printer(0.6789), '0.678!900!00');
      });
      test('sign', () {
        final printer = FixedNumberPrinter<double>(
            precision: 1,
            sign: const SignNumberPrinter<double>.negativeAndPositiveSign());
        expect(printer(-1), '-1.0');
        expect(printer(0), '+0.0');
        expect(printer(1), '+1.0');
      });
    });
  });
  group('scientific', () {
    test('default', () {
      final printer = ScientificNumberPrinter();
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '3.000e2');
      expect(printer(4321.768), '4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '6.720e9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('base', () {
      final printer = ScientificNumberPrinter(base: 16);
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
          ScientificNumberPrinter(base: 16, characters: '0123456789ABCDEF');
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
      final printer = ScientificNumberPrinter(delimiter: ',');
      expect(printer(0), '0,000e0');
      expect(printer(2), '2,000e0');
      expect(printer(300), '3,000e2');
      expect(printer(4321.768), '4,322e3');
      expect(printer(-53000), '-5,300e4');
      expect(printer(6720000000), '6,720e9');
      expect(printer(0.2), '2,000e-1');
      expect(printer(0.00000000751), '7,510e-9');
    });
    test('exponentPadding', () {
      final printer = ScientificNumberPrinter(exponentPadding: 3);
      expect(printer(0), '0.000e000');
      expect(printer(2), '2.000e000');
      expect(printer(300), '3.000e002');
      expect(printer(4321.768), '4.322e003');
      expect(printer(-53000), '-5.300e004');
      expect(printer(6720000000), '6.720e009');
      expect(printer(0.2), '2.000e-001');
      expect(printer(0.00000000751), '7.510e-009');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('exponentSign', () {
      final printer = ScientificNumberPrinter(
          exponentSign: const SignNumberPrinter.negativeAndPositiveSign());
      expect(printer(0), '0.000e+0');
      expect(printer(2), '2.000e+0');
      expect(printer(300), '3.000e+2');
      expect(printer(4321.768), '4.322e+3');
      expect(printer(-53000), '-5.300e+4');
      expect(printer(6720000000), '6.720e+9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
    });
    test('infinity', () {
      final printer = ScientificNumberPrinter(infinity: 'huge');
      expect(printer(0), '0.000e0');
      expect(printer(2), '2.000e0');
      expect(printer(300), '3.000e2');
      expect(printer(4321.768), '4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '6.720e9');
      expect(printer(0.2), '2.000e-1');
      expect(printer(0.00000000751), '7.510e-9');
    });
    test('mantissaPadding', () {
      final printer = ScientificNumberPrinter(mantissaPadding: 3);
      expect(printer(0), '000.000e0');
      expect(printer(2), '002.000e0');
      expect(printer(300), '003.000e2');
      expect(printer(4321.768), '004.322e3');
      expect(printer(-53000), '-005.300e4');
      expect(printer(6720000000), '006.720e9');
      expect(printer(0.2), '002.000e-1');
      expect(printer(0.00000000751), '007.510e-9');
      expect(printer(double.nan), 'NaN');
      expect(printer(double.infinity), 'Infinity');
    });
    test('mantissaSign', () {
      final printer = ScientificNumberPrinter(
          mantissaSign: const SignNumberPrinter.negativeAndPositiveSign());
      expect(printer(0), '+0.000e0');
      expect(printer(2), '+2.000e0');
      expect(printer(300), '+3.000e2');
      expect(printer(4321.768), '+4.322e3');
      expect(printer(-53000), '-5.300e4');
      expect(printer(6720000000), '+6.720e9');
      expect(printer(0.2), '+2.000e-1');
      expect(printer(0.00000000751), '+7.510e-9');
    });
    test('nan', () {
      final printer = ScientificNumberPrinter(nan: 'n/a');
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
      final printer = ScientificNumberPrinter(notation: 'E');
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
      final printer = ScientificNumberPrinter(precision: 6);
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
      final printer =
          ScientificNumberPrinter(precision: 4, separator: ',', significant: 4);
      expect(printer(0), '0.000,0e0');
      expect(printer(2), '2,000.000,0e-3');
      expect(printer(300), '3,000.000,0e-1');
      expect(printer(4321.768), '4,321.768,0e0');
      expect(printer(-53000), '-5,300.000,0e1');
      expect(printer(6720000000), '6,720.000,0e6');
      expect(printer(0.2), '2,000.000,0e-4');
      expect(printer(0.00000000751), '7,510.000,0e-12');
    });
    test('significant', () {
      final printer = ScientificNumberPrinter(significant: 3);
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
  group('human', () {
    group('decimal', () {
      test('default', () {
        final printer = HumanNumberPrinter.decimal();
        expect(printer(0), '0');
        expect(printer(10), '10');
        expect(printer(200), '200');
        expect(printer(3000), '3 k');
        expect(printer(4e4), '40 k');
        expect(printer(-5e5), '-500 k');
        expect(printer(-6e6), '-6 M');
        expect(printer(7e-7), '700 n');
        expect(printer(8e-8), '80 n');
        expect(printer(-9e-9), '-9 n');
        expect(printer(-1e-10), '-100 p');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.decimal(nan: 'n/a');
        expect(printer(double.nan), 'n/a');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.decimal(infinity: 'huge');
        expect(printer(double.infinity), 'huge');
        expect(printer(double.negativeInfinity), '-huge');
      });
      test('unitPrefix', () {
        final printer = HumanNumberPrinter.decimal(unitPrefix: true);
        expect(printer(4), '4');
        expect(printer(4e3), 'k 4');
        expect(printer(4e7), 'M 40');
        expect(printer(-4), '-4');
        expect(printer(-4e3), 'k -4');
        expect(printer(-4e7), 'M -40');
      });
      test('unitSeparator', () {
        final printer = HumanNumberPrinter.decimal(unitSeparator: '*');
        expect(printer(4), '4');
        expect(printer(4e3), '4*k');
        expect(printer(4e7), '40*M');
        expect(printer(-4), '-4');
        expect(printer(-4e3), '-4*k');
        expect(printer(-4e7), '-40*M');
      });
      test('long (double)', () {
        final base = 1000.toDouble();
        final printer = HumanNumberPrinter.decimal(long: true);
        final units = List.generate(19, (i) => printer(base.pow(i - 9)));
        expect(units, [
          '0 yocto',
          '1 yocto',
          '1 zepto',
          '1 atto',
          '1 femto',
          '1 pico',
          '1 nano',
          '1 micro',
          '1 milli',
          '1',
          '1 kilo',
          '1 mega',
          '1 giga',
          '1 tera',
          '1 peta',
          '1 exa',
          '1 zetta',
          '1 yotta',
          '1000 yotta',
        ]);
      });
    });
    group('binary', () {
      test('default', () {
        final printer = HumanNumberPrinter.binary();
        expect(printer(0), '0');
        expect(printer(10), '10');
        expect(printer(200), '200');
        expect(printer(3000), '3 Ki');
        expect(printer(4e4), '39 Ki');
        expect(printer(-5e5), '-488 Ki');
        expect(printer(-6e6), '-6 Mi');
        expect(printer(7e-7), '0');
        expect(printer(-8e-8), '-0');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.binary(nan: 'n/a');
        expect(printer(double.nan), 'n/a');
      });
      test('nan', () {
        final printer = HumanNumberPrinter.binary(infinity: 'huge');
        expect(printer(double.infinity), 'huge');
        expect(printer(double.negativeInfinity), '-huge');
      });
      test('unitPrefix', () {
        final printer = HumanNumberPrinter.binary(unitPrefix: true);
        expect(printer(4), '4');
        expect(printer(4e3), 'Ki 4');
        expect(printer(4e7), 'Mi 38');
        expect(printer(-4), '-4');
        expect(printer(-4e3), 'Ki -4');
        expect(printer(-4e7), 'Mi -38');
      });
      test('unitSeparator', () {
        final printer = HumanNumberPrinter.binary(unitSeparator: '*');
        expect(printer(4), '4');
        expect(printer(4e3), '4*Ki');
        expect(printer(4e7), '38*Mi');
        expect(printer(-4), '-4');
        expect(printer(-4e3), '-4*Ki');
        expect(printer(-4e7), '-38*Mi');
      });
      test('long (double)', () {
        final base = 1024.toDouble();
        final printer = HumanNumberPrinter.binary(long: true);
        final units = List.generate(10, (i) => printer(base.pow(i)));
        expect(units, [
          '1',
          '1 kibi',
          '1 mebi',
          '1 gibi',
          '1 tebi',
          '1 pebi',
          '1 exbi',
          '1 zebi',
          '1 yobi',
          '1024 yobi',
        ]);
      });
    });
  });
  group('trim', () {
    test('both', () {
      final printer = standardString.trim();
      expect(printer(''), '');
      expect(printer(' * '), '*');
      expect(printer('  **  '), '**');
    });
    test('left', () {
      final printer = standardString.trimLeft();
      expect(printer(''), '');
      expect(printer(' * '), '* ');
      expect(printer('  **  '), '**  ');
    });
    test('right', () {
      final printer = standardString.trimRight();
      expect(printer(''), '');
      expect(printer(' * '), ' *');
      expect(printer('  **  '), '  **');
    });
  });
  group('pad', () {
    test('left', () {
      final printer = standardString.padLeft(5);
      expect(printer(''), '     ');
      expect(printer('1'), '    1');
      expect(printer('12'), '   12');
      expect(printer('123'), '  123');
      expect(printer('1234'), ' 1234');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '    👋');
    });
    test('left with custom pad', () {
      final printer = standardString.padLeft(5, '*');
      expect(printer(''), '*****');
      expect(printer('1'), '****1');
      expect(printer('12'), '***12');
      expect(printer('123'), '**123');
      expect(printer('1234'), '*1234');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '****👋');
    });
    test('right', () {
      final printer = standardString.padRight(5);
      expect(printer(''), '     ');
      expect(printer('1'), '1    ');
      expect(printer('12'), '12   ');
      expect(printer('123'), '123  ');
      expect(printer('1234'), '1234 ');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '👋    ');
    });
    test('right with custom pad', () {
      final printer = standardString.padRight(5, '*');
      expect(printer(''), '*****');
      expect(printer('1'), '1****');
      expect(printer('12'), '12***');
      expect(printer('123'), '123**');
      expect(printer('1234'), '1234*');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '👋****');
    });
    test('both', () {
      final printer = standardString.padBoth(5);
      expect(printer(''), '     ');
      expect(printer('1'), '  1  ');
      expect(printer('12'), ' 12  ');
      expect(printer('123'), ' 123 ');
      expect(printer('1234'), '1234 ');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '  👋  ');
    });
    test('both with custom pad', () {
      final printer = standardString.padBoth(5, '*');
      expect(printer(''), '*****');
      expect(printer('1'), '**1**');
      expect(printer('12'), '*12**');
      expect(printer('123'), '*123*');
      expect(printer('1234'), '1234*');
      expect(printer('12345'), '12345');
      expect(printer('123456'), '123456');
      expect(printer('👋'), '**👋**');
    });
  });
  group('truncate', () {
    test('left', () {
      final printer = standardString.truncateLeft(3);
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '234');
      expect(printer('12345'), '345');
      expect(printer('123456'), '456');
      expect(printer('👨👩👧👦'), '👩👧👦');
    });
    test('left with ellipsis', () {
      final printer = standardString.truncateLeft(3, '...');
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '...234');
      expect(printer('12345'), '...345');
      expect(printer('123456'), '...456');
      expect(printer('👨👩👧👦'), '...👩👧👦');
    });
    test('right', () {
      final printer = standardString.truncateRight(3);
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '123');
      expect(printer('12345'), '123');
      expect(printer('123456'), '123');
      expect(printer('👨👩👧👦'), '👨👩👧');
    });
    test('right with ellipsis', () {
      final printer = standardString.truncateRight(3, '...');
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '123...');
      expect(printer('12345'), '123...');
      expect(printer('123456'), '123...');
      expect(printer('👨👩👧👦'), '👨👩👧...');
    });
  });
  group('separate', () {
    test('left', () {
      final printer = standardString.separateLeft(3, 0, '_');
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
      expect(printer('👨👩👧👦'), '👨👩👧_👦');
    });
    test('right', () {
      final printer = standardString.separateRight(3, 0, '_');
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
      expect(printer('👨👩👧👦'), '👨_👩👧👦');
    });
    test('offset left', () {
      final left0 = standardString.separateLeft(3, 0, '_');
      expect(left0('1234567890'), '123_456_789_0');
      final left1 = standardString.separateLeft(3, 1, '_');
      expect(left1('1234567890'), '1_234_567_890');
      final left2 = standardString.separateLeft(3, 2, '_');
      expect(left2('1234567890'), '12_345_678_90');
    });
    test('offset right', () {
      final right0 = standardString.separateRight(3, 0, '_');
      expect(right0('1234567890'), '1_234_567_890');
      final right1 = standardString.separateRight(3, 1, '_');
      expect(right1('1234567890'), '123_456_789_0');
      final right2 = standardString.separateRight(3, 2, '_');
      expect(right2('1234567890'), '12_345_678_90');
    });
  });
  group('ifNull', () {
    test('default', () {
      final printer = standardString.ifNull();
      expect(printer(null), '␀');
      expect(printer('foo'), 'foo');
    });
    test('custom', () {
      final printer = standardString.ifNull('n/a');
      expect(printer(null), 'n/a');
      expect(printer('foo'), 'foo');
    });
  });
  group('sequence', () {
    test('default', () {
      const printer = SequencePrinter<String>(
          [standardString, LiteralPrinter<String>('-'), standardString]);
      expect(printer('1'), '1-1');
      expect(printer('12'), '12-12');
    });
    test('before', () {
      final printer = standardString.before('*');
      expect(printer('1'), '*1');
    });
    test('after', () {
      final printer = standardString.after('*');
      expect(printer('1'), '1*');
    });
    test('around (same)', () {
      final printer = standardString.around('*');
      expect(printer('1'), '*1*');
    });
    test('around (different)', () {
      final printer = standardString.around('<', '>');
      expect(printer('1'), '<1>');
    });
  });
  group('iterable', () {
    test('default', () {
      final printer = standardInt.iterable();
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, 5');
    });
    test('separator', () {
      final printer = standardInt.iterable(separator: ';');
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1;2');
      expect(printer([1, 2, 3]), '1;2;3');
      expect(printer([1, 2, 3, 4]), '1;2;3;4');
      expect(printer([1, 2, 3, 4, 5]), '1;2;3;4;5');
    });
    test('lastSeparator', () {
      final printer = standardInt.iterable(lastSeparator: ', and ');
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, and 2');
      expect(printer([1, 2, 3]), '1, 2, and 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, and 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, and 5');
    });
    test('leadingItems', () {
      final printer = standardInt.iterable(leadingItems: 3);
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5, 6]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5, 6, 7]), '1, 2, 3, …');
      expect(printer([1, 2, 3, 4, 5, 6, 7, 8]), '1, 2, 3, …');
    });
    test('trailingItems', () {
      final printer = standardInt.iterable(trailingItems: 3);
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '…, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '…, 3, 4, 5');
      expect(printer([1, 2, 3, 4, 5, 6]), '…, 4, 5, 6');
      expect(printer([1, 2, 3, 4, 5, 6, 7]), '…, 5, 6, 7');
      expect(printer([1, 2, 3, 4, 5, 6, 7, 8]), '…, 6, 7, 8');
    });
    test('leadingItems and trailingItems', () {
      final printer = standardInt.iterable(leadingItems: 3, trailingItems: 3);
      expect(printer([]), '');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
      expect(printer([1, 2, 3]), '1, 2, 3');
      expect(printer([1, 2, 3, 4]), '1, 2, 3, 4');
      expect(printer([1, 2, 3, 4, 5]), '1, 2, 3, 4, 5');
      expect(printer([1, 2, 3, 4, 5, 6]), '1, 2, 3, 4, 5, 6');
      expect(printer([1, 2, 3, 4, 5, 6, 7]), '1, 2, 3, …, 5, 6, 7');
      expect(printer([1, 2, 3, 4, 5, 6, 7, 8]), '1, 2, 3, …, 6, 7, 8');
    });
  });
  group('ifEmpty', () {
    test('default', () {
      final printer = standardInt.iterable().ifEmpty();
      expect(printer([]), '∅');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
    });
    test('custom', () {
      final printer = standardInt.iterable().ifEmpty('n/a');
      expect(printer([]), 'n/a');
      expect(printer([1]), '1');
      expect(printer([1, 2]), '1, 2');
    });
  });
  group('transform', () {
    test('map', () {
      final printer = standardInt.map(int.parse);
      expect(() => printer(''), throwsFormatException);
      expect(printer('1'), '1');
      expect(printer('12'), '12');
    });
    test('cast', () {
      final printer = standardString.cast<Object>();
      expect(() => printer(0), throwsA(isA<TypeError>()));
      expect(printer('1'), '1');
      expect(printer('12'), '12');
    });
  });
  group('wrap', () {
    test('printer', () {
      final printer = Printer<String>.wrap(standardString);
      expect(printer, standardString);
      expect(printer('1'), '1');
    });
    test('callback', () {
      final printer = Printer<int>.wrap((value) => (2 * value).toString());
      expect(printer(1), '2');
      expect(printer(12), '24');
    });
    test('string', () {
      final printer = Printer<int>.wrap('*');
      expect(printer(1), '*');
      expect(printer(12), '*');
    });
    test('invalid', () {
      expect(() => Printer<String>.wrap(standardInt), throwsArgumentError);
      expect(() => Printer<String>.wrap(num.parse), throwsArgumentError);
      expect(() => Printer<String>.wrap(12), throwsArgumentError);
    });
  });
}
