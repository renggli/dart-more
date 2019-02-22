library more.math.pow_mod;

/// Returns the power [x] raised to [y] modulo [m], where [x], [m] and [y] are
/// [int]s.
@deprecated
int powMod(int x, int y, int m) => x.modPow(y, m);
