/// Extension on [Iterable] of [int] providing [gcd].
extension GcdIntegerIterableExtension on Iterable<int> {
  /// Returns the greatest common divisor (GCD) of the values in this [Iterable]. This
  /// is the largest positive integer that divides all numbers.
  int gcd() => reduce((a, b) => a.gcd(b));
}

/// Extension on [Iterable] of [BigInt] providing [gcd].
extension GcdBigIntIterableExtension on Iterable<BigInt> {
  /// Returns the greatest common divisor (GCD) of the values in this [Iterable]. This
  /// is the largest positive integer that divides all numbers.
  BigInt gcd() => reduce((a, b) => a.gcd(b));
}
