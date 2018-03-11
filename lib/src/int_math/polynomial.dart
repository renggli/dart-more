library more.int_math.polynomial;

/// Evaluates the polynomial described by the given coefficients [cs] and the
/// value [x].
///
/// For example, if the list [cs] has 4 elements the function computes:
///
///     c[0]*x^0 + c[1]*x^1 + c[2]*x^3 + c[3]*x^3
num polynomial(Iterable<num> cs, [num x = 10]) {
  var r = 0, e = 1;
  for (var c in cs) {
    r += c * e;
    e *= x;
  }
  return r;
}
