/// Extension on [int] providing [lcm].
extension LcmIntegerExtension on int {
  /// Returns the least common multiple (LCM) of this [int] and [other]. This is
  /// the smallest positive integer that is divisible by both numbers.
  int lcm(int other) =>
      (this == 0 || other == 0) ? 0 : (this ~/ gcd(other) * other).abs();
}

/// Extension on [Iterable] of [int] providing [lcm].
extension LcmIntegerIterableExtension on Iterable<int> {
  /// Returns the least common multiple (LCM) of the values in this [Iterable]. This
  /// is the smallest positive integer that is divisible by all numbers.
  int lcm() => reduce((a, b) => a.lcm(b));
}

/// Extension on [BigInt] providing [lcm].
extension LcmBigIntExtension on BigInt {
  /// Returns the least common multiple (LCM) of this [BigInt] and [other]. This
  /// is the smallest positive integer that is divisible by both numbers.
  BigInt lcm(BigInt other) => (this == BigInt.zero || other == BigInt.zero)
      ? BigInt.zero
      : (this ~/ gcd(other) * other).abs();
}

/// Extension on [Iterable] of [BigInt] providing [lcm].
extension LcmBigIntIterableExtension on Iterable<BigInt> {
  /// Returns the least common multiple (LCM) of the values in this [Iterable]. This
  /// is the smallest positive integer that is divisible by all numbers.
  BigInt lcm() => reduce((a, b) => a.lcm(b));
}
