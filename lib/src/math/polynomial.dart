extension PolynomialIterableExtension on Iterable<num> {
  /// Evaluates the polynomial described by this [Iterable]s coefficients and
  /// the value [x].
  ///
  /// For example, if the [Iterable] has 4 elements the function computes:
  ///
  /// ```dart
  /// c[0]*x^0 + c[1]*x^1 + c[2]*x^3 + c[3]*x^3
  /// ```
  num polynomial([num x = 10]) {
    num r = 0, e = 1;
    for (final c in this) {
      r += c * e;
      e *= x;
    }
    return r;
  }
}
