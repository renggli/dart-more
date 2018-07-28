library more.test.fraction_test;

import 'package:more/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('construction', () {
    test('irreducible', () {
      var fraction = Fraction(3, 7);
      expect(fraction.numerator, 3);
      expect(fraction.denominator, 7);
    });
    test('reducible', () {
      var fraction = Fraction(15, 35);
      expect(fraction.numerator, 3);
      expect(fraction.denominator, 7);
    });
    test('normal negative', () {
      var fraction = Fraction(-2, 4);
      expect(fraction.numerator, -1);
      expect(fraction.denominator, 2);
    });
    test('double negative', () {
      var fraction = Fraction(-2, -4);
      expect(fraction.numerator, 1);
      expect(fraction.denominator, 2);
    });
    test('denominator negative', () {
      var fraction = Fraction(2, -4);
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
      expect(() => Fraction.fromDouble(double.NAN), throwsArgumentError);
      expect(() => Fraction.fromDouble(double.INFINITY), throwsArgumentError);
      expect(() => Fraction.fromDouble(double.NEGATIVE_INFINITY),
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
}
