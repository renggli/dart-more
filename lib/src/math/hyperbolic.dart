import 'dart:math' as math;

import 'math.dart';

/// Hyperbolic functions on [num].
///
/// Based on the polyfills given on
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math.
extension HyperbolicNumberExtension on num {
  /// Returns the hyperbolic sine of this [num].
  double sinh() {
    if (this == 0) return toDouble();
    final absValue = abs();
    if (absValue < 1e-5) {
      return toDouble() + (this * this * this) / 6.0;
    }
    if (absValue > 709 && isFinite) {
      final half = (absValue / 2).exp();
      final result = half * (half / 2);
      return isNegative ? -result : result;
    }
    final y = exp();
    return (y - 1 / y) / 2;
  }

  /// Returns the hyperbolic arc-sine of this [num].
  double asinh() {
    if (isNaN) return double.nan;
    if (isNegative) return -(-this).asinh();
    if (this < 1e-5) {
      return toDouble() - (this * this * this) / 6.0;
    }
    if (this > 1e8) {
      return log() + math.ln2;
    }
    return (this + (this * this + 1).sqrt()).log();
  }

  /// Returns the hyperbolic cosine of this [num].
  double cosh() {
    final absValue = abs();
    if (absValue > 709 && isFinite) {
      final half = (absValue / 2).exp();
      return half * (half / 2);
    }
    final y = exp();
    return (y + 1 / y) / 2;
  }

  /// Returns the hyperbolic arc-cosine of this [num].
  double acosh() {
    if (this < 1) return double.nan;
    if (this > 1e8) {
      return log() + math.ln2;
    }
    return (this + (this - 1).sqrt() * (this + 1).sqrt()).log();
  }

  /// Returns the hyperbolic tangent of this [num].
  double tanh() {
    if (this == 0) return toDouble();
    if (abs() < 1e-5) {
      return toDouble() - (this * this * this) / 3.0;
    }
    final a = exp(), b = (-this).exp();
    return a.isInfinite
        ? 1
        : b.isInfinite
        ? -1
        : (a - b) / (a + b);
  }

  /// Returns the hyperbolic arc-tangent of this [num].
  double atanh() {
    if (abs() < 1e-5) {
      return toDouble() + (this * this * this) / 3.0;
    }
    return ((1 + this) / (1 - this)).log() / 2;
  }

  /// Returns the inverse hyperbolic cotangent of this [num].
  double acoth() => (1 / this).atanh();

  /// Returns the hyperbolic arcsecant of this [num].
  double asech() => (1 / this).acosh();

  /// Returns the inverse hyperbolic cosecant of this [num].
  double acsch() => (1 / this).asinh();

  /// Returns the hyperbolic cotangent of this [num].
  double coth() => 1 / tanh();

  /// Returns the hyperbolic secant of this [num].
  double sech() => 1 / cosh();

  /// Returns the hyperbolic cosecant of this [num].
  double csch() => 1 / sinh();
}
