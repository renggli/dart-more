// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 *
 */
library fraction;

import 'package:more/int_math.dart';

class Fraction implements Comparable<Fraction> {

  factory Fraction(int numerator, [int denominator = 1]) {
    var d = gcd(numerator, denominator);
    return new Fraction._(numerator ~/ d, denominator ~/ d);
  }

  factory Fraction.fromDouble(double value) {

  }

  final int _numerator;
  final int _denominator;

  Fraction._(this._numerator, this._denominator);

  Fraction operator + (Fraction other) {

  }

  Fraction operator - (Fraction other) {

  }

  Fraction operator * (Fraction other) {

  }

  Fraction operator / (Fraction other) {

  }

  Fraction operator - () {
    return new Fraction._(-_numerator, _denominator);
  }

  double toDouble() => _numerator / _denominator;

  int toInt() => _numerator ~/ _denominator;

  String toString() => '$_numerator / $_denominator';

}