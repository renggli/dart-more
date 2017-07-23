library more.int_math.binomial;

/// Returns the binomial coefficient of the arguments. This is the number of
/// ways, disregarding order, that [k] objects can be chosen from among [n]
/// objects.
int binomial(int n, int k) {
  if (k < 0 || k > n) {
    return 0;
  }
  if (k > n - k) {
    k = n - k;
  }
  var r = 1;
  for (var i = 1; i <= k; i++) {
    r *= n--;
    r = r ~/ i;
  }
  return r;
}