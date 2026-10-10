import 'package:checks/checks.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('Quaternion', () {
    group('construction', () {
      test('zero', () {
        const quaternion = Quaternion.zero;
        check(quaternion)
          ..w.equals(0)
          ..x.equals(0)
          ..y.equals(0)
          ..z.equals(0);
        check(quaternion.abs()).equals(0.0);
      });
      test('one', () {
        const quaternion = Quaternion.one;
        check(quaternion)
          ..w.equals(1)
          ..x.equals(0)
          ..y.equals(0)
          ..z.equals(0);
        check(quaternion.abs()).equals(1.0);
      });
      test('i', () {
        const quaternion = Quaternion.i;
        check(quaternion)
          ..w.equals(0)
          ..x.equals(1)
          ..y.equals(0)
          ..z.equals(0);
        check(quaternion.abs()).equals(1.0);
      });
      test('j', () {
        const quaternion = Quaternion.j;
        check(quaternion)
          ..w.equals(0)
          ..x.equals(0)
          ..y.equals(1)
          ..z.equals(0);
        check(quaternion.abs()).equals(1.0);
      });
      test('k', () {
        const quaternion = Quaternion.k;
        check(quaternion)
          ..w.equals(0)
          ..x.equals(0)
          ..y.equals(0)
          ..z.equals(1);
        check(quaternion.abs()).equals(1.0);
      });
      test('components', () {
        const quaternion = Quaternion(1, 2, 3, 4);
        check(quaternion.w).equals(1);
        check(quaternion.x).equals(2);
        check(quaternion.y).equals(3);
        check(quaternion.z).equals(4);
        check(quaternion.abs()).isCloseTo(5.477225, epsilon);
      });
      test('of', () {
        final quaternion = Quaternion.of(1, const [2, 3, 4]);
        check(quaternion.w).equals(1);
        check(quaternion.x).equals(2);
        check(quaternion.y).equals(3);
        check(quaternion.z).equals(4);
        check(quaternion.abs()).isCloseTo(5.477225, epsilon);
      });
      test('fromList', () {
        final quaternion = Quaternion.fromList(const [1, 2, 3, 4]);
        check(quaternion.w).equals(1);
        check(quaternion.x).equals(2);
        check(quaternion.y).equals(3);
        check(quaternion.z).equals(4);
        check(quaternion.abs()).isCloseTo(5.477225, epsilon);
      });
      test('fromAxis', () {
        final quaternion = Quaternion.fromAxis(const [1, 2, 3], 4.0);
        check(
          quaternion,
        ).isCloseTo(const Quaternion(-0.416146, 0.243019, 0.486039, 0.729059));
        check(quaternion.abs()).isCloseTo(1.0, epsilon);
      });
      test('fromVectors', () {
        final quaternion = Quaternion.fromVectors(
          const [1, 2, 3],
          const [4, 5, 6],
        );
        check(
          quaternion,
        ).isCloseTo(const Quaternion(0.993637, -0.045978, 0.091956, -0.045978));
        check(quaternion.abs()).isCloseTo(1.0, epsilon);
      });
      test('fromEuler', () {
        final quaternion = Quaternion.fromEuler(1, 2, 3);
        check(
          quaternion,
        ).isCloseTo(const Quaternion(-0.368871, -0.206149, 0.501509, 0.754933));
        check(quaternion.abs()).isCloseTo(1.0, epsilon);
      });
      test('parse', () {
        check(Quaternion.parse('1+2i+3j+4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.parse('1-2i+3j-4k'))
            .equals(const Quaternion(1, -2, 3, -4));
        check(Quaternion.parse('-1+2i-3j+4k'))
            .equals(const Quaternion(-1, 2, -3, 4));
        check(Quaternion.parse('-1-2i-3j-4k'))
            .equals(const Quaternion(-1, -2, -3, -4));
      });
      test('parse (permutation)', () {
        check(Quaternion.parse('1+2i+3j+4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.parse('2i+1+3j+4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.parse('4k+2i+3j+1'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.parse('3j+4k+2i+1'))
            .equals(const Quaternion(1, 2, 3, 4));
      });
      test('parse (whitespace)', () {
        check(Quaternion.parse('1 + 2i + 3j + 4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.parse(' 1 - 2i + 3j - 4k '))
            .equals(const Quaternion(1, -2, 3, -4));
      });
      test('parse (real)', () {
        check(Quaternion.parse('1')).equals(Quaternion.one);
        check(Quaternion.parse('-1')).equals(-Quaternion.one);
        check(Quaternion.parse('1.2')).equals(const Quaternion(1.2));
        check(Quaternion.parse('-1.2')).equals(const Quaternion(-1.2));
        check(Quaternion.parse('1.2e2')).equals(const Quaternion(120));
        check(Quaternion.parse('1.2e-2')).equals(const Quaternion(0.012));
      });
      test('parse (vector)', () {
        check(Quaternion.parse('i')).equals(Quaternion.i);
        check(Quaternion.parse('j')).equals(Quaternion.j);
        check(Quaternion.parse('k')).equals(Quaternion.k);
        check(Quaternion.parse('+i')).equals(Quaternion.i);
        check(Quaternion.parse('+j')).equals(Quaternion.j);
        check(Quaternion.parse('+k')).equals(Quaternion.k);
        check(Quaternion.parse('-i')).equals(-Quaternion.i);
        check(Quaternion.parse('-j')).equals(-Quaternion.j);
        check(Quaternion.parse('-k')).equals(-Quaternion.k);
        check(Quaternion.parse('1.2I')).equals(const Quaternion(0, 1.2));
        check(Quaternion.parse('1.2J')).equals(const Quaternion(0, 0, 1.2));
        check(Quaternion.parse('1.2K')).equals(const Quaternion(0, 0, 0, 1.2));
        check(Quaternion.parse('1.2e2i')).equals(const Quaternion(0, 120));
        check(Quaternion.parse('1.2e2j')).equals(const Quaternion(0, 0, 120));
        check(Quaternion.parse('1.2e2k'))
            .equals(const Quaternion(0, 0, 0, 120));
        check(Quaternion.parse('-1.2e-2i')).equals(const Quaternion(0, -0.012));
        check(Quaternion.parse('-1.2e-2j'))
            .equals(const Quaternion(0, 0, -0.012));
        check(Quaternion.parse('-1.2e-2k'))
            .equals(const Quaternion(0, 0, 0, -0.012));
      });
      test('parse (error)', () {
        check(() => Quaternion.parse('')).throws<FormatException>();
        check(() => Quaternion.parse('e1')).throws<FormatException>();
        check(() => Quaternion.parse('1ii')).throws<FormatException>();
        check(() => Quaternion.parse('1+1')).throws<FormatException>();
        check(() => Quaternion.parse('i+i')).throws<FormatException>();
        check(() => Quaternion.parse('j+j')).throws<FormatException>();
        check(() => Quaternion.parse('k+k')).throws<FormatException>();
      });
      test('tryParse', () {
        check(Quaternion.tryParse('1+2i+3j+4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.tryParse('1-2i+3j-4k'))
            .equals(const Quaternion(1, -2, 3, -4));
        check(Quaternion.tryParse('-1+2i-3j+4k'))
            .equals(const Quaternion(-1, 2, -3, 4));
        check(Quaternion.tryParse('-1-2i-3j-4k'))
            .equals(const Quaternion(-1, -2, -3, -4));
      });
      test('tryParse (permutation)', () {
        check(Quaternion.tryParse('1+2i+3j+4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.tryParse('2i+1+3j+4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.tryParse('4k+2i+3j+1'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.tryParse('3j+4k+2i+1'))
            .equals(const Quaternion(1, 2, 3, 4));
      });
      test('tryParse (whitespace)', () {
        check(Quaternion.tryParse('1 + 2i + 3j + 4k'))
            .equals(const Quaternion(1, 2, 3, 4));
        check(Quaternion.tryParse(' 1 - 2i + 3j - 4k '))
            .equals(const Quaternion(1, -2, 3, -4));
      });
      test('tryParse (real)', () {
        check(Quaternion.tryParse('1')).equals(Quaternion.one);
        check(Quaternion.tryParse('-1')).equals(-Quaternion.one);
        check(Quaternion.tryParse('1.2')).equals(const Quaternion(1.2));
        check(Quaternion.tryParse('-1.2')).equals(const Quaternion(-1.2));
        check(Quaternion.tryParse('1.2e2')).equals(const Quaternion(120));
        check(Quaternion.tryParse('1.2e-2')).equals(const Quaternion(0.012));
      });
      test('tryParse (vector)', () {
        check(Quaternion.tryParse('i')).equals(Quaternion.i);
        check(Quaternion.tryParse('j')).equals(Quaternion.j);
        check(Quaternion.tryParse('k')).equals(Quaternion.k);
        check(Quaternion.tryParse('+i')).equals(Quaternion.i);
        check(Quaternion.tryParse('+j')).equals(Quaternion.j);
        check(Quaternion.tryParse('+k')).equals(Quaternion.k);
        check(Quaternion.tryParse('-i')).equals(-Quaternion.i);
        check(Quaternion.tryParse('-j')).equals(-Quaternion.j);
        check(Quaternion.tryParse('-k')).equals(-Quaternion.k);
        check(Quaternion.tryParse('1.2I')).equals(const Quaternion(0, 1.2));
        check(Quaternion.tryParse('1.2J')).equals(const Quaternion(0, 0, 1.2));
        check(Quaternion.tryParse('1.2K'))
            .equals(const Quaternion(0, 0, 0, 1.2));
        check(Quaternion.tryParse('1.2e2i')).equals(const Quaternion(0, 120));
        check(Quaternion.tryParse('1.2e2j'))
            .equals(const Quaternion(0, 0, 120));
        check(Quaternion.tryParse('1.2e2k'))
            .equals(const Quaternion(0, 0, 0, 120));
        check(Quaternion.tryParse('-1.2e-2i'))
            .equals(const Quaternion(0, -0.012));
        check(Quaternion.tryParse('-1.2e-2j'))
            .equals(const Quaternion(0, 0, -0.012));
        check(Quaternion.tryParse('-1.2e-2k'))
            .equals(const Quaternion(0, 0, 0, -0.012));
      });
      test('tryParse (error)', () {
        check(Quaternion.tryParse('')).isNull();
        check(Quaternion.tryParse('e1')).isNull();
        check(Quaternion.tryParse('1ii')).isNull();
        check(Quaternion.tryParse('1+1')).isNull();
        check(Quaternion.tryParse('i+i')).isNull();
        check(Quaternion.tryParse('j+j')).isNull();
        check(Quaternion.tryParse('k+k')).isNull();
      });
    });
    group('arithmetic', () {
      test('addition', () {
        check(const Quaternion(1, -2, 3, -4) + const Quaternion(5, 6, -7, -8))
            .equals(const Quaternion(6, 4, -4, -12));
        check(const Quaternion(1, -2, 3, -4) + 5)
            .equals(const Quaternion(6, -2, 3, -4));
        check(() => const Quaternion(1, -2, 3, -4) + 'foo')
            .throws<ArgumentError>();
      });
      test('subtraction', () {
        check(const Quaternion(1, -2, 3, -4) - const Quaternion(5, 6, -7, -8))
            .equals(const Quaternion(-4, -8, 10, 4));
        check(const Quaternion(1, -2, 3, -4) - 5)
            .equals(const Quaternion(-4, -2, 3, -4));
        check(() => const Quaternion(1, -2, 3, -4) - 'foo')
            .throws<ArgumentError>();
      });
      test('multiplication', () {
        check(const Quaternion(1, -2, 3, -4) * const Quaternion(5, 6, -7, -8))
            .equals(const Quaternion(6, -56, -32, -32));
        check(const Quaternion(1, -2, 3, -4) * 5)
            .equals(const Quaternion(5, -10, 15, -20));
        check(() => const Quaternion(5, 6, -7, -8) * 'foo')
            .throws<ArgumentError>();
      });
      test('division', () {
        check(
          const Quaternion(1, -2, 3, -4) / const Quaternion(5, 6, -7, -8),
        ).isCloseTo(const Quaternion(0.133333, 1.200000, 2.066666, -0.266666));
        check(
          const Quaternion(5, 6, -7, -8) / const Quaternion(1, -2, 3, -4),
        ).isCloseTo(const Quaternion(0.022988, -0.206896, -0.356321, 0.045977));
        check(const Quaternion(6, 4, -8, -16) / 2)
            .equals(const Quaternion(3, 2, -4, -8));
        check(() => const Quaternion(6, 4, -8, -16) / 'foo')
            .throws<ArgumentError>();
      });
      test('negate', () {
        check(-const Quaternion(1, -2, 3, -4))
            .equals(const Quaternion(-1, 2, -3, 4));
      });
      test('conjugate', () {
        check(const Quaternion(1, -2, 3, -4).conjugate())
            .equals(const Quaternion(1, 2, -3, 4));
      });
      test('reciprocal', () {
        check(
          const Quaternion(1, -2, 3, -4).reciprocal(),
        ).isCloseTo(const Quaternion(0.033333, 0.066666, -0.100000, 0.133333));
      });
      test('exp', () {
        check(
          const Quaternion(1, -2, 3, -4).exp(),
        ).isCloseTo(const Quaternion(1.693922, 0.789559, -1.184339, 1.579119));
      });
      test('log', () {
        check(
          const Quaternion(1, -2, 3, -4).log(),
        ).isCloseTo(const Quaternion(1.700598, -0.515190, 0.772785, -1.030380));
      });
      test('pow', () {
        check(
          const Quaternion(1, -2, 3, -4).pow(const Quaternion(5, 6, -7, -8)),
        ).isCloseTo(
          const Quaternion(
            -4948.167788,
            -841.118989,
            -2675.346637,
            -2885.798013,
          ),
        );
      });
    });
    group('testing', () {
      test('isNan', () {
        check(const Quaternion(1, 2, 3, 4).isNaN).isFalse();
        check(const Quaternion(double.nan, 2, 3, 4).isNaN).isTrue();
        check(const Quaternion(1, double.nan, 3, 4).isNaN).isTrue();
        check(const Quaternion(1, 2, double.nan, 4).isNaN).isTrue();
        check(const Quaternion(1, 2, 3, double.nan).isNaN).isTrue();
        check(Quaternion.nan.isNaN).isTrue();
        check(Quaternion.infinity.isNaN).isFalse();
      });
      test('isInfinite', () {
        check(const Quaternion(1, 2, 3, 4).isInfinite).isFalse();
        check(const Quaternion(double.infinity, 2, 3, 4).isInfinite).isTrue();
        check(const Quaternion(1, double.negativeInfinity, 3, 4).isInfinite)
            .isTrue();
        check(const Quaternion(1, 2, double.infinity, 4).isInfinite).isTrue();
        check(const Quaternion(1, 2, 3, double.negativeInfinity).isInfinite)
            .isTrue();
        check(Quaternion.nan.isInfinite).isFalse();
        check(Quaternion.infinity.isInfinite).isTrue();
      });
      test('isFinite', () {
        check(const Quaternion(1, 2, 3, 4).isFinite).isTrue();
        check(const Quaternion(double.nan, 2, 3, 4).isFinite).isFalse();
        check(const Quaternion(1, double.nan, 3, 4).isFinite).isFalse();
        check(const Quaternion(1, 2, double.nan, 4).isFinite).isFalse();
        check(const Quaternion(1, 2, 3, double.nan).isFinite).isFalse();
        check(const Quaternion(double.infinity, 2, 3, 4).isFinite).isFalse();
        check(const Quaternion(1, double.negativeInfinity, 3, 4).isFinite)
            .isFalse();
        check(const Quaternion(1, 2, double.infinity, 4).isFinite).isFalse();
        check(const Quaternion(1, 2, 3, double.negativeInfinity).isFinite)
            .isFalse();
        check(Quaternion.nan.isFinite).isFalse();
        check(Quaternion.infinity.isFinite).isFalse();
      });
    });
    group('converting', () {
      test('round', () {
        check(const Quaternion(1.7, 3.2, -2.7, -4.2).round())
            .equals(const Quaternion(2, 3, -3, -4));
      });
      test('floor', () {
        check(const Quaternion(1.7, 3.2, -2.7, -4.2).floor())
            .equals(const Quaternion(1, 3, -3, -5));
      });
      test('ceil', () {
        check(const Quaternion(1.7, 3.2, -2.7, -4.2).ceil())
            .equals(const Quaternion(2, 4, -2, -4));
      });
      test('truncate', () {
        check(const Quaternion(1.7, 3.2, -2.7, -4.2).truncate())
            .equals(const Quaternion(1, 3, -2, -4));
      });
      test('toString', () {
        check(Quaternion.zero.toString()).equals('Quaternion(0, 0, 0, 0)');
        check(Quaternion.one.toString()).equals('Quaternion(1, 0, 0, 0)');
        check(Quaternion.i.toString()).equals('Quaternion(0, 1, 0, 0)');
        check(Quaternion.j.toString()).equals('Quaternion(0, 0, 1, 0)');
        check(Quaternion.k.toString()).equals('Quaternion(0, 0, 0, 1)');
        check(const Quaternion(0, 2, 4, 6).toString())
            .equals('Quaternion(0, 2, 4, 6)');
        check(const Quaternion(1, -1, 2, -3).toString())
            .equals('Quaternion(1, -1, 2, -3)');
      });
    });
    group('comparing', () {
      test('equal', () {
        check(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 3, 4, 5))
            .isTrue();
        check(const Quaternion(2, 3, 4, 5) == const Quaternion(1, 3, 4, 5))
            .isFalse();
        check(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 4, 4, 5))
            .isFalse();
        check(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 3, 3, 5))
            .isFalse();
        check(const Quaternion(2, 3, 4, 5) == const Quaternion(2, 3, 4, 6))
            .isFalse();
        check(Quaternion.nan == Quaternion.nan).isFalse();
        check(Quaternion.infinity == Quaternion.infinity).isTrue();
      });
      test('hash', () {
        check(const Quaternion(2, 3, 4, 5).hashCode)
            .equals(const Quaternion(2, 3, 4, 5).hashCode);
        check(const Quaternion(2, 3, 4, 5).hashCode)
            .not((it) => it.equals(const Quaternion(3, 2, 4, 5).hashCode));
        check(const Quaternion(2, 3, 4, 5).hashCode)
            .not((it) => it.equals(const Quaternion(2, 4, 3, 5).hashCode));
        check(const Quaternion(2, 3, 4, 5).hashCode)
            .not((it) => it.equals(const Quaternion(2, 3, 5, 4).hashCode));
      });
    });
  });
}
