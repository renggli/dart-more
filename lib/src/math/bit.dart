import '../shared/bit.dart';

/// Bit twiddling extensions on unsigned 32-bit integers.
///
/// Loosely based on http://graphics.stanford.edu/~seander/bithacks.html.
extension BitUint32Extension on int {
  /// Returns the number of set bits of an unsigned 32-bit integer. This value is
  /// also known as "binary weight" or "Hamming weight".
  ///
  /// See https://oeis.org/A000120.
  int get bitCount => countBits32(this);

  /// Tests if this unsigned 32-bit integer has a single bit set, which also
  /// means that it is a power of two.
  bool get hasSingleBit {
    final value = this & 0xffffffff;
    return value != 0 && value & (value - 1) == 0;
  }

  /// Returns the power of 2 that is smaller or equal to this unsigned 32-bit
  /// integer.
  int get bitFloor {
    final value = this & 0xffffffff;
    return value <= 0 ? 0 : 1 << (value.bitLength - 1);
  }

  /// Returns the power of 2 that is greater or equal to this unsigned 32-bit
  /// integer.
  int get bitCeil {
    final value = this & 0xffffffff;
    return value <= 1 ? 1 : 1 << (value - 1).bitLength;
  }

  /// Returns this unsigned 32-bit integer with the bit at [index] set.
  ///
  /// The [index] must be between `0` and `31`, inclusive.
  int setBit(int index) {
    RangeError.checkValueInInterval(index, 0, 31, 'index');
    return (this | (1 << index)) & 0xffffffff;
  }

  /// Returns this unsigned 32-bit integer with the bit at [index] cleared.
  ///
  /// The [index] must be between `0` and `31`, inclusive.
  int clearBit(int index) {
    RangeError.checkValueInInterval(index, 0, 31, 'index');
    return this & ~(1 << index) & 0xffffffff;
  }

  /// Returns this unsigned 32-bit integer with the bit at [index] toggled.
  ///
  /// The [index] must be between `0` and `31`, inclusive.
  int toggleBit(int index) {
    RangeError.checkValueInInterval(index, 0, 31, 'index');
    return (this ^ (1 << index)) & 0xffffffff;
  }
}
