library more.number.complex;

import 'dart:math' as math;

/// A complex number.
class Complex {
  /// The neutral additive element, that is `0`.
  static const Complex zero = Complex(0, 0);

  /// The neutral multiplicative element, that is `1`.
  static const Complex one = Complex(1, 0);

  /// The imaginary number, that is `i`.
  static const Complex i = Complex(0, 1);

  /// Creates a complex number from a [real] and an [imaginary] parts.
  const Complex(this.real, this.imaginary);

  /// Creates a complex number from a [real] number.
  factory Complex.fromReal(num real) => Complex(real, 0);

  /// Creates a complex number from cartesian coordinates [x] and [y].
  factory Complex.fromCartesian(num x, num y) = Complex;

  /// Creates a complex number from polar coordinates [radius] and [phase].
  factory Complex.fromPolar(num radius, num phase) => Complex(
        radius * math.cos(phase),
        radius * math.sin(phase),
      );

  /// Returns the real part of the number.
  final num real;

  /// Returns the imaginary part of the number.
  final num imaginary;

  /// Returns the radius of this complex value in polar coordinates.
  double get abs => math.sqrt(real * real + imaginary * imaginary);

  /// Returns the phase of the value in polar coordinates.
  double get phase => math.atan2(imaginary, real);

  /// Returns the sum of this complex value and [other].
  Complex operator +(Complex other) => Complex(
        real + other.real,
        imaginary + other.imaginary,
      );

  /// Returns the difference of this complex value and [other].
  Complex operator -(Complex other) => Complex(
        real - other.real,
        imaginary - other.imaginary,
      );

  /// Returns the multiplication of this complex value and [other].
  Complex operator *(Complex other) => Complex(
        real * other.real - imaginary * other.imaginary,
        imaginary * other.real + real * other.imaginary,
      );

  /// Returns the division of this complex value and [other].
  Complex operator /(Complex other) {
    final det = other.real * other.real + other.imaginary * other.imaginary;
    return Complex(
      (real * other.real + imaginary * other.imaginary) / det,
      (imaginary * other.real - real * other.imaginary) / det,
    );
  }

  /// Returns the conjugate form of this complex value.
  Complex get conjugate => Complex(real, -imaginary);

  /// Returns the negated form of this complex value.
  Complex operator -() => Complex(-real, -imaginary);

  /// Tests if this complex number is not defined.
  bool get isNaN => real.isNaN || imaginary.isNaN;

  /// Tests if this complex number is infinite.
  bool get isInfinite => real.isInfinite || imaginary.isInfinite;

  @override
  bool operator ==(Object other) =>
      other is Complex && real == other.real && imaginary == other.imaginary;

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + real.hashCode;
    result = 37 * result + imaginary.hashCode;
    return result;
  }

  @override
  String toString() {
    final result = StringBuffer(real);
    if (!imaginary.isNegative) {
      result.write('+');
    }
    result.write(imaginary);
    result.write('i');
    return result.toString();
  }
}
