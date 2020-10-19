import 'package:collection/collection.dart' show QueueList;
import 'package:meta/meta.dart' show immutable;

import '../../hash.dart';
import '../../math.dart';
import 'mixins/close_to.dart';

/// A rational number.
@immutable
class Fraction implements Comparable<Fraction>, CloseTo<Fraction> {
  /// The neutral additive element, that is `0`.
  static const Fraction zero = Fraction._(0, 1);

  /// The neutral multiplicative element, that is `1`.
  static const Fraction one = Fraction._(1, 1);

  /// Infinite iterable over all positive fractions.
  ///
  /// This is the breadth-first traversal of the Calkin–Wilf tree:
  /// https://en.m.wikipedia.org/wiki/Calkin%E2%80%93Wilf_tree
  static Iterable<Fraction> get positive sync* {
    final pending = QueueList.from([Fraction.one]);
    for (;;) {
      final current = pending.removeFirst();
      pending.addLast(Fraction._(current.a, current.a + current.b));
      pending.addLast(Fraction._(current.a + current.b, current.b));
      yield current;
    }
  }

  /// Creates a fraction from a [numerator] and an optional [denominator].
  factory Fraction(int numerator, [int denominator = 1]) {
    if (denominator == 0) {
      throw ArgumentError('Denominator needs to be non-zero.');
    }
    var d = numerator.gcd(denominator).abs();
    if (denominator < 0) {
      d *= -1;
    }
    if (d != 1) {
      return Fraction._(numerator ~/ d, denominator ~/ d);
    }
    return Fraction._(numerator, denominator);
  }

  /// Creates an approximate fraction from a floating point [value].
  factory Fraction.fromDouble(num value, [num maxDenominator = 1e10]) {
    if (value.isInfinite || value.isNaN) {
      throw ArgumentError('$value cannot be represented as fraction');
    }
    final sign = value < 0
        ? -1
        : value > 0
            ? 1
            : 0;
    if (sign == 0) {
      return Fraction.zero;
    }
    value *= sign;
    var numerator1 = value.floor(), numerator2 = 1;
    var denominator1 = 1, denominator2 = 0;
    var integerPart = numerator1;
    var fractionPart = value - numerator1;
    while (fractionPart != 0) {
      final newValue = 1.0 / fractionPart;
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
          return Fraction(sign * numerator1, denominator1);
        } else {
          return Fraction(sign * numerator2, denominator2);
        }
      }
    }
    return Fraction(sign * numerator1, denominator1);
  }

  /// Parses [source] as a [Fraction]. Returns `null` in case of a problem.
  static Fraction? tryParse(String source) {
    final values = source.split('/');
    final numerator = values.isNotEmpty ? int.tryParse(values[0]) : null;
    final denominator = values.length > 1 ? int.tryParse(values[1]) : 1;
    if (values.length > 2 || numerator == null || denominator == null) {
      return null;
    }
    return Fraction(numerator, denominator);
  }

  /// Internal constructor for fractions.
  const Fraction._(this.a, this.b) : assert(b > 0, 'b must be positive');

  /// Returns the numerator of the fraction.
  final int a;

  /// Alternative way to access the numerator of the fraction.
  num get numerator => a;

  /// Returns the denominator of the fraction.
  final int b;

  /// Alternative way to access the denominator of the fraction.
  num get denominator => b;

  /// Returns the negation of this fraction.
  Fraction operator -() => Fraction._(-a, b);

  /// Returns the sum of this fraction and [other].
  Fraction operator +(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.b + other.a * b, b * other.b);
    } else if (other is int) {
      return Fraction(a + other * b, b);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the difference of this fraction and [other].
  Fraction operator -(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.b - other.a * b, b * other.b);
    } else if (other is int) {
      return Fraction(a - other * b, b);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the multiplicative inverse of this fraction.
  Fraction reciprocal() => isNegative ? Fraction._(-b, -a) : Fraction._(b, a);

  /// Returns the multiplication of this fraction and [other].
  Fraction operator *(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.a, b * other.b);
    } else if (other is int) {
      return Fraction(a * other, b);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the division of this fraction and [other].
  Fraction operator /(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.b, b * other.a);
    } else if (other is int) {
      return Fraction(a, b * other);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the power of this fraction.
  Fraction pow(int n) {
    if (a == 0) {
      return this;
    }
    if (n > 0) {
      return Fraction(a.pow(n).toInt(), b.pow(n).toInt());
    } else if (n < 0) {
      return Fraction(b.pow(-n).toInt(), a.pow(-n).toInt());
    } else {
      return one;
    }
  }

  /// Tests if this fraction is not defined.
  bool get isNaN => false;

  /// Tests if this fraction is negative.
  bool get isNegative => a.isNegative;

  /// Tests if this fraction is infinite.
  bool get isInfinite => false;

  /// Returns the absolute value of this fraction.
  Fraction abs() => isNegative ? -this : this;

  /// Returns the sign of this fraction.
  int get sign => a.sign;

  /// Rounds this fraction to an integer.
  int round() => toDouble().round();

  /// Floors this fraction to an integer.
  int floor() => toDouble().floor();

  /// Ceils this fraction to an integer.
  int ceil() => toDouble().ceil();

  /// Truncates this fraction to an integer.
  int truncate() => toDouble().truncate();

  /// Converts this fraction to an integer.
  int toInt() => a ~/ b;

  /// Converts this fraction to a double.
  double toDouble() => a / b;

  @override
  bool closeTo(Fraction other, double epsilon) =>
      (toDouble() - other.toDouble()).abs() < epsilon;

  @override
  bool operator ==(Object other) =>
      other is Fraction && a == other.a && b == other.b;

  @override
  int get hashCode => hash2(a, b);

  @override
  int compareTo(Fraction other) => (a * other.b).compareTo(other.a * b);

  bool operator <(Fraction other) => compareTo(other) < 0;

  bool operator <=(Fraction other) => compareTo(other) <= 0;

  bool operator >=(Fraction other) => compareTo(other) >= 0;

  bool operator >(Fraction other) => compareTo(other) > 0;

  @override
  String toString() => 'Fraction($a, $b)';
}
