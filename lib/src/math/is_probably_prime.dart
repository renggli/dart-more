import '../number/complex.dart';

extension ProbablyPrimeIntegerExtension on int {
  /// Tests if this [int] is probably a prime.
  ///
  /// This variant of the probabilistic prime test by Miller–Rabin is
  /// deterministic. It has been verified to return correct results for
  /// 64 bit integers.
  bool get isProbablyPrime {
    if (this <= _bases.last) {
      return _bases.contains(this);
    }
    for (final base in _bases) {
      if (this % base == 0) {
        return false;
      }
    }
    var d = this - 1, s = 0;
    while (d.isEven) {
      d ~/= 2;
      s++;
    }
    loop:
    for (final base in _bases) {
      var x = base.modPow(d, this);
      if (x == 1 || x == this - 1) {
        continue loop;
      }
      for (var r = 1; r < s; r++) {
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

  static const _bases = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];
}

extension ProbablyPrimeBigIntExtension on BigInt {
  /// Tests if this [BigInt] is probably a prime.
  ///
  /// This variant of the probabilistic prime test by Miller–Rabin is
  /// deterministic. It has been verified to return correct results for
  /// 64 bit integers.
  bool get isProbablyPrime {
    if (this <= _bases.last) {
      return _bases.contains(this);
    }
    for (final base in _bases) {
      if (this % base == BigInt.zero) {
        return false;
      }
    }
    var d = this - BigInt.one, s = 0;
    while (d.isEven) {
      d ~/= BigInt.two;
      s++;
    }
    loop:
    for (final base in _bases) {
      var x = base.modPow(d, this);
      if (x == BigInt.one || x == this - BigInt.one) {
        continue loop;
      }
      for (var r = 1; r < s; r++) {
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

  static final _bases = [
    BigInt.from(2),
    BigInt.from(3),
    BigInt.from(5),
    BigInt.from(7),
    BigInt.from(11),
    BigInt.from(13),
    BigInt.from(17),
    BigInt.from(19),
    BigInt.from(23),
    BigInt.from(29),
    BigInt.from(31),
    BigInt.from(37),
  ];
}

extension ProbablyPrimeComplexExtension on Complex {
  /// Tests if this [Complex] is probably a gaussian prime, using the
  /// probabilistic prime test of [ProbablyPrimeIntegerExtension].
  ///
  /// https://en.wikipedia.org/wiki/Gaussian_integer#Gaussian_primes
  bool get isProbablyGaussianPrime {
    final re = a.round(), im = b.round();
    if (re == a && im == b) {
      if (re != 0 && im != 0) {
        return (re * re + im * im).isProbablyPrime;
      } else {
        final sum = (re + im).abs();
        return sum % 4 == 3 && sum.isProbablyPrime;
      }
    } else {
      return false;
    }
  }
}
