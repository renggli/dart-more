library more.math.hyperbolic;

import 'dart:math' as math;

/// Computes the hyperbolic sine of a number.
double sinh(double x) => (math.exp(x) - math.exp(-x)) / 2;

/// Computes the hyperbolic arcsine of a number.
double asinh(double x) => math.log(x + math.sqrt(x * x + 1));

/// Computes the hyperbolic cosine of a number.
double cosh(double x) => (math.exp(x) + math.exp(-x)) / 2;

/// Computes the hyperbolic arccosine of a number.
double acosh(double x) => math.log(x + math.sqrt(x * x - 1));

/// Computes the hyperbolic tangent of a number.
double tanh(double x) =>
    (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x));

/// Computes the hyperbolic arctangent of a number.
double atanh(double x) => math.log((1 + x) / (1 - x)) / 2;
