library more.math.is_probably_prime;

extension ProbablyPrimeIntegerExtension on int {
  /// Tests if this [int] is probably a prime.
  ///
  /// This variant of the probabilistic prime test by Miller–Rabin is
  /// deterministic. It has been verified to return correct results for all n
  /// < 341,550,071,728,321.
  bool get isProbablyPrime {
    if (this == 2 || this == 3 || this == 5) {
      return true;
    }
    if (this < 2 || this % 2 == 0 || this % 3 == 0 || this % 5 == 0) {
      return false;
    }
    if (this < 25) {
      return true;
    }
    var d = this - 1, s = 0;
    while (d % 2 == 0) {
      d ~/= 2;
      s++;
    }
    loop:
    for (final a in const [2, 3, 5, 7, 11, 13, 17]) {
      var x = a.modPow(d, this);
      if (x == 1 || x == this - 1) {
        continue loop;
      }
      for (var r = 0; r <= s - 1; r++) {
        x = x.modPow(2, this);
        if (x == 1) {
          return false;
        }
        if (x == this - 1) {
          continue loop;
        }
      }
      return false;
    }
    return true;
  }
}

extension ProbablyPrimeBigIntExtension on BigInt {
  /// Tests if this [BigInt] is probably a prime.
  ///
  /// This variant of the probabilistic prime test by Miller–Rabin is
  /// deterministic. It has been verified to return correct results for all n
  /// < 341,550,071,728,321.
  bool get isProbablyPrime {
    if (this == BigInt.two ||
        this == BigInt.from(3) ||
        this == BigInt.from(5)) {
      return true;
    }
    if (this < BigInt.two ||
        this % BigInt.two == BigInt.zero ||
        this % BigInt.from(3) == BigInt.zero ||
        this % BigInt.from(5) == BigInt.zero) {
      return false;
    }
    if (this < BigInt.from(25)) {
      return true;
    }
    var d = this - BigInt.one, s = BigInt.zero;
    while (d % BigInt.two == BigInt.zero) {
      d ~/= BigInt.two;
      s = s + BigInt.one;
    }
    loop:
    for (final a in [
      BigInt.two,
      BigInt.from(3),
      BigInt.from(5),
      BigInt.from(7),
      BigInt.from(11),
      BigInt.from(13),
      BigInt.from(17)
    ]) {
      var x = a.modPow(d, this);
      if (x == BigInt.one || x == this - BigInt.one) {
        continue loop;
      }
      for (var r = BigInt.zero; r <= s - BigInt.one; r += BigInt.one) {
        x = x.modPow(BigInt.two, this);
        if (x == BigInt.one) {
          return false;
        }
        if (x == this - BigInt.one) {
          continue loop;
        }
      }
      return false;
    }
    return true;
  }
}
