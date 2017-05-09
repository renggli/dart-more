/// Support for exact rational number arithmetic.
library more.fraction;

import 'int_math.dart' as int_math;

/// A rational number.
class Fraction implements Comparable<Fraction> {

  /// The neutral additive element, i.e. `0`.
  static const Fraction zero = const Fraction._(0, 1);

  /// The neutral multiplicative element, i.e. `1`.
  static const Fraction one = const Fraction._(1, 1);

  /// Constructs a fraction from a [numerator] and an optional [denominator].
  factory Fraction(int numerator, [int denominator = 1]) {
    if (numerator == null || denominator == null) {
      throw new ArgumentError('Null numerator or denominator passed to fraction.');
    }
    if (denominator == 0) {
      throw new ArgumentError('Denominator needs to be non-zero.');
    }
    var d = int_math.gcd(numerator, denominator).abs();
    if (denominator < 0) {
      d *= -1;
    }
    return new Fraction._(numerator ~/ d, denominator ~/ d);
  }

  /// Constructs an approximate fraction from a floating point [value].
  factory Fraction.fromDouble(num value, [num maxDenominator = 1e10]) {
    if (value.isInfinite || value.isNaN) {
      throw new ArgumentError('$value cannot be represented as fraction');
    }
    var sign = value < 0.0 ? -1 : 1;
    value *= sign;
    var numerator1 = value.floor(),
        numerator2 = 1;
    var denominator1 = 1,
        denominator2 = 0;
    var integerPart = numerator1;
    var fractionPart = value - numerator1;
    while (fractionPart != 0) {
      var newValue = 1.0 / fractionPart;
      integerPart = newValue.floor();
      fractionPart = newValue - integerPart;
      var temporary = numerator2;
      numerator2 = numerator1;
      numerator1 = numerator1 * integerPart + temporary;
      temporary = denominator2;
      denominator2 = denominator1;
      denominator1 = integerPart * denominator1 + temporary;
      if (maxDenominator < denominator1) {
        if (numerator2 == 0.0) {
          return new Fraction(sign * numerator1, denominator1);
        } else {
          return new Fraction(sign * numerator2, denominator2);
        }
      }
    }
    return new Fraction(sign * numerator1, denominator1);
  }

  final int numerator;
  final int denominator;

  const Fraction._(this.numerator, this.denominator);

  Fraction operator +(Fraction other) {
    return new Fraction(numerator * other.denominator + other.numerator * denominator,
        denominator * other.denominator);
  }

  Fraction operator -(Fraction other) {
    return new Fraction(numerator * other.denominator - other.numerator * denominator,
        denominator * other.denominator);
  }

  Fraction operator *(Fraction other) {
    return new Fraction(numerator * other.numerator, denominator * other.denominator);
  }

  Fraction operator /(Fraction other) {
    return new Fraction(numerator * other.denominator, denominator * other.numerator);
  }

  Fraction operator -() {
    return new Fraction._(-numerator, denominator);
  }

  bool get isNaN => false;

  bool get isNegative => numerator.isNegative;

  bool get isInfinite => false;

  Fraction abs() => isNegative ? -this : this;

  int round() => toDouble().round();
  int floor() => toDouble().floor();
  int ceil() => toDouble().ceil();
  int truncate() => toDouble().truncate();

  int toInt() => numerator ~/ denominator;
  double toDouble() => numerator / denominator;

  @override
  bool operator ==(Object other) {
    return other is Fraction && numerator == other.numerator && denominator == other.denominator;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + numerator.hashCode;
    result = 37 * result + denominator.hashCode;
    return result;
  }

  @override
  int compareTo(Fraction other) {
    return (numerator * other.denominator).compareTo(other.numerator * denominator);
  }

  bool operator <(Fraction other) => compareTo(other) < 0;

  bool operator <=(Fraction other) => compareTo(other) <= 0;

  bool operator >=(Fraction other) => compareTo(other) >= 0;

  bool operator >(Fraction other) => compareTo(other) > 0;

  @override
  String toString() => denominator == 1 ? '$numerator' : '$numerator/$denominator';
}
