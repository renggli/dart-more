library fraction_test;

import 'package:unittest/unittest.dart';
import 'package:more/fraction.dart';

void main() {
  group('fraction', () {
    group('construction', () {
      test('irreducible', () {
        var fraction = new Fraction(3, 7);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('reducible', () {
        var fraction = new Fraction(15, 35);
        expect(fraction.numerator, 3);
        expect(fraction.denominator, 7);
      });
      test('normal negative', () {
        var fraction = new Fraction(-2, 4);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('double negative', () {
        var fraction = new Fraction(-2, -4);
        expect(fraction.numerator, 1);
        expect(fraction.denominator, 2);
      });
      test('denominator negative', () {
        var fraction = new Fraction(2, -4);
        expect(fraction.numerator, -1);
        expect(fraction.denominator, 2);
      });
      test('numerator error', () {
        expect(() => new Fraction(null), throwsArgumentError);
      });
      test('denominator error', () {
        expect(() => new Fraction(2, 0), throwsArgumentError);
        expect(() => new Fraction(2, null), throwsArgumentError);
      });
      test('double basic', () {
        expect(new Fraction.fromDouble(2), new Fraction(2));
        expect(new Fraction.fromDouble(100), new Fraction(100));
      });
      test('double finite', () {
        expect(new Fraction.fromDouble(1 / 2), new Fraction(1, 2));
        expect(new Fraction.fromDouble(1 / 4), new Fraction(1, 4));
      });
      test('double finite (whole)', () {
        expect(new Fraction.fromDouble(5 / 2), new Fraction(5, 2));
        expect(new Fraction.fromDouble(9 / 4), new Fraction(9, 4));
      });
      test('double infinite', () {
        expect(new Fraction.fromDouble(1 / 3), new Fraction(1, 3));
        expect(new Fraction.fromDouble(1 / 7), new Fraction(1, 7));
      });
      test('double infinite (whole)', () {
        expect(new Fraction.fromDouble(5 / 3), new Fraction(5, 3));
        expect(new Fraction.fromDouble(9 / 7), new Fraction(9, 7));
      });
      test('double negative', () {
        expect(new Fraction.fromDouble(-1 / 3), new Fraction(-1, 3));
        expect(new Fraction.fromDouble(-5 / 3), new Fraction(-5, 3));
      });
      test('double all', () {
        for (var num = -10; num <= 10; num++) {
          for (var den = -10; den <= 10; den++) {
            if (den != 0) {
              expect(new Fraction.fromDouble(num / den), new Fraction(num, den));
            }
          }
        }
      });
      test('double error', () {
        expect(() => new Fraction.fromDouble(double.NAN), throwsArgumentError);
        expect(() => new Fraction.fromDouble(double.INFINITY), throwsArgumentError);
        expect(() => new Fraction.fromDouble(double.NEGATIVE_INFINITY), throwsArgumentError);
      });
      test('zero', () {
        expect(Fraction.ZERO, new Fraction(0));
        expect(new Fraction(1, 2) + Fraction.ZERO, new Fraction(1, 2));
      });
      test('one', () {
        expect(Fraction.ONE, new Fraction(1));
        expect(new Fraction(1, 2) * Fraction.ONE, new Fraction(1, 2));
      });
    });
    group('arithmetic', () {
      test('addition', () {
        expect(new Fraction(1, 2) + new Fraction(1, 4), new Fraction(3, 4));
        expect(new Fraction(1, 2) + new Fraction(3, 4), new Fraction(5, 4));
        expect(new Fraction(1, 2) + new Fraction(1, 2), new Fraction(1));
      });
      test('substraction', () {
        expect(new Fraction(1, 2) - new Fraction(1, 4), new Fraction(1, 4));
        expect(new Fraction(1, 2) - new Fraction(3, 4), new Fraction(-1, 4));
        expect(new Fraction(1, 2) - new Fraction(1, 2), new Fraction(0));
      });
      test('multiplication', () {
        expect(new Fraction(2, 3) * new Fraction(1, 4), new Fraction(1, 6));
        expect(new Fraction(3, 4) * new Fraction(2, 5), new Fraction(3, 10));
      });
      test('division', () {
        expect(new Fraction(2, 3) / new Fraction(1, 4), new Fraction(8, 3));
        expect(new Fraction(3, 4) / new Fraction(2, 5), new Fraction(15, 8));
      });
      test('negate', () {
        expect(-new Fraction(2, 3), new Fraction(-2, 3));
      });
      test('abs', () {
        expect(new Fraction(-2, -3).abs(), new Fraction(2, 3));
        expect(new Fraction(-2, 3).abs(), new Fraction(2, 3));
        expect(new Fraction(2, -3).abs(), new Fraction(2, 3));
        expect(new Fraction(2, 3).abs(), new Fraction(2, 3));
      });
      test('round', () {
        expect(new Fraction(2, 3).round(), 1);
        expect(new Fraction(-2, 3).round(), -1);
      });
      test('floor', () {
        expect(new Fraction(2, 3).floor(), 0);
        expect(new Fraction(-2, 3).floor(), -1);
      });
      test('ceil', () {
        expect(new Fraction(2, 3).ceil(), 1);
        expect(new Fraction(-2, 3).ceil(), 0);
      });
      test('truncate', () {
        expect(new Fraction(2, 3).truncate(), 0);
        expect(new Fraction(-5, 3).truncate(), -1);
      });
    });
    group('comparing', () {
      test('compareTo', () {
        expect(new Fraction(2, 3).compareTo(new Fraction(2, 3)), 1.compareTo(1));
        expect(new Fraction(2, 3).compareTo(new Fraction(4, 5)), 1.compareTo(2));
        expect(new Fraction(4, 5).compareTo(new Fraction(2, 3)), 2.compareTo(1));
      });
      test('hash code', () {
        expect(new Fraction(2, 3).hashCode, isNot(new Fraction(3, 2).hashCode));
      });
      test('<', () {
        expect(new Fraction(2, 3) < new Fraction(2, 3), isFalse);
        expect(new Fraction(2, 3) < new Fraction(4, 5), isTrue);
        expect(new Fraction(4, 5) < new Fraction(2, 3), isFalse);
      });
      test('<=', () {
        expect(new Fraction(2, 3) <= new Fraction(2, 3), isTrue);
        expect(new Fraction(2, 3) <= new Fraction(4, 5), isTrue);
        expect(new Fraction(4, 5) <= new Fraction(2, 3), isFalse);
      });
      test('>=', () {
        expect(new Fraction(2, 3) >= new Fraction(2, 3), isTrue);
        expect(new Fraction(2, 3) >= new Fraction(4, 5), isFalse);
        expect(new Fraction(4, 5) >= new Fraction(2, 3), isTrue);
      });
      test('>', () {
        expect(new Fraction(2, 3) > new Fraction(2, 3), isFalse);
        expect(new Fraction(2, 3) > new Fraction(4, 5), isFalse);
        expect(new Fraction(4, 5) > new Fraction(2, 3), isTrue);
      });
      test('==', () {
        expect(new Fraction(2, 3) == new Fraction(2, 3), isTrue);
        expect(new Fraction(2, 3) == new Fraction(4, 5), isFalse);
        expect(new Fraction(4, 5) == new Fraction(2, 3), isFalse);
      });
    });
    group('converting', () {
      test('toInt', () {
        expect(new Fraction(1, 2).toInt(), 0);
        expect(new Fraction(5, 4).toInt(), 1);
      });
      test('toDouble', () {
        expect(new Fraction(1, 2).toDouble(), 0.5);
        expect(new Fraction(5, 4).toDouble(), 1.25);
      });
      test('toString', () {
        expect(new Fraction(1, 2).toString(), '1/2');
        expect(new Fraction(5, 4).toString(), '5/4');
        expect(new Fraction(6).toString(), '6');
        expect(new Fraction(-6).toString(), '-6');
      });
    });
  });
}
