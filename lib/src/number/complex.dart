library more.number.complex;

import 'dart:math' as math;

import 'package:more/hash.dart' show hash2;
import 'package:more/math.dart' as math2;

/// A complex number of the form `a + b*i`.
class Complex {
  /// The neutral additive element, that is `0`.
  static const Complex zero = Complex(0);

  /// The neutral multiplicative element, that is `1`.
  static const Complex one = Complex(1);

  /// The imaginary number, that is `i`.
  static const Complex i = Complex(0, 1);

  /// Creates a complex number from a real part [a] and an imaginary part [b].
  const Complex(this.a, [this.b = 0])
      : assert(a != null, 'a number must not be null'),
        assert(b != null, 'b number must not be null');

  /// Creates a complex number from a real number [a].
  factory Complex.fromReal(num a) => Complex(a, 0);

  /// Creates a complex number from an imaginary number [b].
  factory Complex.fromImaginary(num b) => Complex(0, b);

  /// Creates a complex number from cartesian coordinates [a] and [b].
  factory Complex.fromCartesian(num a, num b) = Complex;

  /// Creates a complex number from polar coordinates [radius] and [phase].
  factory Complex.fromPolar(num radius, num phase) => Complex(
        radius * math.cos(phase),
        radius * math.sin(phase),
      );

  /// Parses [source] as a [Complex]. Returns `null` in case of a problem.
  factory Complex.tryParse(String source) {
    final parts = numberAndUnitExtractor
        .allMatches(source.replaceAll(' ', ''))
        .where((match) => match.start < match.end)
        .toList();
    if (parts.isEmpty) {
      return null;
    }
    num a = 0, b = 0;
    final seen = <String>{};
    for (final part in parts) {
      final number = num.tryParse(part.group(1));
      final unit = part.group(4).toLowerCase();
      if (seen.contains(unit)) {
        return null; // repeated unit
      }
      if (unit == '' && number != null) {
        a = number;
      } else if (part.group(1).isEmpty || number != null) {
        if (unit == 'i') {
          b = number ?? 1;
        } else {
          return null; // invalid unit
        }
      } else {
        return null; // parse error
      }
      seen.add(unit);
    }
    return Complex(a, b);
  }

  /// Returns the real part of the number.
  final num a;

  /// Alternative way to access the real part of the number.
  num get real => a;

  /// Returns the imaginary part of the number.
  final num b;

  /// Alternative way to access the imaginary part of the number.
  num get imaginary => b;

  /// Returns the radius of this complex value in polar coordinates, also called
  /// the magnitude of the complex number.
  double abs() => math.sqrt(norm());

  /// Returns the squared magnitude.
  num norm() => a * a + b * b;

  /// Returns the phase of the value in polar coordinates.
  double arg() => math.atan2(b, a);

  /// Returns the negated form of this number.
  Complex operator -() => Complex(-a, -b);

  /// Returns the conjugate form of this number.
  Complex conjugate() => Complex(a, -b);

  /// Returns the sum of this complex value and [other].
  Complex operator +(Object other) {
    if (other is Complex) {
      return Complex(a + other.a, b + other.b);
    } else if (other is num) {
      return Complex(a + other, b);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the difference of this complex value and [other].
  Complex operator -(Object other) {
    if (other is Complex) {
      return Complex(a - other.a, b - other.b);
    } else if (other is num) {
      return Complex(a - other, b);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the multiplication of this complex value and [other].
  Complex operator *(Object other) {
    if (other is Complex) {
      return Complex(a * other.a - b * other.b, a * other.b + b * other.a);
    } else if (other is num) {
      return Complex(a * other, b * other);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the multiplicative inverse of this complex value.
  Complex reciprocal() {
    final d = 1.0 / norm();
    return Complex(a * d, b * -d);
  }

  /// Returns the division of this complex value and [other].
  Complex operator /(Object other) {
    if (other is Complex) {
      final d = 1.0 / other.norm();
      return Complex(
        (a * other.a + b * other.b) * d,
        (b * other.a - a * other.b) * d,
      );
    } else if (other is num) {
      return Complex(a / other, b / other);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Computes the exponential function of this complex number.
  Complex exp() {
    final exp = math.exp(a);
    return Complex(
      exp * math.cos(b),
      exp * math.sin(b),
    );
  }

  /// Computes the natural logarithm of this complex number.
  Complex log() => Complex(math.log(math.sqrt(norm())), math.atan2(b, a));

  /// Computes the power of this complex number raised to `exponent`.
  Complex pow(Object exponent) => (log() * exponent).exp();

  /// Computes the square of this complex number.
  Complex square() => Complex(a * a - b * b, 2 * a * b);

  /// Computes the square root of this complex number.
  Complex sqrt() {
    final r = abs(), s = this + r;
    return s / s.abs() * math.sqrt(r);
  }

  /// Computes the n-th roots of this complex number.
  List<Complex> roots(int n) {
    if (n == 0) {
      throw ArgumentError.value(n, 'n', 'Can\'t compute 0th root.');
    }
    final root = math.pow(abs(), 1 / n);
    final phiBase = arg() / n;
    final phiOffset = 2 * math.pi / n;
    return List.generate(
      n.abs(),
      (i) => Complex.fromPolar(root, phiBase + i * phiOffset),
      growable: false,
    );
  }

  /// Computes the cosine of this complex number.
  Complex cos() => Complex(
        math.cos(a) * math2.cosh(b),
        -math.sin(a) * math2.sinh(b),
      );

  /// Computes the arc-cosine of this complex number.
  Complex acos() => (this + i * (one - square()).sqrt()).log() * -i;

  /// Computes the hyperbolic cosine of this complex number.
  Complex cosh() => Complex(
        math2.cosh(a) * math.cos(b),
        math2.sinh(a) * math.sin(b),
      );

  /// Computes the hyperbolic arc-cosine of this complex number.
  Complex acosh() => ((square() - 1).sqrt() + this).log();

  /// Computes the sine of this complex number.
  Complex sin() => Complex(
        math.sin(a) * math2.cosh(b),
        -math.cos(a) * math2.sinh(b),
      );

  /// Computes the arc-sine of this complex number.
  Complex asin() => (this * i + (one - square()).sqrt()).log() * -i;

  /// Computes the hyperbolic sine of this complex number.
  Complex sinh() => Complex(
        math2.sinh(a) * math.cos(b),
        math2.cosh(a) * math.sin(b),
      );

  /// Computes the hyperbolic arc-sine of this complex number.
  Complex asinh() => ((square() + 1).sqrt() + this).log();

  /// Computes the tangent of this complex number.
  Complex tan() {
    final d = math.cos(2 * a) + math2.cosh(2 * b);
    return Complex(math.sin(2 * a) / d, math2.sinh(2 * b) / d);
  }

  /// Computes the arc-tangent of this complex number.
  Complex atan() => ((this + i) / (i - this)).log() * i * 0.5;

  /// Computes the hyperbolic tangent of this complex number.
  Complex tanh() {
    final d = math2.cosh(2 * a) + math.cos(2 * b);
    return Complex(math2.sinh(2 * a) / d, math.sin(2 * b) / d);
  }

  /// Computes the hyperbolic arc-tangent of this complex number.
  Complex atanh() => ((this + one) / (one - this)).log() * 0.5;

  /// Tests if this complex number is not defined.
  bool get isNaN => a.isNaN || b.isNaN;

  /// Tests if this complex number is infinite.
  bool get isInfinite => a.isInfinite || b.isInfinite;

  /// Rounds the values of this complex number to integers.
  Complex round() => Complex(a.round(), b.round());

  /// Floors the values of this complex number to integers.
  Complex floor() => Complex(a.floor(), b.floor());

  /// Ceils the values of this complex number to integers.
  Complex ceil() => Complex(a.ceil(), b.ceil());

  /// Truncates the values of this complex number to integers.
  Complex truncate() => Complex(a.truncate(), b.truncate());

  /// Tests if this complex number is close to another complex number.
  bool closeTo(Complex other, double epsilon) => (this - other).abs() < epsilon;

  @override
  bool operator ==(Object other) =>
      other is Complex && a == other.a && b == other.b;

  @override
  int get hashCode => hash2(a, b);

  @override
  String toString() => 'Complex($a, $b)';
}

final RegExp numberAndUnitExtractor =
    RegExp(r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)\*?(\w?)', caseSensitive: false);
