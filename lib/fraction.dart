// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 *
 */
library fraction;

import 'package:more/int_math.dart';

class Fraction implements Comparable<Fraction> {

  /**
   * Constructs a fraction from a [numerator] and an optional [denominator].
   */
  factory Fraction(int numerator, [int denominator = 1]) {
    if (numerator is! int) {
      throw new ArgumentError('Numerator needs to be int.');
    }
    if (denominator is! int || denominator == 0) {
      throw new ArgumentError('Denominator needs to be non-zero.');
    }
    var d = gcd(numerator, denominator);
    if (denominator < 0) {
      d *= -1;
    }
    return new Fraction._(numerator ~/ d, denominator ~/ d);
  }

  /**
   * Constructs an approximative fraction from a floating point [value].
   */
  factory Fraction.fromDouble(double value, [int maxDenominator = 1000]) {
    if (value.isInfinite || value.isNaN) {
      throw new ArgumentError('${value} cannot be represented as fraction');
    }
    var sign = value < 0 ? -1 : 1;
    var input = value.abs();
    var whole = 0;
    if (input > 1.0) {
      whole = input.truncate();
      input -= whole;
    }
    var low_n = 0, low_d = 1;
    var high_n = 1,  high_d = 1;
    var mid_n, mid_d, res_n, res_d;
    do {
      mid_n = low_n + high_n;
      mid_d = low_d + high_d;
      if (mid_n < input * mid_d) {
        low_n = mid_n;
        low_d = mid_d;
        res_n = high_n;
        res_d = high_d;
      } else {
        high_n = mid_n;
        high_d = mid_d;
        res_n = low_n;
        res_d = low_d;
      }
    } while (mid_d < maxDenominator);
    return new Fraction(sign * (res_n + whole * res_d), res_d);
  }

  final int numerator;
  final int denominator;

  Fraction._(this.numerator, this.denominator);

  Fraction operator + (Fraction other) {
    return new Fraction(numerator * other.denominator + other.numerator
        * denominator, denominator * other.denominator);
  }

  Fraction operator - (Fraction other) {
    return new Fraction(numerator * other.denominator - other.numerator
        * denominator, denominator * other.denominator);
  }

  Fraction operator * (Fraction other) {
    return new Fraction(numerator * other.numerator,
        denominator * other.denominator);
  }

  Fraction operator / (Fraction other) {
    return new Fraction(numerator * other.denominator,
        denominator * other.numerator);
  }

  Fraction operator - () {
    return new Fraction._(-numerator, denominator);
  }

  bool operator == (other) {
    return other is Fraction
        && numerator == other.numerator
        && denominator == other.denominator;
  }

  int get hashCode {
    return numerator.hashCode + denominator.hashCode;
  }

  int compareTo(Fraction other) {
    return numerator * other.denominator - other.numerator * denominator;
  }

  Fraction abs() {
    return numerator < 0 ? -this : this;
  }

  double toDouble() => numerator / denominator;

  int toInt() => numerator ~/ denominator;

  String toString() => '$numerator / $denominator';

}