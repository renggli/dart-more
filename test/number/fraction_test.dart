import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('Fraction', () {
    group('construction', () {
      test('irreducible', () {
        final fraction = Fraction(3, 7);
        check(fraction.a).equals(3);
        check(fraction.b).equals(7);
        check(fraction.numerator).equals(3);
        check(fraction.denominator).equals(7);
      });
      test('reducible', () {
        final fraction = Fraction(15, 35);
        check(fraction.a).equals(3);
        check(fraction.b).equals(7);
        check(fraction.numerator).equals(3);
        check(fraction.denominator).equals(7);
      });
      test('normal negative', () {
        final fraction = Fraction(-2, 4);
        check(fraction.a).equals(-1);
        check(fraction.b).equals(2);
        check(fraction.numerator).equals(-1);
        check(fraction.denominator).equals(2);
      });
      test('double negative', () {
        final fraction = Fraction(-2, -4);
        check(fraction.a).equals(1);
        check(fraction.b).equals(2);
        check(fraction.numerator).equals(1);
        check(fraction.denominator).equals(2);
      });
      test('denominator negative', () {
        final fraction = Fraction(2, -4);
        check(fraction.a).equals(-1);
        check(fraction.b).equals(2);
        check(fraction.numerator).equals(-1);
        check(fraction.denominator).equals(2);
      });
      test('zero', () {
        check(Fraction.zero).isFraction(0);
        check(Fraction(1, 2) + Fraction.zero).isFraction(1, 2);
      });
      test('one', () {
        check(Fraction.one).isFraction(1);
        check(Fraction(1, 2) * Fraction.one).isFraction(1, 2);
      });
      test('nan', () {
        const fraction = Fraction.nan;
        check(fraction).isFraction(0, 0);
        check(fraction.isNaN).isTrue();
        check(fraction.isInfinite).isFalse();
        check(fraction.isNegative).isFalse();
        check(fraction.isFinite).isFalse();
      });
      test('infinity', () {
        const fraction = Fraction.infinity;
        check(fraction).isFraction(1, 0);
        check(fraction.isNaN).isFalse();
        check(fraction.isInfinite).isTrue();
        check(fraction.isNegative).isFalse();
        check(fraction.isFinite).isFalse();
      });
      test('negativeInfinity', () {
        const fraction = Fraction.negativeInfinity;
        check(fraction).isFraction(-1, 0);
        check(fraction.isNaN).isFalse();
        check(fraction.isInfinite).isTrue();
        check(fraction.isNegative).isTrue();
        check(fraction.isFinite).isFalse();
      });
      group('fromDouble', () {
        test('basic', () {
          check(Fraction.fromDouble(0)).isFraction(0);
          check(Fraction.fromDouble(2)).isFraction(2);
          check(Fraction.fromDouble(100)).isFraction(100);
        });
        test('finite', () {
          check(Fraction.fromDouble(1 / 2)).isFraction(1, 2);
          check(Fraction.fromDouble(1 / 4)).isFraction(1, 4);
        });
        test('finite, whole', () {
          check(Fraction.fromDouble(5 / 2)).isFraction(5, 2);
          check(Fraction.fromDouble(9 / 4)).isFraction(9, 4);
        });
        test('infinite', () {
          check(Fraction.fromDouble(1 / 3)).isFraction(1, 3);
          check(Fraction.fromDouble(1 / 7)).isFraction(1, 7);
        });
        test('infinite, whole', () {
          check(Fraction.fromDouble(5 / 3)).isFraction(5, 3);
          check(Fraction.fromDouble(9 / 7)).isFraction(9, 7);
        });
        test('negative', () {
          check(Fraction.fromDouble(-1 / 3)).isFraction(-1, 3);
          check(Fraction.fromDouble(-5 / 3)).isFraction(-5, 3);
        });
        test('irrational', () {
          check(Fraction.fromDouble(pi)).isFraction(245850922, 78256779);
          check(Fraction.fromDouble(pi, absoluteError: 1e-10))
              .isFraction(312689, 99532);
          check(Fraction.fromDouble(pi, maxDenominator: 1000))
              .isFraction(355, 113);
        });
        test('common', () {
          for (var num = -10; num <= 10; num++) {
            for (var den = -10; den <= 10; den++) {
              if (den != 0) {
                check(Fraction.fromDouble(num / den))
                    .equals(Fraction(num, den));
              }
            }
          }
        });
        group('stress', () {
          final random = Random(1911);
          void stress({required double min, required double max}) {
            for (var i = 0; i < 100; i++) {
              final floating = random.nextDouble() * (max - min) + min;
              final fraction = Fraction.fromDouble(floating);
              check(fraction.toDouble()).isCloseTo(floating, (max - min) / 1e6);
            }
          }

          test('unit', () => stress(min: -1, max: 1));
          test('small', () => stress(min: -1e-5, max: 1e-5));
          test('large', () => stress(min: -1e+5, max: 1e+5));
        });
        test('nan', () {
          final fraction = Fraction.fromDouble(double.nan);
          check(fraction).isFraction(0, 0);
          check(fraction.isNaN).isTrue();
          check(fraction.isInfinite).isFalse();
          check(fraction.isNegative).isFalse();
          check(fraction.isFinite).isFalse();
        });
        test('infinity', () {
          final fraction = Fraction.fromDouble(double.infinity);
          check(fraction).isFraction(1, 0);
          check(fraction.isNaN).isFalse();
          check(fraction.isInfinite).isTrue();
          check(fraction.isNegative).isFalse();
          check(fraction.isFinite).isFalse();
        });
        test('negativeInfinity', () {
          final fraction = Fraction.fromDouble(double.negativeInfinity);
          check(fraction).isFraction(-1, 0);
          check(fraction.isNaN).isFalse();
          check(fraction.isInfinite).isTrue();
          check(fraction.isNegative).isTrue();
          check(fraction.isFinite).isFalse();
        });
      });
      group('tryParse', () {
        test('basic', () {
          check(Fraction.tryParse('1/2')).isNotNull().isFraction(1, 2);
          check(Fraction.tryParse(' 1/2')).isNotNull().isFraction(1, 2);
          check(Fraction.tryParse('1 /2')).isNotNull().isFraction(1, 2);
          check(Fraction.tryParse('1/ 2')).isNotNull().isFraction(1, 2);
          check(Fraction.tryParse('1/2 ')).isNotNull().isFraction(1, 2);
        });
        test('negative', () {
          check(Fraction.tryParse('-1/2')).isNotNull().isFraction(-1, 2);
          check(Fraction.tryParse('1/-2')).isNotNull().isFraction(-1, 2);
          check(Fraction.tryParse('-1/-2')).isNotNull().isFraction(1, 2);
        });
        test('integer', () {
          check(Fraction.tryParse('3')).isNotNull().isFraction(3);
          check(Fraction.tryParse(' 3')).isNotNull().isFraction(3);
          check(Fraction.tryParse('3 ')).isNotNull().isFraction(3);
        });
        test('error', () {
          check(Fraction.tryParse('')).isNull();
          check(Fraction.tryParse('1.23')).isNull();
          check(Fraction.tryParse('1/2/3')).isNull();
        });
      });
      group('positive', () {
        test('basic', () {
          final fractions = Fraction.positive.take(15);
          check(fractions).deepEquals([
            Fraction(1),
            Fraction(1, 2),
            Fraction(2),
            Fraction(1, 3),
            Fraction(3, 2),
            Fraction(2, 3),
            Fraction(3),
            Fraction(1, 4),
            Fraction(4, 3),
            Fraction(3, 5),
            Fraction(5, 2),
            Fraction(2, 5),
            Fraction(5, 3),
            Fraction(3, 4),
            Fraction(4),
          ]);
        });
        test('irreducible', () {
          final fractions = Fraction.positive.take(100000);
          for (final fraction in fractions) {
            check(fraction.a.gcd(fraction.b)).equals(1);
          }
        });
        test('unique', () {
          final seen = <Fraction>{};
          final fractions = Fraction.positive.take(100000);
          for (final fraction in fractions) {
            check(seen.add(fraction)).isTrue();
          }
        });
      });
      group('farey', () {
        void verifyFarey(int n, {List<Fraction>? expected}) {
          if (expected != null) {
            check(Fraction.farey(n)).deepEquals(expected);
            check(Fraction.farey(n, ascending: true)).deepEquals(expected);
            check(Fraction.farey(n, ascending: false))
                .deepEquals(expected.reversed);
          }
          // denominator is less than n
          check(
            Fraction.farey(n, ascending: true).map((each) => each.denominator),
          ).every((it) => it.isLessOrEqual(n));
          check(
            Fraction.farey(n, ascending: false).map((each) => each.denominator),
          ).every((it) => it.isLessOrEqual(n));
          // sequence is strictly ordered
          check(
            naturalComparable<Fraction>.isStrictlyOrdered(
              Fraction.farey(n, ascending: true),
            ),
          ).isTrue();
          check(
            naturalComparable<Fraction>.reversed.isStrictlyOrdered(
              Fraction.farey(n, ascending: false),
            ),
          ).isTrue();
        }

        test(
          'n = 1',
          () => verifyFarey(1, expected: [Fraction(0), Fraction(1)]),
        );
        test(
          'n = 2',
          () => verifyFarey(
            2,
            expected: [Fraction(0), Fraction(1, 2), Fraction(1)],
          ),
        );
        test(
          'n = 3',
          () => verifyFarey(
            3,
            expected: [
              Fraction(0),
              Fraction(1, 3),
              Fraction(1, 2),
              Fraction(2, 3),
              Fraction(1),
            ],
          ),
        );
        test(
          'n = 4',
          () => verifyFarey(
            4,
            expected: [
              Fraction(0),
              Fraction(1, 4),
              Fraction(1, 3),
              Fraction(1, 2),
              Fraction(2, 3),
              Fraction(3, 4),
              Fraction(1),
            ],
          ),
        );
        test(
          'n = 5',
          () => verifyFarey(
            5,
            expected: [
              Fraction(0),
              Fraction(1, 5),
              Fraction(1, 4),
              Fraction(1, 3),
              Fraction(2, 5),
              Fraction(1, 2),
              Fraction(3, 5),
              Fraction(2, 3),
              Fraction(3, 4),
              Fraction(4, 5),
              Fraction(1),
            ],
          ),
        );
        test('n = 100', () => verifyFarey(100));
        test('n = 1000', () => verifyFarey(1000));
        test('error', () {
          check(() => Fraction.farey(0)).throws<ArgumentError>();
          check(() => Fraction.farey(-1)).throws<ArgumentError>();
        });
      });
    });
    group('testing', () {
      test('isFinite', () {
        check(Fraction.zero.isFinite).isTrue();
        check(Fraction.nan.isFinite).isFalse();
        check(Fraction.infinity.isFinite).isFalse();
        check(Fraction.negativeInfinity.isFinite).isFalse();
      });
      test('isNan', () {
        check(Fraction.zero.isNaN).isFalse();
        check(Fraction.nan.isNaN).isTrue();
        check(Fraction.infinity.isNaN).isFalse();
        check(Fraction.negativeInfinity.isNaN).isFalse();
      });
      test('isInfinite', () {
        check(Fraction.zero.isInfinite).isFalse();
        check(Fraction.nan.isInfinite).isFalse();
        check(Fraction.infinity.isInfinite).isTrue();
        check(Fraction.negativeInfinity.isInfinite).isTrue();
      });
      test('isNegative', () {
        check(Fraction(1).isNegative).isFalse();
        check(Fraction(-1).isNegative).isTrue();
        check(Fraction(1, -1).isNegative).isTrue();
        check(Fraction(-1, -1).isNegative).isFalse();
        check(Fraction.zero.isNegative).isFalse();
        check(Fraction.nan.isNegative).isFalse();
        check(Fraction.infinity.isNegative).isFalse();
        check(Fraction.negativeInfinity.isNegative).isTrue();
      });
    });
    group('arithmetic', () {
      test('addition', () {
        check(Fraction(1, 2) + Fraction(1, 4)).isFraction(3, 4);
        check(Fraction(1, 2) + Fraction(3, 4)).isFraction(5, 4);
        check(Fraction(1, 2) + Fraction(1, 2)).isFraction(1);
        check(Fraction(1, 2) + 3).isFraction(7, 2);
        check(() => Fraction(1, 2) + 'foo').throws<ArgumentError>();
        check(Fraction(1, 2) + Fraction.nan).isFraction(0, 0);
        check(Fraction(1, 2) + Fraction.infinity).isFraction(1, 0);
        check(Fraction(1, 2) + Fraction.negativeInfinity).isFraction(-1, 0);
        check(Fraction.nan + Fraction(1, 2)).isFraction(0, 0);
        check(Fraction.infinity + Fraction(1, 2)).isFraction(1, 0);
        check(Fraction.negativeInfinity + Fraction(1, 2)).isFraction(-1, 0);
        check(Fraction.nan + Fraction.nan).isFraction(0, 0);
        check(Fraction.infinity + Fraction.infinity).isFraction(0, 0);
        check(Fraction.negativeInfinity + Fraction.negativeInfinity)
            .isFraction(0, 0);
      });
      test('subtraction', () {
        check(Fraction(1, 2) - Fraction(1, 4)).isFraction(1, 4);
        check(Fraction(1, 2) - Fraction(3, 4)).isFraction(-1, 4);
        check(Fraction(1, 2) - Fraction(1, 2)).isFraction(0);
        check(Fraction(1, 2) - 3).isFraction(-5, 2);
        check(() => Fraction(1, 2) - 'foo').throws<ArgumentError>();
        check(Fraction(1, 2) - Fraction.nan).isFraction(0, 0);
        check(Fraction(1, 2) - Fraction.infinity).isFraction(-1, 0);
        check(Fraction(1, 2) - Fraction.negativeInfinity).isFraction(1, 0);
        check(Fraction.nan - Fraction(1, 2)).isFraction(0, 0);
        check(Fraction.infinity - Fraction(1, 2)).isFraction(1, 0);
        check(Fraction.negativeInfinity - Fraction(1, 2)).isFraction(-1, 0);
        check(Fraction.nan - Fraction.nan).isFraction(0, 0);
        check(Fraction.infinity - Fraction.infinity).isFraction(0, 0);
        check(Fraction.negativeInfinity - Fraction.negativeInfinity)
            .isFraction(0, 0);
      });
      test('multiplication', () {
        check(Fraction(2, 3) * Fraction(1, 4)).isFraction(1, 6);
        check(Fraction(3, 4) * Fraction(2, 5)).isFraction(3, 10);
        check(Fraction(3, 4) * 2).isFraction(3, 2);
        check(() => Fraction(3, 4) * 'foo').throws<ArgumentError>();
        check(Fraction(1, 2) * Fraction.nan).isFraction(0, 0);
        check(Fraction(1, 2) * Fraction.infinity).isFraction(1, 0);
        check(Fraction(1, 2) * Fraction.negativeInfinity)
            .equals(Fraction.negativeInfinity);
        check(Fraction.nan * Fraction(1, 2)).isFraction(0, 0);
        check(Fraction.infinity * Fraction(1, 2)).isFraction(1, 0);
        check(Fraction.negativeInfinity * Fraction(1, 2)).isFraction(-1, 0);
        check(Fraction.nan * Fraction.nan).isFraction(0, 0);
        check(Fraction.infinity * Fraction.infinity).isFraction(1, 0);
        check(Fraction.negativeInfinity * Fraction.negativeInfinity)
            .isFraction(1, 0);
      });
      test('reciprocal', () {
        check(Fraction(3, 4).reciprocal()).isFraction(4, 3);
        check(Fraction(-3, 4).reciprocal()).isFraction(-4, 3);
        check(Fraction.nan.reciprocal()).isFraction(0, 0);
        check(Fraction.infinity.reciprocal()).isFraction(0, 1);
        check(Fraction.negativeInfinity.reciprocal()).isFraction(0, 1);
      });
      test('division', () {
        check(Fraction(2, 3) / Fraction(1, 4)).isFraction(8, 3);
        check(Fraction(3, 4) / Fraction(2, 5)).isFraction(15, 8);
        check(Fraction(3, 4) / 2).isFraction(3, 8);
        check(() => Fraction(3, 4) / 'foo').throws<ArgumentError>();
        check(Fraction(1, 2) / Fraction.nan).isFraction(0, 0);
        check(Fraction(1, 2) / Fraction.infinity).isFraction(0, 1);
        check(Fraction(1, 2) / Fraction.negativeInfinity).isFraction(0, 1);
        check(Fraction.nan / Fraction(1, 2)).isFraction(0, 0);
        check(Fraction.infinity / Fraction(1, 2)).isFraction(1, 0);
        check(Fraction.negativeInfinity / Fraction(1, 2)).isFraction(-1, 0);
        check(Fraction.nan / Fraction.nan).isFraction(0, 0);
        check(Fraction.infinity / Fraction.infinity).isFraction(0, 0);
        check(Fraction.negativeInfinity / Fraction.negativeInfinity)
            .isFraction(0, 0);
      });
      test('negate', () {
        check(-Fraction(2, 3)).isFraction(-2, 3);
        check(-Fraction(-2, 3)).isFraction(2, 3);
        check(-Fraction.nan).isFraction(0, 0);
        check(-Fraction.infinity).isFraction(-1, 0);
        check(-Fraction.negativeInfinity).isFraction(1, 0);
      });
      test('pow', () {
        check(Fraction.zero.pow(2)).isFraction(0, 1);
        check(Fraction(2, 3).pow(0)).isFraction(1, 1);
        check(Fraction(2, 3).pow(2)).isFraction(4, 9);
        check(Fraction(2, 3).pow(-2)).isFraction(9, 4);
      });
      test('abs', () {
        check(Fraction(-2, -3).abs()).isFraction(2, 3);
        check(Fraction(-2, 3).abs()).isFraction(2, 3);
        check(Fraction(2, -3).abs()).isFraction(2, 3);
        check(Fraction(2, 3).abs()).isFraction(2, 3);
        check(Fraction.zero.abs()).isFraction(0);
        check(Fraction.nan.abs()).isFraction(0, 0);
        check(Fraction.infinity.abs()).isFraction(1, 0);
        check(Fraction.negativeInfinity.abs()).isFraction(1, 0);
      });
      test('sign', () {
        check(Fraction(-2, -3).sign).equals(1);
        check(Fraction(-2, 3).sign).equals(-1);
        check(Fraction(2, -3).sign).equals(-1);
        check(Fraction(2, 3).sign).equals(1);
        check(Fraction.zero.sign).equals(0);
        check(Fraction.nan.sign).equals(0);
        check(Fraction.infinity.sign).equals(1);
        check(Fraction.negativeInfinity.sign).equals(-1);
      });
      test('round', () {
        check(Fraction(2, 3).round()).equals(1);
        check(Fraction(-2, 3).round()).equals(-1);
      });
      test('floor', () {
        check(Fraction(2, 3).floor()).equals(0);
        check(Fraction(-2, 3).floor()).equals(-1);
      });
      test('ceil', () {
        check(Fraction(2, 3).ceil()).equals(1);
        check(Fraction(-2, 3).ceil()).equals(0);
      });
      test('truncate', () {
        check(Fraction(2, 3).truncate()).equals(0);
        check(Fraction(-5, 3).truncate()).equals(-1);
      });
    });
    group('comparing', () {
      test('close', () {
        check(Fraction(1, 2).closeTo(Fraction(1, 3), 0.1)).isFalse();
        check(Fraction(1, 2).closeTo(Fraction(2, 4), 0.1)).isTrue();
        check(Fraction(1, 2).closeTo(Fraction(3, 5), 0.2)).isTrue();
        check(Fraction.nan.closeTo(Fraction(1, 2), 0.1)).isFalse();
        check(Fraction(1, 2).closeTo(Fraction.nan, 0.1)).isFalse();
        check(Fraction.nan.closeTo(Fraction.nan, 0.1)).isFalse();
        check(Fraction.infinity.closeTo(Fraction(1, 2), 0.1)).isFalse();
        check(Fraction(1, 2).closeTo(Fraction.infinity, 0.1)).isFalse();
        check(Fraction.infinity.closeTo(Fraction.infinity, 0.1)).isFalse();
        check(Fraction.negativeInfinity.closeTo(Fraction(1, 2), 0.1)).isFalse();
        check(Fraction(1, 2).closeTo(Fraction.negativeInfinity, 0.1)).isFalse();
        check(Fraction.negativeInfinity.closeTo(Fraction.negativeInfinity, 0.1))
            .isFalse();
      });
      test('equals', () {
        check(Fraction(2, 3) == Fraction(2, 3)).isTrue();
        check(Fraction(2, 3) == Fraction(4, 5)).isFalse();
        check(Fraction(4, 5) == Fraction(2, 3)).isFalse();
        check(Fraction.nan == Fraction(2, 3)).isFalse();
        check(Fraction(2, 3) == Fraction.nan).isFalse();
        check(Fraction.nan == Fraction.nan).isFalse();
        check(Fraction.infinity == Fraction.infinity).isTrue();
        check(Fraction.negativeInfinity == Fraction.negativeInfinity).isTrue();
      });
      test('hash', () {
        check(Fraction(2, 3).hashCode).equals(Fraction(2, 3).hashCode);
        check(Fraction(2, 3).hashCode)
            .not((it) => it.equals(Fraction(3, 2).hashCode));
      });
      test('<', () {
        check(Fraction(2, 3) < Fraction(2, 3)).isFalse();
        check(Fraction(2, 3) < Fraction(4, 5)).isTrue();
        check(Fraction(4, 5) < Fraction(2, 3)).isFalse();
      });
      test('<=', () {
        check(Fraction(2, 3) <= Fraction(2, 3)).isTrue();
        check(Fraction(2, 3) <= Fraction(4, 5)).isTrue();
        check(Fraction(4, 5) <= Fraction(2, 3)).isFalse();
      });
      test('>=', () {
        check(Fraction(2, 3) >= Fraction(2, 3)).isTrue();
        check(Fraction(2, 3) >= Fraction(4, 5)).isFalse();
        check(Fraction(4, 5) >= Fraction(2, 3)).isTrue();
      });
      test('>', () {
        check(Fraction(2, 3) > Fraction(2, 3)).isFalse();
        check(Fraction(2, 3) > Fraction(4, 5)).isFalse();
        check(Fraction(4, 5) > Fraction(2, 3)).isTrue();
      });
      test('==', () {
        check(Fraction(2, 3) == Fraction(2, 3)).isTrue();
        check(Fraction(2, 3) == Fraction(4, 5)).isFalse();
        check(Fraction(4, 5) == Fraction(2, 3)).isFalse();
      });
    });
    group('converting', () {
      test('toInt', () {
        check(Fraction(1, 2).toInt()).equals(0);
        check(Fraction(5, 4).toInt()).equals(1);
        check(() => Fraction.nan.toInt()).throws<UnsupportedError>();
        check(() => Fraction.infinity.toInt()).throws<UnsupportedError>();
        check(() => Fraction.negativeInfinity.toInt())
            .throws<UnsupportedError>();
      });
      test('toDouble', () {
        check(Fraction(1, 2).toDouble()).equals(0.5);
        check(Fraction(5, 4).toDouble()).equals(1.25);
        check(Fraction.nan.toDouble().isNaN).isTrue();
        check(Fraction.infinity.toDouble()).equals(double.infinity);
        check(Fraction.negativeInfinity.toDouble())
            .equals(double.negativeInfinity);
      });
      test('toString', () {
        check(Fraction(1, 2).toString()).equals('Fraction(1, 2)');
        check(Fraction(5, 4).toString()).equals('Fraction(5, 4)');
        check(Fraction(6).toString()).equals('Fraction(6)');
        check(Fraction(-6).toString()).equals('Fraction(-6)');
        check(Fraction.nan.toString()).equals('Fraction.nan');
        check(Fraction.infinity.toString()).equals('Fraction.infinity');
        check(Fraction.negativeInfinity.toString())
            .equals('Fraction.negativeInfinity');
      });
    });
  });
}
