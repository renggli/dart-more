library more.math.factorial;

/// Precomputed list of factorials.
const List<int> factorials = [
  1,
  1,
  2,
  6,
  24,
  120,
  720,
  5040,
  40320,
  362880,
  3628800,
  39916800,
  479001600,
  6227020800,
  87178291200,
  1307674368000,
  20922789888000,
  355687428096000,
  6402373705728000,
  121645100408832000,
  2432902008176640000
];

/// Returns the factorial of the argument. This is the number of ways to arrange
/// [n] distinct objects into a sequence.
int factorial(int n) {
  if (n < 0) {
    throw ArgumentError('factorial($n) is undefined for negative arguments.');
  }
  if (n < factorials.length) {
    return factorials[n];
  }
  var r = factorials.last;
  for (var i = factorials.length; i <= n; i++) {
    r *= i;
  }
  return r;
}
