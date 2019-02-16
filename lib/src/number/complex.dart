library more.number.complex;

import 'dart:math' as math;

/// A complex number of the form `a + b*i`.
class Complex {
  /// The neutral additive element, that is `0`.
  static const Complex zero = Complex(0, 0);

  /// The neutral multiplicative element, that is `1`.
  static const Complex one = Complex(1, 0);

  /// The imaginary number, that is `i`.
  static const Complex i = Complex(0, 1);

  /// Creates a complex number from a [real] and an [imaginary] parts.
  const Complex(this.a, [this.b = 0]);

  /// Creates a complex number from a [real] number.
  factory Complex.fromReal(num real) => Complex(real, 0);

  /// Creates a complex number from cartesian coordinates [a] and [b].
  factory Complex.fromCartesian(num a, num b) = Complex;

  /// Creates a complex number from polar coordinates [radius] and [phase].
  factory Complex.fromPolar(num radius, num phase) => Complex(
        radius * math.cos(phase),
        radius * math.sin(phase),
      );

  /// Returns the real part of the number.
  final num a;

  /// Alternative way to access the real part of the number.
  num get real => a;

  /// Returns the imaginary part of the number.
  final num b;

  /// Alternative way to access the imaginary part of the number.
  num get imaginary => b;

  /// Returns the radius of this complex value in polar coordinates.
  double abs() => math.sqrt(a * a + b * b);

  /// Returns the phase of the value in polar coordinates.
  double arg() => math.atan2(b, a);

  /// Returns the negated form of this number.
  Complex operator -() => Complex(-a, -b);

  /// Returns the conjugate form of this number.
  Complex conjugate() => Complex(a, -b);

  /// Returns the sum of this complex value and [other].
  Complex operator +(Complex other) => Complex(a + other.a, b + other.b);

  /// Returns the difference of this complex value and [other].
  Complex operator -(Complex other) => Complex(a - other.a, b - other.b);

  /// Returns the multiplication of this complex value and [other].
  Complex operator *(Complex other) => Complex(
        a * other.a - b * other.b,
        a * other.b + b * other.a,
      );

  /// Returns the multiplicative inverse of this complex value.
  Complex reciprocal() {
    final det = 1.0 / (a * a + b * b);
    return Complex(a * det, b * -det);
  }

  /// Returns the division of this complex value and [other].
  Complex operator /(Complex other) {
    final det = 1.0 / (other.a * other.a + other.b * other.b);
    return Complex(
      (a * other.a + b * other.b) * det,
      (b * other.a - a * other.b) * det,
    );
  }

  /// Compute the exponential function of this complex number.
  Complex exp() {
    final exp = math.exp(a);
    return Complex(
      exp * math.cos(b),
      exp * math.sin(b),
    );
  }

  /// Compute the natural logarithm of this complex number.
  Complex log() => Complex(
        math.log(math.sqrt(a * a + b * b)),
        math.atan2(b, a),
      );

  /// Compute the power of this complex number raised to `exponent`.
  Complex pow(Complex exponent) => (log() * exponent).exp();

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
  int get hashCode => (0x0007ffff & a.hashCode) << 10 ^ b.hashCode;

  @override
  String toString() => 'Complex($a, $b)';
}
