/// Returns the number of set bits of an unsigned 32-bit integer.
int countBits32(int value) {
  var n = value & 0xffffffff;
  n = n - ((n >> 1) & 0x55555555);
  n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
  n = (n + (n >> 4)) & 0x0f0f0f0f;
  n = n + (n >> 8);
  n = n + (n >> 16);
  return n & 0x0000003f;
}
