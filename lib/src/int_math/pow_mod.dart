library more.int_math.pow_mod;

/// Returns the power [x] raised to [y] modulo [m], where [x], [m] and [y] are
/// [int]s.
int powMod(int x, int y, int m) => x.modPow(y, m);
