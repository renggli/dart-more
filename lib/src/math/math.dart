import 'dart:math' as math;

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
}
