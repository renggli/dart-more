import 'package:collection/collection.dart' show QueueList;
import 'package:meta/meta.dart' show immutable;

import '../../comparator.dart';
import '../../math.dart';
import 'mixins/close_to.dart';

/// A rational number.
@immutable
class Fraction
    with CompareOperators<Fraction>
    implements Comparable<Fraction>, CloseTo<Fraction> {
  /// Creates a fraction from a [numerator] and an optional [denominator].
  factory Fraction(int numerator, [int denominator = 1]) {
    if (denominator == 0) {
      return numerator == 0
          ? Fraction.nan
          : numerator < 0
          ? Fraction.negativeInfinity
          : Fraction.infinity;
    }
    var divisor = numerator.gcd(denominator);
    if (denominator < 0) {
      divisor *= -1;
    }
    return divisor == 1
        ? Fraction._(numerator, denominator)
        : Fraction._(numerator ~/ divisor, denominator ~/ divisor);
  }

  /// Creates an approximate fraction from a floating point [value].
  ///
  /// The algorithm uses an expansion of the continued fraction of the floating
  /// point value. The resulting fraction is returned once the [maxDenominator]
  /// has been reached, or the result is better than [absoluteError].
  factory Fraction.fromDouble(
    num value, {
    int maxDenominator = 1000000000,
    double absoluteError = 0.0,
  }) {
    if (value.isNaN) {
      return Fraction.nan;
    } else if (value.isInfinite) {
      return value < 0 ? Fraction.negativeInfinity : Fraction.infinity;
    }
    var sign = 1;
    if (value < 0) {
      sign = -1;
      value *= -1;
    }
    var numerator1 = value.floor(), denominator1 = 1;
    var numerator2 = 1, denominator2 = 0;
    var integerPart = numerator1;
    var fractionPart = value - numerator1.toDouble();
    while (fractionPart != 0.0 &&
        (value - numerator1 / denominator1).abs() > absoluteError) {
      final newValue = 1.0 / fractionPart;
      integerPart = newValue.floor();
      fractionPart = newValue - integerPart.toDouble();
      final temp1 = numerator2;
      numerator2 = numerator1;
      numerator1 = numerator1 * integerPart + temp1;
      final temp2 = denominator2;
      denominator2 = denominator1;
      denominator1 = denominator1 * integerPart + temp2;
      if (maxDenominator < denominator1) {
        return numerator2 == 0
            ? Fraction(sign * numerator1, denominator1)
            : Fraction(sign * numerator2, denominator2);
      }
    }
    return Fraction(sign * numerator1, denominator1);
  }

  /// Internal constructor for fractions.
  const Fraction._(this.a, this.b)
    : assert(b >= 0, 'b be greater or equal to 0');

  /// The neutral additive element, that is `0`.
  static const Fraction zero = Fraction._(0, 1);

  /// The neutral multiplicative element, that is `1`.
  static const Fraction one = Fraction._(1, 1);

  /// The fraction that is not a number.
  static const Fraction nan = Fraction._(0, 0);

  /// The infinite fraction.
  static const Fraction infinity = Fraction._(1, 0);

  /// The negative infinite fraction.
  static const Fraction negativeInfinity = Fraction._(-1, 0);

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

  /// Iterable over the Farey sequence of order [n].
  ///
  /// Returns an ordered sequence of the reduced fractions between _0_ and
  /// _1_ with denominators less than or equal to _order_.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Farey_sequence.
  static Iterable<Fraction> farey(int n, {bool ascending = true}) sync* {
    if (n < 1) throw ArgumentError.value(n, 'order', 'Expected positive');
    var (a, b, c, d) = (ascending ? 0 : 1, 1, ascending ? 1 : n - 1, n);
    yield Fraction._(a, b);
    while (c <= n && ascending || a > 0 && !ascending) {
      final k = (n + b) ~/ d;
      (a, b, c, d) = (c, d, k * c - a, k * d - b);
      yield Fraction._(a, b);
    }
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

  /// Returns the numerator of the fraction.
  final int a;

  /// Alternative way to access the numerator of the fraction.
  int get numerator => a;

  /// Returns the denominator of the fraction.
  final int b;

  /// Alternative way to access the denominator of the fraction.
  int get denominator => b;

  /// Returns the negation of this fraction.
  Fraction operator -() => Fraction._(-a, b);

  /// Returns the sum of this fraction and [other].
  Fraction operator +(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.b + other.a * b, b * other.b);
    } else if (other is int) {
      return Fraction(a + other * b, b);
    } else {
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Returns the difference of this fraction and [other].
  Fraction operator -(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.b - other.a * b, b * other.b);
    } else if (other is int) {
      return Fraction(a - other * b, b);
    } else {
      throw ArgumentError.value(other, 'other', 'Invalid type');
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
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Returns the division of this fraction and [other].
  Fraction operator /(Object other) {
    if (other is Fraction) {
      return Fraction(a * other.b, b * other.a);
    } else if (other is int) {
      return Fraction(a, b * other);
    } else {
      throw ArgumentError.value(other, 'other', 'Invalid type');
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
  bool get isNaN => a == 0 && b == 0;

  /// Tests if this fraction is negative.
  bool get isNegative => a < 0;

  /// Tests if this fraction is infinite.
  bool get isInfinite => a != 0 && b == 0;

  /// Tests if this fraction is finite.
  bool get isFinite => b != 0;

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
  bool closeTo(Fraction other, num epsilon) =>
      isFinite &&
      other.isFinite &&
      (toDouble() - other.toDouble()).abs() <= epsilon;

  @override
  bool operator ==(Object other) {
    if (other is! Fraction) {
      return false;
    }
    if (isNaN || other.isNaN) {
      return false;
    }
    return a == other.a && b == other.b;
  }

  @override
  int get hashCode => Object.hash(a, b);

  @override
  int compareTo(Fraction other) => (a * other.b).compareTo(other.a * b);

  @override
  String toString() {
    final buffer = StringBuffer('Fraction');
    if (isFinite) {
      buffer.write('($a');
      if (b != 1) {
        buffer.write(', $b');
      }
      buffer.write(')');
    } else if (isNaN) {
      buffer.write('.nan');
    } else if (isInfinite) {
      if (isNegative) {
        buffer.write('.negativeInfinity');
      } else {
        buffer.write('.infinity');
      }
    }
    return buffer.toString();
  }
}
