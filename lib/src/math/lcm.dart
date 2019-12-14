library more.math.lcm;

extension LcmIntegerExtension on int {
  /// Returns the least common multiple (LCM) of this [int] and `other`. This is
  /// the smallest positive integer that is divisible by both numbers.
  int lcm(int other) => this * other ~/ gcd(other);
}

extension LcmBigIntExtension on BigInt {
  /// Returns the least common multiple (LCM) of this [BigInt] and `other`. This
  /// is the smallest positive integer that is divisible by both numbers.
  BigInt lcm(BigInt other) => this * other ~/ gcd(other);
}
