library more.math.hyperbolic;

import 'dart:math' as math;

// Based on the polyfills given on https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math.

/// Computes the hyperbolic sine of a number.
double sinh(double x) {
  final y = math.exp(x);
  return (y - 1 / y) / 2;
}

/// Computes the hyperbolic arcsine of a number.
double asinh(double x) =>
    x.isInfinite && x.isNegative ? x : math.log(x + math.sqrt(x * x + 1));

/// Computes the hyperbolic cosine of a number.
double cosh(double x) {
  final y = math.exp(x);
  return (y + 1 / y) / 2;
}

/// Computes the hyperbolic arccosine of a number.
double acosh(double x) => math.log(x + math.sqrt(x * x - 1));

/// Computes the hyperbolic tangent of a number.
double tanh(double x) {
  final a = math.exp(x), b = math.exp(-x);
  return a.isInfinite ? 1 : b.isInfinite ? -1 : (a - b) / (a + b);
}

/// Computes the hyperbolic arctangent of a number.
double atanh(double x) => math.log((1 + x) / (1 - x)) / 2;
