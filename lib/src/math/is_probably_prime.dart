library more.math.is_probably_prime;

/// Tests if the number [n] is probably a prime.
///
/// This variant of the probabilistic prime test by Miller–Rabin is
/// deterministic. It has been verified to return correct results for all n
/// < 341,550,071,728,321.
bool isProbablyPrime(int n) {
  if (n == 2 || n == 3 || n == 5) {
    return true;
  }
  if (n < 2 || n % 2 == 0 || n % 3 == 0 || n % 5 == 0) {
    return false;
  }
  if (n < 25) {
    return true;
  }
  var d = n - 1, s = 0;
  while (d % 2 == 0) {
    d ~/= 2;
    s++;
  }
  loop:
  for (final a in [2, 3, 5, 7, 11, 13, 17]) {
    var x = a.modPow(d, n);
    if (x == 1 || x == n - 1) {
      continue loop;
    }
    for (var r = 0; r <= s - 1; r++) {
      x = x.modPow(2, n);
      if (x == 1) {
        return false;
      }
      if (x == n - 1) {
        continue loop;
      }
    }
    return false;
  }
  return true;
}
