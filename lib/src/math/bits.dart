extension BitCountExtension on int {
  /// Returns the bits set of an unsigned 32-bit integer. This value is
  /// also known as "binary weight" or "Hamming weight".
  ///
  /// See https://oeis.org/A000120.
  int get bitCount {
    var n = this;
    n = n - ((n >> 1) & 0x55555555);
    n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
    n = (n + (n >> 4)) & 0x0F0F0F0F;
    n = n + (n >> 8);
    n = n + (n >> 16);
    return n & 0x0000003f;
  }
}
