import 'dart:math' as math;

import 'package:meta/meta.dart' show immutable;

import '../../math.dart';
import 'mixins/close_to.dart';
import 'utils.dart';

/// A complex number of the form `a + b*i`.
@immutable
class Complex implements CloseTo<Complex> {
  /// Creates a complex number from a real part [a] and an imaginary part [b].
  const Complex(this.a, [this.b = 0]);

  /// Creates a complex number from a real number [a].
  factory Complex.fromReal(num a) => Complex(a);

  /// Creates a complex number from an imaginary number [b].
  factory Complex.fromImaginary(num b) => Complex(0, b);

  /// Creates a complex number from cartesian coordinates [a] and [b].
  const factory Complex.fromCartesian(num a, num b) = Complex;

  /// Creates a complex number from polar coordinates [radius] and [phase].
  factory Complex.fromPolar(num radius, num phase) =>
      Complex(radius * phase.cos(), radius * phase.sin());

  /// Parses [source] as a [Complex]. Throws a [FormatException] for invalid input.
  factory Complex.parse(String source) {
    final parts = parseWithUnits(source, units: const {'', 'i'});
    if (parts == null) throw FormatException(source);
    return Complex(parts[''] ?? 0, parts['i'] ?? 0);
  }

  /// Parses [source] as a [Complex]. Returns `null` in case of a problem.
  static Complex? tryParse(String source) {
    final parts = parseWithUnits(source, units: const {'', 'i'});
    if (parts == null) return null;
    return Complex(parts[''] ?? 0, parts['i'] ?? 0);
  }

  /// The neutral additive element, that is `0`.
  static const Complex zero = Complex(0);

  /// The neutral multiplicative element, that is `1`.
  static const Complex one = Complex(1);

  /// The imaginary number, that is `i`.
  static const Complex i = Complex(0, 1);

  /// The complex number with both real and imaginary part to be [double.nan].
  static const Complex nan = Complex(double.nan, double.nan);

  /// The complex number with both real and imaginary part to be [double.infinity].
  static const Complex infinity = Complex(double.infinity, double.infinity);

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
  double abs() => norm().sqrt();

  /// Returns the closest point on the unit circle.
  Complex get sign {
    final absolute = abs();
    return absolute > 0 ? this / absolute : Complex.zero;
  }

  /// Returns the squared magnitude.
  num norm() => a * a + b * b;

  /// Returns the phase of the value in polar coordinates.
  double arg() => b.atan2(a);

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
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Returns the difference of this complex value and [other].
  Complex operator -(Object other) {
    if (other is Complex) {
      return Complex(a - other.a, b - other.b);
    } else if (other is num) {
      return Complex(a - other, b);
    } else {
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Returns the multiplication of this complex value and [other].
  Complex operator *(Object other) {
    if (other is Complex) {
      return Complex(a * other.a - b * other.b, a * other.b + b * other.a);
    } else if (other is num) {
      return Complex(a * other, b * other);
    } else {
      throw ArgumentError.value(other, 'other', 'Invalid type');
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
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Computes the exponential function of this complex number.
  Complex exp() {
    final exp = a.exp();
    return Complex(exp * b.cos(), exp * b.sin());
  }

  /// Computes the natural logarithm of this complex number.
  Complex log() => Complex(norm().sqrt().log(), b.atan2(a));

  /// Computes the power of this complex number raised to [exponent].
  Complex pow(Object exponent) => (log() * exponent).exp();

  /// Computes the square of this complex number.
  Complex square() => Complex(a * a - b * b, 2 * a * b);

  /// Computes the square root of this complex number.
  Complex sqrt() {
    final r = abs(), s = this + r;
    return s / s.abs() * r.sqrt();
  }

  /// Computes the n-th roots of this complex number.
  List<Complex> roots(int n) {
    if (n == 0) {
      throw ArgumentError.value(n, 'n', 'Expected non-zero root');
    }
    final root = abs().pow(1 / n);
    final phiBase = arg() / n;
    final phiOffset = 2 * math.pi / n;
    return List.generate(
      n.abs(),
      (i) => Complex.fromPolar(root, phiBase + i * phiOffset),
      growable: false,
    );
  }

  /// Computes the cosine of this complex number.
  Complex cos() => Complex(a.cos() * b.cosh(), -a.sin() * b.sinh());

  /// Computes the arc-cosine of this complex number.
  Complex acos() => (this + i * (one - square()).sqrt()).log() * -i;

  /// Computes the hyperbolic cosine of this complex number.
  Complex cosh() => Complex(a.cosh() * b.cos(), a.sinh() * b.sin());

  /// Computes the hyperbolic arc-cosine of this complex number.
  Complex acosh() => ((square() - 1).sqrt() + this).log();

  /// Computes the sine of this complex number.
  Complex sin() => Complex(a.sin() * b.cosh(), -a.cos() * b.sinh());

  /// Computes the arc-sine of this complex number.
  Complex asin() => (this * i + (one - square()).sqrt()).log() * -i;

  /// Computes the hyperbolic sine of this complex number.
  Complex sinh() => Complex(a.sinh() * b.cos(), a.cosh() * b.sin());

  /// Computes the hyperbolic arc-sine of this complex number.
  Complex asinh() => ((square() + 1).sqrt() + this).log();

  /// Computes the tangent of this complex number.
  Complex tan() {
    final a2 = 2 * a, b2 = 2 * b;
    final d = a2.cos() + b2.cosh();
    return Complex(a2.sin() / d, b2.sinh() / d);
  }

  /// Computes the arc-tangent of this complex number.
  Complex atan() => ((this + i) / (i - this)).log() * i * 0.5;

  /// Computes the hyperbolic tangent of this complex number.
  Complex tanh() {
    final a2 = 2 * a, b2 = 2 * b;
    final d = a2.cosh() + b2.cos();
    return Complex(a2.sinh() / d, b2.sin() / d);
  }

  /// Computes the hyperbolic arc-tangent of this complex number.
  Complex atanh() => ((this + one) / (one - this)).log() * 0.5;

  /// Tests if this complex number is not defined.
  bool get isNaN => a.isNaN || b.isNaN;

  /// Tests if this complex number is infinite.
  bool get isInfinite => a.isInfinite || b.isInfinite;

  /// Tests if this complex number is finite.
  bool get isFinite => a.isFinite && b.isFinite;

  /// Rounds the values of this complex number to integers.
  Complex round() => Complex(a.round(), b.round());

  /// Floors the values of this complex number to integers.
  Complex floor() => Complex(a.floor(), b.floor());

  /// Ceils the values of this complex number to integers.
  Complex ceil() => Complex(a.ceil(), b.ceil());

  /// Truncates the values of this complex number to integers.
  Complex truncate() => Complex(a.truncate(), b.truncate());

  @override
  bool closeTo(Complex other, num epsilon) =>
      isFinite && other.isFinite && (this - other).abs() <= epsilon;

  @override
  bool operator ==(Object other) =>
      other is Complex && a == other.a && b == other.b;

  @override
  int get hashCode => Object.hash(a, b);

  @override
  String toString() => 'Complex($a, $b)';
}
