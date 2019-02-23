library more.math.hyperbolic;

import 'dart:math' as math;

// Based on the polyfills given on https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math.

/// Computes the hyperbolic sine of a number.
double sinh(num x) {
  final y = math.exp(x);
  return (y - 1 / y) / 2;
}

/// Computes the hyperbolic arc-sine of a number.
double asinh(num x) =>
    x.isInfinite && x.isNegative ? x : math.log(x + math.sqrt(x * x + 1));

/// Computes the hyperbolic cosine of a number.
double cosh(num x) {
  final y = math.exp(x);
  return (y + 1 / y) / 2;
}

/// Computes the hyperbolic arc-cosine of a number.
double acosh(num x) => math.log(x + math.sqrt(x * x - 1));

/// Computes the hyperbolic tangent of a number.
double tanh(num x) {
  final a = math.exp(x), b = math.exp(-x);
  return a.isInfinite ? 1 : b.isInfinite ? -1 : (a - b) / (a + b);
}

/// Computes the hyperbolic arc-tangent of a number.
double atanh(num x) => math.log((1 + x) / (1 - x)) / 2;
