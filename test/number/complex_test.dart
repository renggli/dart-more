import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('Complex', () {
    group('construction', () {
      test('zero', () {
        const complex = Complex.zero;
        check(complex)
          ..a.equals(0)
          ..b.equals(0)
          ..real.equals(0)
          ..imaginary.equals(0);
        check(complex.abs()).equals(0.0);
        check(complex.arg()).equals(0.0);
      });
      test('one', () {
        const complex = Complex.one;
        check(complex)
          ..a.equals(1)
          ..b.equals(0)
          ..real.equals(1)
          ..imaginary.equals(0);
        check(complex.abs()).equals(1.0);
        check(complex.arg()).equals(0.0);
      });
      test('i', () {
        const complex = Complex.i;
        check(complex)
          ..a.equals(0)
          ..b.equals(1)
          ..real.equals(0)
          ..imaginary.equals(1);
        check(complex.abs()).equals(1.0);
        check(complex.arg()).equals(math.pi / 2);
      });
      test('fromReal', () {
        final complex = Complex.fromReal(123);
        check(complex)
          ..a.equals(123)
          ..b.equals(0)
          ..real.equals(123)
          ..imaginary.equals(0);
        check(complex.abs()).equals(123.0);
        check(complex.arg()).equals(0.0);
      });
      test('fromImaginary', () {
        final complex = Complex.fromImaginary(123);
        check(complex.a).equals(0);
        check(complex.b).equals(123);
        check(complex.real).equals(0);
        check(complex.imaginary).equals(123);
        check(complex.abs()).equals(123.0);
        check(complex.arg()).equals(math.pi / 2);
      });
      test('fromCartesian', () {
        const complex = Complex.fromCartesian(-3, 4);
        check(complex.a).equals(-3);
        check(complex.b).equals(4);
        check(complex.real).equals(-3);
        check(complex.imaginary).equals(4);
        check(complex.abs()).equals(5.0);
        check(complex.arg()).equals(math.acos(4 / 5) + math.pi / 2);
      });
      test('fromPolar', () {
        final complex = Complex.fromPolar(math.sqrt(2), 3 * math.pi / 4);
        check(complex.a.roundToDouble()).equals(-1.0);
        check(complex.b.roundToDouble()).equals(1.0);
        check(complex.real.roundToDouble()).equals(-1.0);
        check(complex.imaginary.roundToDouble()).equals(1.0);
        check(complex.abs()).equals(math.sqrt(2));
        check(complex.arg()).equals(3 * math.pi / 4);
      });
      test('parse', () {
        check(Complex.parse('1+2i')).equals(const Complex(1, 2));
        check(Complex.parse('1-2i')).equals(const Complex(1, -2));
        check(Complex.parse('-1+2i')).equals(const Complex(-1, 2));
        check(Complex.parse('-1-2i')).equals(const Complex(-1, -2));
      });
      test('parse (whitespace)', () {
        check(Complex.parse('1 + 2i')).equals(const Complex(1, 2));
        check(Complex.parse('1 - 2i')).equals(const Complex(1, -2));
        check(Complex.parse(' - 1 + 2 i ')).equals(const Complex(-1, 2));
        check(Complex.parse(' - 1 - 2 i ')).equals(const Complex(-1, -2));
      });
      test('parse (permutation)', () {
        check(Complex.parse('2i+1')).equals(const Complex(1, 2));
      });
      test('parse (real)', () {
        check(Complex.parse('1')).equals(Complex.one);
        check(Complex.parse('+1')).equals(Complex.one);
        check(Complex.parse('-1')).equals(-Complex.one);
        check(Complex.parse('1.2')).equals(const Complex(1.2));
        check(Complex.parse('-1.2')).equals(const Complex(-1.2));
        check(Complex.parse('1.2e2')).equals(const Complex(120));
        check(Complex.parse('1.2e-2')).equals(const Complex(0.012));
      });
      test('parse (imaginary)', () {
        check(Complex.parse('i')).equals(Complex.i);
        check(Complex.parse('+i')).equals(Complex.i);
        check(Complex.parse('-i')).equals(-Complex.i);
        check(Complex.parse('1I')).equals(Complex.i);
        check(Complex.parse('1.2i')).equals(const Complex(0, 1.2));
        check(Complex.parse('-1.2I')).equals(const Complex(0, -1.2));
        check(Complex.parse('1.2e2i')).equals(const Complex(0, 120));
        check(Complex.parse('1.2e-2I')).equals(const Complex(0, 0.012));
        check(Complex.parse('1*i')).equals(Complex.i);
        check(Complex.parse('1.2*I')).equals(const Complex(0, 1.2));
        check(Complex.parse('1.2e2*i')).equals(const Complex(0, 120));
        check(Complex.parse('1.2e-2*I')).equals(const Complex(0, 0.012));
      });
      test('parse (error)', () {
        check(() => Complex.parse('')).throws<FormatException>();
        check(() => Complex.parse('e1')).throws<FormatException>();
        check(() => Complex.parse('1ii')).throws<FormatException>();
        check(() => Complex.parse('1+1')).throws<FormatException>();
        check(() => Complex.parse('i+i')).throws<FormatException>();
        check(() => Complex.parse('i+j')).throws<FormatException>();
      });
      test('tryParse', () {
        check(Complex.tryParse('1+2i')).equals(const Complex(1, 2));
        check(Complex.tryParse('1-2i')).equals(const Complex(1, -2));
        check(Complex.tryParse('-1+2i')).equals(const Complex(-1, 2));
        check(Complex.tryParse('-1-2i')).equals(const Complex(-1, -2));
      });
      test('tryParse (whitespace)', () {
        check(Complex.tryParse('1 + 2i')).equals(const Complex(1, 2));
        check(Complex.tryParse('1 - 2i')).equals(const Complex(1, -2));
        check(Complex.tryParse(' - 1 + 2 i ')).equals(const Complex(-1, 2));
        check(Complex.tryParse(' - 1 - 2 i ')).equals(const Complex(-1, -2));
      });
      test('tryParse (permutation)', () {
        check(Complex.tryParse('2i+1')).equals(const Complex(1, 2));
      });
      test('tryParse (real)', () {
        check(Complex.tryParse('1')).equals(Complex.one);
        check(Complex.tryParse('+1')).equals(Complex.one);
        check(Complex.tryParse('-1')).equals(-Complex.one);
        check(Complex.tryParse('1.2')).equals(const Complex(1.2));
        check(Complex.tryParse('-1.2')).equals(const Complex(-1.2));
        check(Complex.tryParse('1.2e2')).equals(const Complex(120));
        check(Complex.tryParse('1.2e-2')).equals(const Complex(0.012));
      });
      test('tryParse (imaginary)', () {
        check(Complex.tryParse('i')).equals(Complex.i);
        check(Complex.tryParse('+i')).equals(Complex.i);
        check(Complex.tryParse('-i')).equals(-Complex.i);
        check(Complex.tryParse('1I')).equals(Complex.i);
        check(Complex.tryParse('1.2i')).equals(const Complex(0, 1.2));
        check(Complex.tryParse('-1.2I')).equals(const Complex(0, -1.2));
        check(Complex.tryParse('1.2e2i')).equals(const Complex(0, 120));
        check(Complex.tryParse('1.2e-2I')).equals(const Complex(0, 0.012));
        check(Complex.tryParse('1*i')).equals(Complex.i);
        check(Complex.tryParse('1.2*I')).equals(const Complex(0, 1.2));
        check(Complex.tryParse('1.2e2*i')).equals(const Complex(0, 120));
        check(Complex.tryParse('1.2e-2*I')).equals(const Complex(0, 0.012));
      });
      test('tryParse (error)', () {
        check(Complex.tryParse('')).isNull();
        check(Complex.tryParse('e1')).isNull();
        check(Complex.tryParse('1ii')).isNull();
        check(Complex.tryParse('1+1')).isNull();
        check(Complex.tryParse('i+i')).isNull();
        check(Complex.tryParse('i+j')).isNull();
      });
    });
    group('arithmetic', () {
      test('addition', () {
        check(const Complex(1, -2) + const Complex(-3, 4))
            .equals(const Complex(-2, 2));
        check(const Complex(1, -2) + 3).equals(const Complex(4, -2));
        check(() => const Complex(1, -2) + 'foo').throws<ArgumentError>();
      });
      test('subtraction', () {
        check(const Complex(1, -2) - const Complex(-3, 4))
            .equals(const Complex(4, -6));
        check(const Complex(1, -2) - 4).equals(const Complex(-3, -2));
        check(() => const Complex(1, -2) - 'foo').throws<ArgumentError>();
      });
      test('multiplication', () {
        check(const Complex(1, -2) * const Complex(-3, 4))
            .equals(const Complex(5, 10));
        check(const Complex(-3, 4) * const Complex(1, -2))
            .equals(const Complex(5, 10));
        check(const Complex(-3, 4) * 2).equals(const Complex(-6, 8));
        check(() => const Complex(-3, 4) * 'foo').throws<ArgumentError>();
      });
      test('division', () {
        check(const Complex(5, 10) / const Complex(-3, 4))
            .equals(const Complex(1, -2));
        check(const Complex(5, 10) / const Complex(1, -2))
            .equals(const Complex(-3, 4));
        check(const Complex(6, 10) / 2).equals(const Complex(3, 5));
        check(() => const Complex(6, 10) / 'foo').throws<ArgumentError>();
      });
      test('negate', () {
        check(-const Complex(1, -2)).equals(const Complex(-1, 2));
      });
      test('conjugate', () {
        check(const Complex(1, -2).conjugate()).equals(const Complex(1, 2));
      });
      test('reciprocal', () {
        check(const Complex(1, -2).reciprocal())
            .equals(const Complex(0.2, 0.4));
      });
      test('exp', () {
        check(const Complex(1, 2).exp())
            .isCloseTo(const Complex(-1.131204, 2.471726));
      });
      test('log', () {
        check(const Complex(1, 2).log())
            .isCloseTo(const Complex(0.804718, 1.107148));
      });
      test('pow', () {
        check(const Complex(1, 2).pow(const Complex(3, 4)))
            .isCloseTo(const Complex(0.129009, 0.033924));
      });
      test('square', () {
        check(const Complex(2, 3).square()).equals(const Complex(-5, 12));
        check(const Complex(-2, 3).square()).equals(const Complex(-5, -12));
        check(const Complex(2, -3).square()).equals(const Complex(-5, -12));
        check(const Complex(-2, -3).square()).equals(const Complex(-5, 12));
      });
      test('sqrt', () {
        check(const Complex(2, 3).sqrt())
            .isCloseTo(const Complex(1.674149, 0.895977));
        check(const Complex(-2, 3).sqrt())
            .isCloseTo(const Complex(0.895977, 1.674149));
        check(const Complex(2, -3).sqrt())
            .isCloseTo(const Complex(1.674149, -0.895977));
        check(const Complex(-2, -3).sqrt())
            .isCloseTo(const Complex(0.895977, -1.674149));
        check(const Complex(2, 3).sqrt().square())
            .isCloseTo(const Complex(2, 3));
      });
      group('roots', () {
        const source = Complex(2, 3);
        void testRoots(int n) {
          test('$source.roots($n)', () {
            final roots = source.roots(n);
            check(roots).length.equals(n.abs());
            for (final root in roots) {
              check(root.pow(n)).isCloseTo(Complex(source.a, source.b));
            }
          });
        }

        testRoots(-4);
        testRoots(-3);
        testRoots(-2);
        testRoots(-1);
        test('$source.root(0)', () {
          check(() => source.roots(0)).throws<ArgumentError>();
        });
        testRoots(1);
        testRoots(2);
        testRoots(3);
        testRoots(4);
        testRoots(5);
        testRoots(6);
      });
      test('sin', () {
        check(const Complex(2, 3).sin())
            .isCloseTo(const Complex(9.154499, 4.168906));
      });
      test('asin', () {
        check(const Complex(2, 3).asin())
            .isCloseTo(const Complex(0.570652, 1.983387));
      });
      test('sinh', () {
        check(const Complex(2, 3).sinh())
            .isCloseTo(const Complex(-3.590564, 0.530921));
      });
      test('asinh', () {
        check(const Complex(2, 3).asinh())
            .isCloseTo(const Complex(1.968637, 0.964658));
      });
      test('cos', () {
        check(const Complex(2, 3).cos())
            .isCloseTo(const Complex(-4.189625, -9.109227));
      });
      test('acos', () {
        check(const Complex(2, 3).acos())
            .isCloseTo(const Complex(1.000143, -1.983387));
      });
      test('cosh', () {
        check(const Complex(2, 3).cosh())
            .isCloseTo(const Complex(-3.724545, 0.511822));
      });
      test('acosh', () {
        check(const Complex(2, 3).acosh())
            .isCloseTo(const Complex(1.983387, 1.000143));
      });
      test('tan', () {
        check(const Complex(2, 3).tan())
            .isCloseTo(const Complex(-0.003764, 1.003238));
      });
      test('atan', () {
        check(const Complex(2, 3).atan())
            .isCloseTo(const Complex(1.409921, 0.229072));
      });
      test('tanh', () {
        check(const Complex(2, 3).tanh())
            .isCloseTo(const Complex(0.965385, -0.009884));
      });
      test('atanh', () {
        check(const Complex(2, 3).atanh())
            .isCloseTo(const Complex(0.146946, 1.338972));
      });
    });
    group('testing', () {
      test('isNan', () {
        check(Complex.zero.isNaN).isFalse();
        check(Complex.nan.isNaN).isTrue();
        check(Complex.infinity.isNaN).isFalse();
        check(const Complex(0, double.nan).isNaN).isTrue();
        check(const Complex(double.nan).isNaN).isTrue();
        check(const Complex(double.nan, double.nan).isNaN).isTrue();
      });
      test('isInfinite', () {
        check(Complex.zero.isInfinite).isFalse();
        check(Complex.nan.isInfinite).isFalse();
        check(Complex.infinity.isInfinite).isTrue();
        check(const Complex(0, double.infinity).isInfinite).isTrue();
        check(const Complex(double.infinity).isInfinite).isTrue();
        check(const Complex(double.infinity, double.infinity).isInfinite)
            .isTrue();
      });
      test('isFinite', () {
        check(Complex.zero.isFinite).isTrue();
        check(Complex.nan.isFinite).isFalse();
        check(Complex.infinity.isFinite).isFalse();
        check(const Complex(0, double.nan).isFinite).isFalse();
        check(const Complex(double.nan).isFinite).isFalse();
        check(const Complex(double.nan, double.nan).isFinite).isFalse();
        check(const Complex(0, double.infinity).isFinite).isFalse();
        check(const Complex(double.infinity).isFinite).isFalse();
        check(const Complex(double.infinity, double.infinity).isFinite)
            .isFalse();
      });
    });
    group('converting', () {
      test('sign', () {
        check(Complex.zero.sign).equals(Complex.zero);
        check(const Complex(2.5).sign).isCloseTo(Complex.one);
        check(const Complex(-2.5).sign).isCloseTo(const Complex(-1));
        check(const Complex(0, 2.5).sign).isCloseTo(Complex.i);
        check(const Complex(0, -2.5).sign).isCloseTo(const Complex(0, -1));
        check(const Complex(2, 2).sign)
            .isCloseTo(const Complex(math.sqrt1_2, math.sqrt1_2));
        check(const Complex(-2, 2).sign)
            .isCloseTo(const Complex(-math.sqrt1_2, math.sqrt1_2));
        check(const Complex(2, -2).sign)
            .isCloseTo(const Complex(math.sqrt1_2, -math.sqrt1_2));
        check(const Complex(-2, -2).sign)
            .isCloseTo(const Complex(-math.sqrt1_2, -math.sqrt1_2));
      });
      test('round', () {
        check(const Complex(2.7, 1.2).round()).equals(const Complex(3, 1));
      });
      test('floor', () {
        check(const Complex(2.7, 1.2).floor()).equals(const Complex(2, 1));
      });
      test('ceil', () {
        check(const Complex(2.7, 1.2).ceil()).equals(const Complex(3, 2));
      });
      test('truncate', () {
        check(const Complex(2.7, 1.2).truncate()).equals(const Complex(2, 1));
      });
      test('toString', () {
        check(Complex.zero.toString()).equals('Complex(0, 0)');
        check(Complex.one.toString()).equals('Complex(1, 0)');
        check(Complex.i.toString()).equals('Complex(0, 1)');
        check(const Complex(1, 2).toString()).equals('Complex(1, 2)');
        check(const Complex(-3, -4).toString()).equals('Complex(-3, -4)');
      });
    });
    group('comparing', () {
      test('close', () {
        check(Complex.fromPolar(math.e, math.pi / 2).closeTo(Complex.zero, 0.1))
            .isFalse();
        check(
          Complex.fromPolar(
            math.e,
            math.pi / 2,
          ).closeTo(const Complex(0, 2.71), 0.1),
        ).isTrue();
      });
      test('equal', () {
        check(const Complex(2, 3) == const Complex(2, 3)).isTrue();
        check(const Complex(2, 3) == const Complex(3, 2)).isFalse();
        check(const Complex(2, 3) == const Complex(2, 4)).isFalse();
        check(Complex.nan == Complex.nan).isFalse();
        check(Complex.infinity == Complex.infinity).isTrue();
      });
      test('hash', () {
        check(const Complex(2, 3).hashCode)
            .equals(const Complex(2, 3).hashCode);
        check(const Complex(2, 3).hashCode)
            .not((it) => it.equals(const Complex(3, 2).hashCode));
      });
    });
  });
}
