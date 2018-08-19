library more.test.cache_test;

import 'package:test/test.dart';

import 'package:more/printer.dart';

void main() {
  test('toString', () {
    final printer = Printer.standard();
    expect(printer(123), '123');
    expect(printer('abc'), 'abc');
    expect(printer(const Symbol('abc')), 'Symbol("abc")');
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
    test('center', () {
      final printer = Printer.standard().padCenter(5);
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
  group('crop', () {
    test('left', () {
      final printer = Printer.standard().cropLeft(3);
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '234');
      expect(printer('12345'), '345');
      expect(printer('123456'), '456');
    });
    test('right', () {
      final printer = Printer.standard().cropRight(3);
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '123');
      expect(printer('12345'), '123');
      expect(printer('123456'), '123');
    });
    test('center', () {
      final printer = Printer.standard().cropBoth(3);
      expect(printer(''), '');
      expect(printer('1'), '1');
      expect(printer('12'), '12');
      expect(printer('123'), '123');
      expect(printer('1234'), '123');
      expect(printer('12345'), '234');
      expect(printer('123456'), '234');
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
}
