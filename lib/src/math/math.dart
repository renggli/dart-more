import 'dart:math' as math;

import 'polynomial.dart';

extension MathNumberExtension on num {
  /// Returns this [num] to the power of [exponent].
  num pow(num exponent) => math.pow(this, exponent);

  /// Returns the sin of this [num].
  double sin() => math.sin(this);

  /// Returns the arc-sin of this [num].
  double asin() => math.asin(this);

  /// Returns the cos of this [num].
  double cos() => math.cos(this);

  /// Returns the arc-cos of this [num].
  double acos() => math.acos(this);

  /// Returns the tan of this [num].
  double tan() => math.tan(this);

  /// Returns the arc-tan of this [num].
  double atan() => math.atan(this);

  /// Returns the arc-tag of this [num] and [other].
  double atan2(num other) => math.atan2(this, other);

  /// Returns the square root of this [num].
  double sqrt() => math.sqrt(this);

  /// Returns the natural exponent of this [num].
  double exp() => math.exp(this);

  /// Returns the natural logarithm of this [num].
  double log() => math.log(this);

  /// Returns true, if this [num] is between [min] and [max] (inclusive).
  bool between(num min, num max) => min <= this && this <= max;

  /// Returns an approximation of the error function, for details see
  /// https://en.wikipedia.org/wiki/Error_function.
  ///
  /// This uses a Chebyshev fitting formula from Numerical Recipes, 6.2.
  double erf() {
    const p = [
      -1.26551223,
      1.00002368,
      0.37409196,
      0.09678418,
      -0.18628806,
      0.27886807,
      -1.13520398,
      1.48851587,
      -0.82215223,
      0.17087277,
    ];
    final t = 1.0 / (1.0 + 0.5 * abs());
    final e = -this * this + p.polynomial(t);
    final r = 1.0 - t * math.exp(e);
    return isNegative ? -r : r;
  }
}
