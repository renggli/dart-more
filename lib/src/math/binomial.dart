extension BinomialIntegerExtension on int {
  /// Returns the binomial coefficient of this [int] and the argument [k],
  ///
  /// This is the number of ways, disregarding order, that [k] objects can be
  /// chosen from among `n` objects.
  int binomial(int k) {
    var n = this;
    if (k < 0 || k > n) {
      throw ArgumentError('$n.binomial($k) is undefined');
    }
    if (k == 0 || k == n) {
      return 1;
    }
    if (k == 1 || k == n - 1) {
      return n;
    }
    if (k > n - k) {
      k = n - k;
    }
    var r = 1;
    for (var i = 1; i <= k; i++) {
      r = (r * n) ~/ i;
      n--;
    }
    return r;
  }
}

extension BinomialBigIntExtension on BigInt {
  /// Returns the binomial coefficient of this [BigInt] and the argument [k].
  ///
  /// This is the number of ways, disregarding order, that [k] objects can be
  /// chosen from among `n` objects.
  BigInt binomial(BigInt k) {
    var n = this;
    if (k < BigInt.zero || k > n) {
      throw ArgumentError('$n.binomial($k) is undefined');
    }
    if (k == BigInt.zero || k == n) {
      return BigInt.one;
    }
    if (k == BigInt.one || k == n - BigInt.one) {
      return n;
    }
    if (k > n - k) {
      k = n - k;
    }
    var r = BigInt.one;
    for (var i = BigInt.one; i <= k; i += BigInt.one) {
      r = (r * n) ~/ i;
      n -= BigInt.one;
    }
    return r;
  }
}
