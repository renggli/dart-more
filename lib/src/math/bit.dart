/// Bit twiddling loosely based on
/// http://graphics.stanford.edu/~seander/bithacks.html.
extension BitUint32Extension on int {
  /// Returns the bits set of an unsigned 32-bit integer. This value is
  /// also known as "binary weight" or "Hamming weight".
  ///
  /// See https://oeis.org/A000120.
  int get bitCount {
    var n = this & 0xffffffff;
    n = n - ((n >> 1) & 0x55555555);
    n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
    n = (n + (n >> 4)) & 0x0f0f0f0f;
    n = n + (n >> 8);
    n = n + (n >> 16);
    return n & 0x0000003f;
  }

  /// Tests if this unsigned 32-bit integer has a single bit set, which also
  /// means that it is a power of two.
  bool get hasSingleBit => this != 0 && this & (this - 1) == 0;

  /// Returns the power of 2 that is smaller or equal to this unsigned 32-bit
  /// integer.
  int get bitFloor => this <= 0 ? 0 : 1 << (bitLength - 1);

  /// Returns the power of 2 that is greater or equal to this unsigned 32-bit
  /// integer.
  int get bitCeil => this <= 1 ? 1 : 1 << (this - 1).bitLength;
}
