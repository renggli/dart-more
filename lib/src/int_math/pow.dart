library more.int_math.pow;

/// Returns the power [x] raised to [y], where [y] is an [int].
num pow(num x, int y) {
  if (y < 0) {
    return 1 / pow(x, -y);
  }
  num r = 1;
  while (y > 0) {
    if (y.isOdd) {
      r *= x;
    }
    x *= x;
    y ~/= 2;
  }
  return r;
}
