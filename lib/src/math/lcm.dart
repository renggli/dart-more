extension LcmIntegerExtension on int {
  /// Returns the least common multiple (LCM) of this [int] and [other]. This is
  /// the smallest positive integer that is divisible by both numbers.
  int lcm(int other) => this ~/ gcd(other) * other;
}

extension LcmIntegerIterableExtension on Iterable<int> {
  /// Returns the least common multiple (LCM) of the values in this [Iterable]. This
  /// is the smallest positive integer that is divisible by all numbers.
  int lcm() => reduce((a, b) => a.lcm(b));
}

extension LcmBigIntExtension on BigInt {
  /// Returns the least common multiple (LCM) of this [BigInt] and [other]. This
  /// is the smallest positive integer that is divisible by both numbers.
  BigInt lcm(BigInt other) => this ~/ gcd(other) * other;
}

extension LcmBigIntIterableExtension on Iterable<BigInt> {
  /// Returns the least common multiple (LCM) of the values in this [Iterable]. This
  /// is the smallest positive integer that is divisible by all numbers.
  BigInt lcm() => reduce((a, b) => a.lcm(b));
}
