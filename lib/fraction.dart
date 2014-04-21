/**
 * Support for exact rational number arithmetic.
 */
library fraction;

import 'int_math.dart' as int_math;

/**
 * A rational number.
 */
class Fraction implements Comparable<Fraction> {

  /**
   * The neutral additive element, i.e. `0`.
   */
  static const Fraction ZERO = const Fraction._(0, 1);

  /**
   * The neutral multiplicative element, i.e. `1`.
   */
  static const Fraction ONE = const Fraction._(1, 1);

  /**
   * Constructs a fraction from a [numerator] and an optional [denominator].
   */
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

  /**
   * Constructs an approximative fraction from a floating point [value].
   */
  factory Fraction.fromDouble(num value, [num max_denominator = 1e10]) {
    if (value.isInfinite || value.isNaN) {
      throw new ArgumentError('${value} cannot be represented as fraction');
    }
    var sign = value < 0.0 ? -1 : 1; value *= sign;
    var numerator_1 = value.floor(), numerator_2 = 1;
    var denominator_1 = 1, denominator_2 = 0;
    var integer_part = numerator_1;
    var fraction_part = value - numerator_1;
    while (fraction_part != 0) {
      var new_value = 1.0 / fraction_part;
      integer_part = new_value.floor();
      fraction_part = new_value - integer_part;
      var temporary = numerator_2;
      numerator_2 = numerator_1;
      numerator_1 = numerator_1 * integer_part + temporary;
      temporary = denominator_2;
      denominator_2 = denominator_1;
      denominator_1 = integer_part * denominator_1 + temporary;
      if (max_denominator < denominator_1) {
        if (numerator_2 == 0.0) {
          return new Fraction(sign * numerator_1, denominator_1);
        } else {
          return new Fraction(sign * numerator_2, denominator_2);
        }
      }
    }
    return new Fraction(sign * numerator_1, denominator_1);
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
  bool operator ==(other) {
    return other is Fraction && numerator == other.numerator && denominator == other.denominator;
  }

  @override
  int get hashCode {
    return numerator.hashCode + denominator.hashCode;
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
