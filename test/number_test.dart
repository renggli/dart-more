library more.test.number_test;

import 'dart:math' as math;

import 'package:more/number.dart';
import 'package:test/test.dart';

void main() {
  const epsilon = 1e-5;
  group('complex', () {
    bool Function(Complex) isClose(num a, num b) =>
        (actual) => actual.closeTo(Complex(a, b), epsilon);
    group('construction', () {
      test('zero', () {
        const complex = Complex.zero;
        expect(complex.a, 0);
        expect(complex.b, 0);
        expect(complex.real, 0);
        expect(complex.imaginary, 0);
        expect(complex.abs(), 0.0);
        expect(complex.arg(), 0.0);
      });
      test('one', () {
        const complex = Complex.one;
        expect(complex.a, 1);
        expect(complex.b, 0);
        expect(complex.real, 1);
        expect(complex.imaginary, 0);
        expect(complex.abs(), 1.0);
        expect(complex.arg(), 0.0);
      });
      test('i', () {
        const complex = Complex.i;
        expect(complex.a, 0);
        expect(complex.b, 1);
        expect(complex.real, 0);
        expect(complex.imaginary, 1);
        expect(complex.abs(), 1.0);
        expect(complex.arg(), math.pi / 2);
      });
      test('fromReal', () {
        final complex = Complex.fromReal(123);
        expect(complex.a, 123);
        expect(complex.b, 0);
        expect(complex.real, 123);
        expect(complex.imaginary, 0);
        expect(complex.abs(), 123.0);
        expect(complex.arg(), 0.0);
      });
      test('fromImaginary', () {
        final complex = Complex.fromImaginary(123);
        expect(complex.a, 0);
        expect(complex.b, 123);
        expect(complex.real, 0);
        expect(complex.imaginary, 123);
        expect(complex.abs(), 123.0);
        expect(complex.arg(), math.pi / 2);
      });
      test('fromCartesian', () {
        const complex = Complex.fromCartesian(-3, 4);
        expect(complex.a, -3);
        expect(complex.b, 4);
        expect(complex.real, -3);
        expect(complex.imaginary, 4);
        expect(complex.abs(), 5.0);
        expect(complex.arg(), math.acos(4 / 5) + math.pi / 2);
      });
      test('fromPolar', () {
        final complex = Complex.fromPolar(math.sqrt(2), 3 * math.pi / 4);
        expect(complex.a.roundToDouble(), -1.0);
        expect(complex.b.roundToDouble(), 1.0);
        expect(complex.real.roundToDouble(), -1.0);
        expect(complex.imaginary.roundToDouble(), 1.0);
        expect(complex.abs(), math.sqrt(2));
        expect(complex.arg(), 3 * math.pi / 4);
      });
      test('tryParse', () {
        expect(Complex.tryParse('1+2i'), const Complex(1, 2));
        expect(Complex.tryParse('1-2i'), const Complex(1, -2));
        expect(Complex.tryParse('-1+2i'), const Complex(-1, 2));
        expect(Complex.tryParse('-1-2i'), const Complex(-1, -2));
      });
      test('tryParse (whitespace)', () {
        expect(Complex.tryParse('1 + 2i'), const Complex(1, 2));
        expect(Complex.tryParse('1 - 2i'), const Complex(1, -2));
        expect(Complex.tryParse(' - 1 + 2 i '), const Complex(-1, 2));
        expect(Complex.tryParse(' - 1 - 2 i '), const Complex(-1, -2));
      });
      test('tryParse (permutation)', () {
        expect(Complex.tryParse('2i+1'), const Complex(1, 2));
      });
      test('tryParse (real)', () {
        expect(Complex.tryParse('1'), const Complex(1));
        expect(Complex.tryParse('1.2'), const Complex(1.2));
        expect(Complex.tryParse('-1.2'), const Complex(-1.2));
        expect(Complex.tryParse('1.2e2'), const Complex(120));
        expect(Complex.tryParse('1.2e-2'), const Complex(0.012));
      });
      test('tryParse (imaginary)', () {
        expect(Complex.tryParse('i'), const Complex(0, 1));
        expect(Complex.tryParse('1I'), const Complex(0, 1));
        expect(Complex.tryParse('1.2i'), const Complex(0, 1.2));
        expect(Complex.tryParse('-1.2I'), const Complex(0, -1.2));
        expect(Complex.tryParse('1.2e2i'), const Complex(0, 120));
        expect(Complex.tryParse('1.2e-2I'), const Complex(0, 0.012));
        expect(Complex.tryParse('1*i'), const Complex(0, 1));
        expect(Complex.tryParse('1.2*I'), const Complex(0, 1.2));
        expect(Complex.tryParse('1.2e2*i'), const Complex(0, 120));
        expect(Complex.tryParse('1.2e-2*I'), const Complex(0, 0.012));
      });
      test('tryParse (error)', () {
        expect(Complex.tryParse(''), isNull);
        expect(Complex.tryParse('e1'), isNull);
        expect(Complex.tryParse('1ii'), isNull);
        expect(Complex.tryParse('1+1'), isNull);
        expect(Complex.tryParse('i+i'), isNull);
        expect(Complex.tryParse('i+j'), isNull);
      });
    });
    group('arithmetic', () {
      test('addition', () {
        expect(
            const Complex(1, -2) + const Complex(-3, 4), const Complex(-2, 2));
        expect(const Complex(1, -2) + 3, const Complex(4, -2));
        expect(() => const Complex(1, -2) + 'foo', throwsArgumentError);
      });
      test('subtraction', () {
        expect(
            const Complex(1, -2) - const Complex(-3, 4), const Complex(4, -6));
        expect(const Complex(1, -2) - 4, const Complex(-3, -2));
        expect(() => const Complex(1, -2) - 'foo', throwsArgumentError);
      });
      test('multiplication', () {
        expect(
            const Complex(1, -2) * const Complex(-3, 4), const Complex(5, 10));
        expect(
            const Complex(-3, 4) * const Complex(1, -2), const Complex(5, 10));
        expect(const Complex(-3, 4) * 2, const Complex(-6, 8));
        expect(() => const Complex(-3, 4) * 'foo', throwsArgumentError);
      });
      test('division', () {
        expect(
            const Complex(5, 10) / const Complex(-3, 4), const Complex(1, -2));
        expect(
            const Complex(5, 10) / const Complex(1, -2), const Complex(-3, 4));
        expect(const Complex(6, 10) / 2, const Complex(3, 5));
        expect(() => const Complex(6, 10) / 'foo', throwsArgumentError);
      });
      test('negate', () {
        expect(-const Complex(1, -2), const Complex(-1, 2));
      });
      test('conjugate', () {
        expect(const Complex(1, -2).conjugate(), const Complex(1, 2));
      });
      test('reciprocal', () {
        expect(const Complex(1, -2).reciprocal(), const Complex(0.2, 0.4));
      });
      test('exp', () {
        expect(const Complex(1, 2).exp(), isClose(-1.131204, 2.471726));
      });
      test('log', () {
        expect(const Complex(1, 2).log(), isClose(0.804718, 1.107148));
      });
      test('pow', () {
        expect(const Complex(1, 2).pow(const Complex(3, 4)),
            isClose(0.129009, 0.033924));
      });
      test('square', () {
        expect(const Complex(2, 3).square(), const Complex(-5, 12));
        expect(const Complex(-2, 3).square(), const Complex(-5, -12));
        expect(const Complex(2, -3).square(), const Complex(-5, -12));
        expect(const Complex(-2, -3).square(), const Complex(-5, 12));
      });
      test('sqrt', () {
        expect(const Complex(2, 3).sqrt(), isClose(1.674149, 0.895977));
        expect(const Complex(-2, 3).sqrt(), isClose(0.895977, 1.674149));
        expect(const Complex(2, -3).sqrt(), isClose(1.674149, -0.895977));
        expect(const Complex(-2, -3).sqrt(), isClose(0.895977, -1.674149));
        expect(const Complex(2, 3).sqrt().square(), isClose(2, 3));
      });
      group('roots', () {
        const source = Complex(2, 3);
        void testRoots(int n) {
          test('$source.roots($n)', () {
            final roots = source.roots(n);
            expect(roots, hasLength(n.abs()));
            for (final root in roots) {
              expect(root.pow(n), isClose(source.a, source.b));
            }
          });
        }

        testRoots(-4);
        testRoots(-3);
        testRoots(-2);
        testRoots(-1);
        test('$source.root(0)', () {
          expect(() => source.roots(0), throwsArgumentError);
        });
        testRoots(1);
        testRoots(2);
        testRoots(3);
        testRoots(4);
        testRoots(5);
        testRoots(6);
      });
      test('sin', () {
        expect(const Complex(2, 3).sin(), isClose(9.154499, 4.168906));
      });
      test('asin', () {
        expect(const Complex(2, 3).asin(), isClose(0.570652, 1.983387));
      });
      test('sinh', () {
        expect(const Complex(2, 3).sinh(), isClose(-3.590564, 0.530921));
      });
      test('asinh', () {
        expect(const Complex(2, 3).asinh(), isClose(1.968637, 0.964658));
      });
      test('cos', () {
        expect(const Complex(2, 3).cos(), isClose(-4.189625, -9.109227));
      });
      test('acos', () {
        expect(const Complex(2, 3).acos(), isClose(1.000143, -1.983387));
      });
      test('cosh', () {
        expect(const Complex(2, 3).cosh(), isClose(-3.724545, 0.511822));
      });
      test('acosh', () {
        expect(const Complex(2, 3).acosh(), isClose(1.983387, 1.000143));
      });
      test('tan', () {
        expect(const Complex(2, 3).tan(), isClose(-0.003764, 1.003238));
      });
      test('atan', () {
        expect(const Complex(2, 3).atan(), isClose(1.409921, 0.229072));
      });
      test('tanh', () {
        expect(const Complex(2, 3).tanh(), isClose(0.965385, -0.009884));
      });
      test('atanh', () {
        expect(const Complex(2, 3).atanh(), isClose(0.146946, 1.338972));
      });
    });
    group('testing', () {
      test('isNan', () {
        expect(const Complex(0, 0).isNaN, isFalse);
        expect(const Complex(0, double.nan).isNaN, isTrue);
        expect(const Complex(double.nan, 0).isNaN, isTrue);
        expect(const Complex(double.nan, double.nan).isNaN, isTrue);
      });
      test('isInfinite', () {
        expect(const Complex(0, 0).isInfinite, isFalse);
        expect(const Complex(0, double.infinity).isInfinite, isTrue);
        expect(const Complex(double.infinity, 0).isInfinite, isTrue);
        expect(
            const Complex(double.infinity, double.infinity).isInfinite, isTrue);
      });
    });
    group('converting', () {
      test('round', () {
        expect(const Complex(2.7, 1.2).round(), const Complex(3, 1));
      });
      test('floor', () {
        expect(const Complex(2.7, 1.2).floor(), const Complex(2, 1));
      });
      test('ceil', () {
        expect(const Complex(2.7, 1.2).ceil(), const Complex(3, 2));
      });
      test('truncate', () {
        expect(const Complex(2.7, 1.2).truncate(), const Complex(2, 1));
      });
      test('toString', () {
        expect(Complex.zero.toString(), 'Complex(0, 0)');
        expect(Complex.one.toString(), 'Complex(1, 0)');
        expect(Complex.i.toString(), 'Complex(0, 1)');
        expect(const Complex(1, 2).toString(), 'Complex(1, 2)');
        expect(const Complex(-3, -4).toString(), 'Complex(-3, -4)');
      });
    });
    group('comparing', () {
      test('close', () {
        expect(
          Complex.fromPolar(math.e, math.pi / 2)
              .closeTo(const Complex(0, 0), 0.1),
          isFalse,
        );
        expect(
          Complex.fromPolar(math.e, math.pi / 2)
              .closeTo(const Complex(0, 2.71), 0.1),
          isTrue,
        );
      });
      test('equal', () {
        expect(const Complex(2, 3) == const Complex(2, 3), isTrue);
        expect(const Complex(2, 3) == const Complex(3, 2), isFalse);
        expect(const Complex(2, 3) == const Complex(2, 4), isFalse);
      });
      test('hash', () {
        expect(const Complex(2, 3).hashCode, const Complex(2, 3).hashCode);
        expect(
            const Complex(2, 3).hashCode, isNot(const Complex(3, 2).hashCode));
      });
    });
  });
  group('fraction', () {
    group('construction', () {
      test('irreducible', () {
        final fraction = Fraction(3, 7);
        expect(fraction.a, 3);
        expect(fraction.b, 7);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('reducible', () {
        final fraction = Fraction(15, 35);
        expect(fraction.a, 3);
        expect(fraction.b, 7);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('normal negative', () {
        final fraction = Fraction(-2, 4);
        expect(fraction.a, -1);
        expect(fraction.b, 2);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('double negative', () {
        final fraction = Fraction(-2, -4);
        expect(fraction.a, 1);
        expect(fraction.b, 2);
        expect(fraction.numerator, 1);
        expect(fraction.denominator, 2);
      });
      test('denominator negative', () {
        final fraction = Fraction(2, -4);
        expect(fraction.a, -1);
        expect(fraction.b, 2);
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
      group('fromDouble', () {
        test('basic', () {
          expect(Fraction.fromDouble(2), Fraction(2));
          expect(Fraction.fromDouble(100), Fraction(100));
        });
        test('finite', () {
          expect(Fraction.fromDouble(1 / 2), Fraction(1, 2));
          expect(Fraction.fromDouble(1 / 4), Fraction(1, 4));
        });
        test('finite, whole', () {
          expect(Fraction.fromDouble(5 / 2), Fraction(5, 2));
          expect(Fraction.fromDouble(9 / 4), Fraction(9, 4));
        });
        test('infinite', () {
          expect(Fraction.fromDouble(1 / 3), Fraction(1, 3));
          expect(Fraction.fromDouble(1 / 7), Fraction(1, 7));
        });
        test('infinite, whole', () {
          expect(Fraction.fromDouble(5 / 3), Fraction(5, 3));
          expect(Fraction.fromDouble(9 / 7), Fraction(9, 7));
        });
        test('negative', () {
          expect(Fraction.fromDouble(-1 / 3), Fraction(-1, 3));
          expect(Fraction.fromDouble(-5 / 3), Fraction(-5, 3));
        });
        test('all', () {
          for (var num = -10; num <= 10; num++) {
            for (var den = -10; den <= 10; den++) {
              if (den != 0) {
                expect(Fraction.fromDouble(num / den), Fraction(num, den));
              }
            }
          }
        });
        test('error', () {
          expect(() => Fraction.fromDouble(double.nan), throwsArgumentError);
          expect(
              () => Fraction.fromDouble(double.infinity), throwsArgumentError);
          expect(() => Fraction.fromDouble(double.negativeInfinity),
              throwsArgumentError);
        });
      });
      test('zero', () {
        expect(Fraction.zero, Fraction(0));
        expect(Fraction(1, 2) + Fraction.zero, Fraction(1, 2));
      });
      test('one', () {
        expect(Fraction.one, Fraction(1));
        expect(Fraction(1, 2) * Fraction.one, Fraction(1, 2));
      });
      group('tryParse', () {
        test('basic', () {
          expect(Fraction.tryParse('1/2'), Fraction(1, 2));
          expect(Fraction.tryParse(' 1/2'), Fraction(1, 2));
          expect(Fraction.tryParse('1 /2'), Fraction(1, 2));
          expect(Fraction.tryParse('1/ 2'), Fraction(1, 2));
          expect(Fraction.tryParse('1/2 '), Fraction(1, 2));
        });
        test('negative', () {
          expect(Fraction.tryParse('-1/2'), Fraction(-1, 2));
          expect(Fraction.tryParse('1/-2'), Fraction(-1, 2));
          expect(Fraction.tryParse('-1/-2'), Fraction(1, 2));
        });
        test('integer', () {
          expect(Fraction.tryParse('3'), Fraction(3));
          expect(Fraction.tryParse(' 3'), Fraction(3));
          expect(Fraction.tryParse('3 '), Fraction(3));
        });
        test('error', () {
          expect(Fraction.tryParse(''), isNull);
          expect(Fraction.tryParse('1.23'), isNull);
          expect(Fraction.tryParse('1/2/3'), isNull);
        });
      });
      group('positive', () {
        test('basic', () {
          final fractions = Fraction.positive.take(15);
          expect(fractions, [
            Fraction(1, 1),
            Fraction(1, 2),
            Fraction(2, 1),
            Fraction(1, 3),
            Fraction(3, 2),
            Fraction(2, 3),
            Fraction(3, 1),
            Fraction(1, 4),
            Fraction(4, 3),
            Fraction(3, 5),
            Fraction(5, 2),
            Fraction(2, 5),
            Fraction(5, 3),
            Fraction(3, 4),
            Fraction(4, 1),
          ]);
        });
        test('irreducible', () {
          final fractions = Fraction.positive.take(100000);
          for (final fraction in fractions) {
            expect(fraction.a.gcd(fraction.b), 1);
          }
        });
        test('unique', () {
          final seen = <Fraction>{};
          final fractions = Fraction.positive.take(100000);
          for (final fraction in fractions) {
            expect(seen.add(fraction), isTrue);
          }
        });
      });
    });
    group('testing', () {
      test('isNan', () {
        expect(Fraction(0, 1).isNaN, isFalse);
      });
      test('isInfinite', () {
        expect(Fraction(0, 1).isInfinite, isFalse);
      });
      test('isNegative', () {
        expect(Fraction(1, 1).isNegative, isFalse);
        expect(Fraction(-1, 1).isNegative, isTrue);
        expect(Fraction(1, -1).isNegative, isTrue);
        expect(Fraction(-1, -1).isNegative, isFalse);
      });
    });
    group('arithmetic', () {
      test('addition', () {
        expect(Fraction(1, 2) + Fraction(1, 4), Fraction(3, 4));
        expect(Fraction(1, 2) + Fraction(3, 4), Fraction(5, 4));
        expect(Fraction(1, 2) + Fraction(1, 2), Fraction(1));
        expect(Fraction(1, 2) + 3, Fraction(7, 2));
        expect(() => Fraction(1, 2) + 'foo', throwsArgumentError);
      });
      test('subtraction', () {
        expect(Fraction(1, 2) - Fraction(1, 4), Fraction(1, 4));
        expect(Fraction(1, 2) - Fraction(3, 4), Fraction(-1, 4));
        expect(Fraction(1, 2) - Fraction(1, 2), Fraction(0));
        expect(Fraction(1, 2) - 3, Fraction(-5, 2));
        expect(() => Fraction(1, 2) - 'foo', throwsArgumentError);
      });
      test('multiplication', () {
        expect(Fraction(2, 3) * Fraction(1, 4), Fraction(1, 6));
        expect(Fraction(3, 4) * Fraction(2, 5), Fraction(3, 10));
        expect(Fraction(3, 4) * 2, Fraction(3, 2));
        expect(() => Fraction(3, 4) * 'foo', throwsArgumentError);
      });
      test('reciprocal', () {
        expect(Fraction(3, 4).reciprocal(), Fraction(4, 3));
        expect(Fraction(-3, 4).reciprocal(), Fraction(-4, 3));
      });
      test('division', () {
        expect(Fraction(2, 3) / Fraction(1, 4), Fraction(8, 3));
        expect(Fraction(3, 4) / Fraction(2, 5), Fraction(15, 8));
        expect(Fraction(3, 4) / 2, Fraction(3, 8));
        expect(() => Fraction(3, 4) / 'foo', throwsArgumentError);
      });
      test('negate', () {
        expect(-Fraction(2, 3), Fraction(-2, 3));
      });
      test('pow', () {
        expect(Fraction.zero.pow(2), Fraction.zero);
        expect(Fraction(2, 3).pow(0), Fraction.one);
        expect(Fraction(2, 3).pow(2), Fraction(4, 9));
        expect(Fraction(2, 3).pow(-2), Fraction(9, 4));
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
      test('close', () {
        expect(Fraction(1, 2).closeTo(Fraction(1, 3), 0.1), isFalse);
        expect(Fraction(1, 2).closeTo(Fraction(2, 4), 0.1), isTrue);
        expect(Fraction(1, 2).closeTo(Fraction(3, 5), 0.2), isTrue);
      });
      test('equals', () {
        expect(Fraction(2, 3).compareTo(Fraction(2, 3)), 1.compareTo(1));
        expect(Fraction(2, 3).compareTo(Fraction(4, 5)), 1.compareTo(2));
        expect(Fraction(4, 5).compareTo(Fraction(2, 3)), 2.compareTo(1));
      });
      test('hash', () {
        expect(Fraction(2, 3).hashCode, Fraction(2, 3).hashCode);
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
        expect(Fraction(1, 2).toString(), 'Fraction(1, 2)');
        expect(Fraction(5, 4).toString(), 'Fraction(5, 4)');
        expect(Fraction(6).toString(), 'Fraction(6, 1)');
        expect(Fraction(-6).toString(), 'Fraction(-6, 1)');
      });
    });
  });
  group('quaternion', () {
    bool Function(Quaternion) isClose(num a, num b, num c, num d) =>
        (actual) => actual.closeTo(Quaternion(a, b, c, d), epsilon);
    group('construction', () {
      test('zero', () {
        const quaternion = Quaternion.zero;
        expect(quaternion.w, 0);
        expect(quaternion.x, 0);
        expect(quaternion.y, 0);
        expect(quaternion.z, 0);
        expect(quaternion.abs(), 0.0);
      });
      test('one', () {
        const quaternion = Quaternion.one;
        expect(quaternion.w, 1);
        expect(quaternion.x, 0);
        expect(quaternion.y, 0);
        expect(quaternion.z, 0);
        expect(quaternion.abs(), 1.0);
      });
      test('i', () {
        const quaternion = Quaternion.i;
        expect(quaternion.w, 0);
        expect(quaternion.x, 1);
        expect(quaternion.y, 0);
        expect(quaternion.z, 0);
        expect(quaternion.abs(), 1.0);
      });
      test('j', () {
        const quaternion = Quaternion.j;
        expect(quaternion.w, 0);
        expect(quaternion.x, 0);
        expect(quaternion.y, 1);
        expect(quaternion.z, 0);
        expect(quaternion.abs(), 1.0);
      });
      test('k', () {
        const quaternion = Quaternion.k;
        expect(quaternion.w, 0);
        expect(quaternion.x, 0);
        expect(quaternion.y, 0);
        expect(quaternion.z, 1);
        expect(quaternion.abs(), 1.0);
      });
      test('components', () {
        const quaternion = Quaternion(1, 2, 3, 4);
        expect(quaternion.w, 1);
        expect(quaternion.x, 2);
        expect(quaternion.y, 3);
        expect(quaternion.z, 4);
        expect(quaternion.abs(), closeTo(5.477225, epsilon));
      });
      test('of', () {
        final quaternion = Quaternion.of(1, const [2, 3, 4]);
        expect(quaternion.w, 1);
        expect(quaternion.x, 2);
        expect(quaternion.y, 3);
        expect(quaternion.z, 4);
        expect(quaternion.abs(), closeTo(5.477225, epsilon));
      });
      test('fromList', () {
        final quaternion = Quaternion.fromList(const [1, 2, 3, 4]);
        expect(quaternion.w, 1);
        expect(quaternion.x, 2);
        expect(quaternion.y, 3);
        expect(quaternion.z, 4);
        expect(quaternion.abs(), closeTo(5.477225, epsilon));
      });
      test('fromAxis', () {
        final quaternion = Quaternion.fromAxis(const [1, 2, 3], 4.0);
        expect(quaternion, isClose(-0.416146, 0.243019, 0.486039, 0.729059));
        expect(quaternion.abs(), closeTo(1.0, epsilon));
      });
      test('fromVectors', () {
        final quaternion =
            Quaternion.fromVectors(const [1, 2, 3], const [4, 5, 6]);
        expect(quaternion, isClose(0.993637, -0.045978, 0.091956, -0.045978));
        expect(quaternion.abs(), closeTo(1.0, epsilon));
      });
      test('fromEuler', () {
        final quaternion = Quaternion.fromEuler(1, 2, 3);
        expect(quaternion, isClose(-0.368871, -0.206149, 0.501509, 0.754933));
        expect(quaternion.abs(), closeTo(1.0, epsilon));
      });
      test('tryParse', () {
        expect(Quaternion.tryParse('1+2i+3j+4k'), const Quaternion(1, 2, 3, 4));
        expect(
            Quaternion.tryParse('1-2i+3j-4k'), const Quaternion(1, -2, 3, -4));
        expect(
            Quaternion.tryParse('-1+2i-3j+4k'), const Quaternion(-1, 2, -3, 4));
        expect(Quaternion.tryParse('-1-2i-3j-4k'),
            const Quaternion(-1, -2, -3, -4));
      });
      test('tryParse (permutation)', () {
        expect(Quaternion.tryParse('1+2i+3j+4k'), const Quaternion(1, 2, 3, 4));
        expect(Quaternion.tryParse('2i+1+3j+4k'), const Quaternion(1, 2, 3, 4));
        expect(Quaternion.tryParse('4k+2i+3j+1'), const Quaternion(1, 2, 3, 4));
        expect(Quaternion.tryParse('3j+4k+2i+1'), const Quaternion(1, 2, 3, 4));
      });
      test('tryParse (whitespace)', () {
        expect(Quaternion.tryParse('1 + 2i + 3j + 4k'),
            const Quaternion(1, 2, 3, 4));
        expect(Quaternion.tryParse(' 1 - 2i + 3j - 4k '),
            const Quaternion(1, -2, 3, -4));
      });
      test('tryParse (real)', () {
        expect(Quaternion.tryParse('1'), const Quaternion(1));
        expect(Quaternion.tryParse('1.2'), const Quaternion(1.2));
        expect(Quaternion.tryParse('-1.2'), const Quaternion(-1.2));
        expect(Quaternion.tryParse('1.2e2'), const Quaternion(120));
        expect(Quaternion.tryParse('1.2e-2'), const Quaternion(0.012));
      });
      test('tryParse (vector)', () {
        expect(Quaternion.tryParse('i'), const Quaternion(0, 1));
        expect(Quaternion.tryParse('j'), const Quaternion(0, 0, 1));
        expect(Quaternion.tryParse('k'), const Quaternion(0, 0, 0, 1));
        expect(Quaternion.tryParse('1.2I'), const Quaternion(0, 1.2));
        expect(Quaternion.tryParse('1.2J'), const Quaternion(0, 0, 1.2));
        expect(Quaternion.tryParse('1.2K'), const Quaternion(0, 0, 0, 1.2));
        expect(Quaternion.tryParse('1.2e2i'), const Quaternion(0, 120));
        expect(Quaternion.tryParse('1.2e2j'), const Quaternion(0, 0, 120));
        expect(Quaternion.tryParse('1.2e2k'), const Quaternion(0, 0, 0, 120));
        expect(Quaternion.tryParse('-1.2e-2i'), const Quaternion(0, -0.012));
        expect(Quaternion.tryParse('-1.2e-2j'), const Quaternion(0, 0, -0.012));
        expect(
            Quaternion.tryParse('-1.2e-2k'), const Quaternion(0, 0, 0, -0.012));
      });
      test('tryParse (error)', () {
        expect(Quaternion.tryParse(''), isNull);
        expect(Quaternion.tryParse('e1'), isNull);
        expect(Quaternion.tryParse('1ii'), isNull);
        expect(Quaternion.tryParse('1+1'), isNull);
        expect(Quaternion.tryParse('i+i'), isNull);
        expect(Quaternion.tryParse('j+j'), isNull);
        expect(Quaternion.tryParse('k+k'), isNull);
      });
    });
    group('arithmetic', () {
      test('addition', () {
        expect(const Quaternion(1, -2, 3, -4) + const Quaternion(5, 6, -7, -8),
            const Quaternion(6, 4, -4, -12));
        expect(
            const Quaternion(1, -2, 3, -4) + 5, const Quaternion(6, -2, 3, -4));
        expect(
            () => const Quaternion(1, -2, 3, -4) + 'foo', throwsArgumentError);
      });
      test('subtraction', () {
        expect(const Quaternion(1, -2, 3, -4) - const Quaternion(5, 6, -7, -8),
            const Quaternion(-4, -8, 10, 4));
        expect(const Quaternion(1, -2, 3, -4) - 5,
            const Quaternion(-4, -2, 3, -4));
        expect(
            () => const Quaternion(1, -2, 3, -4) - 'foo', throwsArgumentError);
      });
      test('multiplication', () {
        expect(const Quaternion(1, -2, 3, -4) * const Quaternion(5, 6, -7, -8),
            const Quaternion(6, -56, -32, -32));
        expect(const Quaternion(1, -2, 3, -4) * 5,
            const Quaternion(5, -10, 15, -20));
        expect(
            () => const Quaternion(5, 6, -7, -8) * 'foo', throwsArgumentError);
      });
      test('division', () {
        expect(const Quaternion(1, -2, 3, -4) / const Quaternion(5, 6, -7, -8),
            isClose(0.133333, 1.200000, 2.066666, -0.266666));
        expect(const Quaternion(5, 6, -7, -8) / const Quaternion(1, -2, 3, -4),
            isClose(0.022988, -0.206896, -0.356321, 0.045977));
        expect(const Quaternion(6, 4, -8, -16) / 2,
            const Quaternion(3, 2, -4, -8));
        expect(
            () => const Quaternion(6, 4, -8, -16) / 'foo', throwsArgumentError);
      });
      test('negate', () {
        expect(-const Quaternion(1, -2, 3, -4), const Quaternion(-1, 2, -3, 4));
      });
      test('conjugate', () {
        expect(const Quaternion(1, -2, 3, -4).conjugate(),
            const Quaternion(1, 2, -3, 4));
      });
      test('reciprocal', () {
        expect(const Quaternion(1, -2, 3, -4).reciprocal(),
            isClose(0.033333, 0.066666, -0.100000, 0.133333));
      });
      test('exp', () {
        expect(const Quaternion(1, -2, 3, -4).exp(),
            isClose(1.693922, 0.789559, -1.184339, 1.579119));
      });
      test('log', () {
        expect(const Quaternion(1, -2, 3, -4).log(),
            isClose(1.700598, -0.515190, 0.772785, -1.030380));
      });
      test('pow', () {
        expect(
            const Quaternion(1, -2, 3, -4).pow(const Quaternion(5, 6, -7, -8)),
            isClose(-4948.167788, -841.118989, -2675.346637, -2885.798013));
      });
    });
    group('testing', () {
      test('isNan', () {
        expect(const Quaternion(1, 2, 3, 4).isNaN, isFalse);
        expect(const Quaternion(double.nan, 2, 3, 4).isNaN, isTrue);
        expect(const Quaternion(1, double.nan, 3, 4).isNaN, isTrue);
        expect(const Quaternion(1, 2, double.nan, 4).isNaN, isTrue);
        expect(const Quaternion(1, 2, 3, double.nan).isNaN, isTrue);
      });
      test('isInfinite', () {
        expect(const Quaternion(1, 2, 3, 4).isInfinite, isFalse);
        expect(const Quaternion(double.infinity, 2, 3, 4).isInfinite, isTrue);
        expect(const Quaternion(1, double.negativeInfinity, 3, 4).isInfinite,
            isTrue);
        expect(const Quaternion(1, 2, double.infinity, 4).isInfinite, isTrue);
        expect(const Quaternion(1, 2, 3, double.negativeInfinity).isInfinite,
            isTrue);
      });
    });
    group('converting', () {
      test('round', () {
        expect(const Quaternion(1.7, 3.2, -2.7, -4.2).round(),
            const Quaternion(2, 3, -3, -4));
      });
      test('floor', () {
        expect(const Quaternion(1.7, 3.2, -2.7, -4.2).floor(),
            const Quaternion(1, 3, -3, -5));
      });
      test('ceil', () {
        expect(const Quaternion(1.7, 3.2, -2.7, -4.2).ceil(),
            const Quaternion(2, 4, -2, -4));
      });
      test('truncate', () {
        expect(const Quaternion(1.7, 3.2, -2.7, -4.2).truncate(),
            const Quaternion(1, 3, -2, -4));
      });
      test('toString', () {
        expect(Quaternion.zero.toString(), 'Quaternion(0, 0, 0, 0)');
        expect(Quaternion.one.toString(), 'Quaternion(1, 0, 0, 0)');
        expect(Quaternion.i.toString(), 'Quaternion(0, 1, 0, 0)');
        expect(Quaternion.j.toString(), 'Quaternion(0, 0, 1, 0)');
        expect(Quaternion.k.toString(), 'Quaternion(0, 0, 0, 1)');
        expect(
            const Quaternion(0, 2, 4, 6).toString(), 'Quaternion(0, 2, 4, 6)');
        expect(const Quaternion(1, -1, 2, -3).toString(),
            'Quaternion(1, -1, 2, -3)');
      });
    });
    group('comparing', () {
      test('equal', () {
        expect(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 3, 4, 5),
            isTrue);
        expect(const Quaternion(2, 3, 4, 5) == const Quaternion(1, 3, 4, 5),
            isFalse);
        expect(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 4, 4, 5),
            isFalse);
        expect(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 3, 3, 5),
            isFalse);
        expect(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 3, 4, 6),
            isFalse);
      });
      test('hash', () {
        expect(const Quaternion(2, 3, 4, 5).hashCode,
            const Quaternion(2, 3, 4, 5).hashCode);
        expect(const Quaternion(2, 3, 4, 5).hashCode,
            isNot(const Quaternion(3, 2, 4, 5).hashCode));
        expect(const Quaternion(2, 3, 4, 5).hashCode,
            isNot(const Quaternion(2, 4, 3, 5).hashCode));
        expect(const Quaternion(2, 3, 4, 5).hashCode,
            isNot(const Quaternion(2, 3, 5, 4).hashCode));
      });
    });
  });
}
