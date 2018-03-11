library more.int_math.pow_mod;

/// Returns the power [x] raised to [y] modulo [m], where [x], [m] and [y] are
/// [int]s.
int powMod(int x, int y, int m) {
  if (m < 1 || y < 0) {
    throw new ArgumentError(
        'powMod($x, $y, $m) is undefined for y < 0 and m < 1.');
  }
  var r = 1;
  while (y > 0) {
    if (y.isOdd) {
      r *= x;
      if (r >= m) {
        r %= m;
      }
    }
    x *= x;
    if (x >= m) {
      x %= m;
    }
    y ~/= 2;
  }
  return r;
}
