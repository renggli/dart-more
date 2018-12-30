library more.test.number_test;

import 'dart:math' as math;

import 'package:more/number.dart';
import 'package:test/test.dart';

void main() {
  group('complex', () {
    group('construction', () {
      test('zero', () {
        const complex = Complex.zero;
        expect(complex.real, 0);
        expect(complex.imaginary, 0);
        expect(complex.abs, 0.0);
        expect(complex.phase, 0.0);
      });
      test('one', () {
        const complex = Complex.one;
        expect(complex.real, 1);
        expect(complex.imaginary, 0);
        expect(complex.abs, 1.0);
        expect(complex.phase, 0.0);
      });
      test('imaginary', () {
        const complex = Complex.i;
        expect(complex.real, 0);
        expect(complex.imaginary, 1);
        expect(complex.abs, 1.0);
        expect(complex.phase, math.pi / 2);
      });
      test('real', () {
        final complex = Complex.fromReal(123);
        expect(complex.real, 123);
        expect(complex.imaginary, 0);
        expect(complex.abs, 123.0);
        expect(complex.phase, 0.0);
      });
      test('cartesian', () {
        final complex = Complex.fromCartesian(-3, 4);
        expect(complex.real, -3);
        expect(complex.imaginary, 4);
        expect(complex.abs, 5.0);
        expect(complex.phase, math.acos(4 / 5) + math.pi / 2);
      });
      test('polar', () {
        final complex = Complex.fromPolar(math.sqrt(2), 3 * math.pi / 4);
        expect(complex.real.roundToDouble(), -1.0);
        expect(complex.imaginary.roundToDouble(), 1.0);
        expect(complex.abs, math.sqrt(2));
        expect(complex.phase, 3 * math.pi / 4);
      });
    });
    group('arithmetic', () {
      test('addition', () {
        expect(Complex(1, -2) + Complex(-3, 4), Complex(-2, 2));
      });
      test('substraction', () {
        expect(Complex(1, -2) - Complex(-3, 4), Complex(4, -6));
      });
      test('multiplication', () {
        expect(Complex(1, -2) * Complex(-3, 4), Complex(5, 10));
        expect(Complex(-3, 4) * Complex(1, -2), Complex(5, 10));
      });
      test('division', () {
        expect(Complex(5, 10) / Complex(-3, 4), Complex(1, -2));
        expect(Complex(5, 10) / Complex(1, -2), Complex(-3, 4));
      });
      test('negate', () {
        expect(-Complex(1, -2), Complex(-1, 2));
      });
      test('conjugate', () {
        expect(Complex(1, -2).conjugate, Complex(1, 2));
      });
    });
    group('testing', () {
      test('isNan', () {
        expect(Complex(0, 0).isNaN, isFalse);
        expect(Complex(0, double.nan).isNaN, isTrue);
        expect(Complex(double.nan, 0).isNaN, isTrue);
        expect(Complex(double.nan, double.nan).isNaN, isTrue);
      });
      test('isInfinite', () {
        expect(Complex(0, 0).isInfinite, isFalse);
        expect(Complex(0, double.infinity).isInfinite, isTrue);
        expect(Complex(double.infinity, 0).isInfinite, isTrue);
        expect(Complex(double.infinity, double.infinity).isInfinite, isTrue);
      });
    });
    group('converting', () {
      test('toString', () {
        expect(Complex.zero.toString(), '0+0i');
        expect(Complex.one.toString(), '1+0i');
        expect(Complex.i.toString(), '0+1i');
        expect(Complex(0, 2).toString(), '0+2i');
        expect(Complex(0, -1).toString(), '0-1i');
        expect(Complex(0, -2).toString(), '0-2i');
        expect(Complex(1, 2).toString(), '1+2i');
        expect(Complex(1, 1).toString(), '1+1i');
        expect(Complex(1, -1).toString(), '1-1i');
        expect(Complex(1, 2).toString(), '1+2i');
      });
    });
  });
  group('fraction', () {
    group('construction', () {
      test('irreducible', () {
        final fraction = Fraction(3, 7);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('reducible', () {
        final fraction = Fraction(15, 35);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('normal negative', () {
        final fraction = Fraction(-2, 4);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('double negative', () {
        final fraction = Fraction(-2, -4);
        expect(fraction.numerator, 1);
        expect(fraction.denominator, 2);
      });
      test('denominator negative', () {
        final fraction = Fraction(2, -4);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('numerator error', () {
        expect(() => Fraction(null), throwsArgumentError);
      });
      test('denominator error', () {
        expect(() => Fraction(2, 0), throwsArgumentError);
        expect(() => Fraction(2, null), throwsArgumentError);
      });
      test('double basic', () {
        expect(Fraction.fromDouble(2), Fraction(2));
        expect(Fraction.fromDouble(100), Fraction(100));
      });
      test('double finite', () {
        expect(Fraction.fromDouble(1 / 2), Fraction(1, 2));
        expect(Fraction.fromDouble(1 / 4), Fraction(1, 4));
      });
      test('double finite (whole)', () {
        expect(Fraction.fromDouble(5 / 2), Fraction(5, 2));
        expect(Fraction.fromDouble(9 / 4), Fraction(9, 4));
      });
      test('double infinite', () {
        expect(Fraction.fromDouble(1 / 3), Fraction(1, 3));
        expect(Fraction.fromDouble(1 / 7), Fraction(1, 7));
      });
      test('double infinite (whole)', () {
        expect(Fraction.fromDouble(5 / 3), Fraction(5, 3));
        expect(Fraction.fromDouble(9 / 7), Fraction(9, 7));
      });
      test('double negative', () {
        expect(Fraction.fromDouble(-1 / 3), Fraction(-1, 3));
        expect(Fraction.fromDouble(-5 / 3), Fraction(-5, 3));
      });
      test('double all', () {
        for (var num = -10; num <= 10; num++) {
          for (var den = -10; den <= 10; den++) {
            if (den != 0) {
              expect(Fraction.fromDouble(num / den), Fraction(num, den));
            }
          }
        }
      });
      test('double error', () {
        expect(() => Fraction.fromDouble(double.nan), throwsArgumentError);
        expect(() => Fraction.fromDouble(double.infinity), throwsArgumentError);
        expect(() => Fraction.fromDouble(double.negativeInfinity),
            throwsArgumentError);
      });
      test('zero', () {
        expect(Fraction.zero, Fraction(0));
        expect(Fraction(1, 2) + Fraction.zero, Fraction(1, 2));
      });
      test('one', () {
        expect(Fraction.one, Fraction(1));
        expect(Fraction(1, 2) * Fraction.one, Fraction(1, 2));
      });
    });
    group('arithmetic', () {
      test('addition', () {
        expect(Fraction(1, 2) + Fraction(1, 4), Fraction(3, 4));
        expect(Fraction(1, 2) + Fraction(3, 4), Fraction(5, 4));
        expect(Fraction(1, 2) + Fraction(1, 2), Fraction(1));
      });
      test('substraction', () {
        expect(Fraction(1, 2) - Fraction(1, 4), Fraction(1, 4));
        expect(Fraction(1, 2) - Fraction(3, 4), Fraction(-1, 4));
        expect(Fraction(1, 2) - Fraction(1, 2), Fraction(0));
      });
      test('multiplication', () {
        expect(Fraction(2, 3) * Fraction(1, 4), Fraction(1, 6));
        expect(Fraction(3, 4) * Fraction(2, 5), Fraction(3, 10));
      });
      test('division', () {
        expect(Fraction(2, 3) / Fraction(1, 4), Fraction(8, 3));
        expect(Fraction(3, 4) / Fraction(2, 5), Fraction(15, 8));
      });
      test('negate', () {
        expect(-Fraction(2, 3), Fraction(-2, 3));
      });
      test('abs', () {
        expect(Fraction(-2, -3).abs(), Fraction(2, 3));
        expect(Fraction(-2, 3).abs(), Fraction(2, 3));
        expect(Fraction(2, -3).abs(), Fraction(2, 3));
        expect(Fraction(2, 3).abs(), Fraction(2, 3));
      });
      test('round', () {
        expect(Fraction(2, 3).round(), 1);
        expect(Fraction(-2, 3).round(), -1);
      });
      test('floor', () {
        expect(Fraction(2, 3).floor(), 0);
        expect(Fraction(-2, 3).floor(), -1);
      });
      test('ceil', () {
        expect(Fraction(2, 3).ceil(), 1);
        expect(Fraction(-2, 3).ceil(), 0);
      });
      test('truncate', () {
        expect(Fraction(2, 3).truncate(), 0);
        expect(Fraction(-5, 3).truncate(), -1);
      });
    });
    group('comparing', () {
      test('compareTo', () {
        expect(Fraction(2, 3).compareTo(Fraction(2, 3)), 1.compareTo(1));
        expect(Fraction(2, 3).compareTo(Fraction(4, 5)), 1.compareTo(2));
        expect(Fraction(4, 5).compareTo(Fraction(2, 3)), 2.compareTo(1));
      });
      test('hash code', () {
        expect(Fraction(2, 3).hashCode, isNot(Fraction(3, 2).hashCode));
      });
      test('<', () {
        expect(Fraction(2, 3) < Fraction(2, 3), isFalse);
        expect(Fraction(2, 3) < Fraction(4, 5), isTrue);
        expect(Fraction(4, 5) < Fraction(2, 3), isFalse);
      });
      test('<=', () {
        expect(Fraction(2, 3) <= Fraction(2, 3), isTrue);
        expect(Fraction(2, 3) <= Fraction(4, 5), isTrue);
        expect(Fraction(4, 5) <= Fraction(2, 3), isFalse);
      });
      test('>=', () {
        expect(Fraction(2, 3) >= Fraction(2, 3), isTrue);
        expect(Fraction(2, 3) >= Fraction(4, 5), isFalse);
        expect(Fraction(4, 5) >= Fraction(2, 3), isTrue);
      });
      test('>', () {
        expect(Fraction(2, 3) > Fraction(2, 3), isFalse);
        expect(Fraction(2, 3) > Fraction(4, 5), isFalse);
        expect(Fraction(4, 5) > Fraction(2, 3), isTrue);
      });
      test('==', () {
        expect(Fraction(2, 3) == Fraction(2, 3), isTrue);
        expect(Fraction(2, 3) == Fraction(4, 5), isFalse);
        expect(Fraction(4, 5) == Fraction(2, 3), isFalse);
      });
    });
    group('converting', () {
      test('toInt', () {
        expect(Fraction(1, 2).toInt(), 0);
        expect(Fraction(5, 4).toInt(), 1);
      });
      test('toDouble', () {
        expect(Fraction(1, 2).toDouble(), 0.5);
        expect(Fraction(5, 4).toDouble(), 1.25);
      });
      test('toString', () {
        expect(Fraction(1, 2).toString(), '1/2');
        expect(Fraction(5, 4).toString(), '5/4');
        expect(Fraction(6).toString(), '6');
        expect(Fraction(-6).toString(), '-6');
      });
    });
  });
}
