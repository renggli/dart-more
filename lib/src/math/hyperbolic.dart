import 'math.dart';

// Based on the polyfills given on https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math.
extension HyperbolicNumberExtension on num {
  /// Returns the hyperbolic sine of this [num].
  double sinh() {
    final y = exp();
    return (y - 1 / y) / 2;
  }

  /// Returns the hyperbolic arc-sine of this [num].
  double asinh() => isInfinite && isNegative
      ? toDouble()
      : (this + (this * this + 1).sqrt()).log();

  /// Returns the hyperbolic cosine of this [num].
  double cosh() {
    final y = exp();
    return (y + 1 / y) / 2;
  }

  /// Returns the hyperbolic arc-cosine of this [num].
  double acosh() => (this + (this * this - 1).sqrt()).log();

  /// Returns the hyperbolic tangent of this [num].
  double tanh() {
    final a = exp(), b = (-this).exp();
    return a.isInfinite
        ? 1
        : b.isInfinite
            ? -1
            : (a - b) / (a + b);
  }

  /// Returns the hyperbolic arc-tangent of this [num].
  double atanh() => ((1 + this) / (1 - this)).log() / 2;
}
