import '../math/is_probably_prime.dart';
import 'complex.dart';

/// Extension on [Complex] providing [isProbablyGaussianPrime].
extension ProbablyPrimeComplexExtension on Complex {
  /// Tests if this [Complex] is probably a gaussian prime, using the
  /// probabilistic prime test of [ProbablyPrimeIntegerExtension].
  ///
  /// https://en.wikipedia.org/wiki/Gaussian_integer#Gaussian_primes
  bool get isProbablyGaussianPrime {
    if (!isFinite) return false;
    final int re;
    if (a is int) {
      re = a as int;
    } else if (a == a.roundToDouble() &&
        a >= -9223372036854775808.0 &&
        a < 9223372036854775808.0) {
      re = a.toInt();
    } else {
      return false;
    }
    final int im;
    if (b is int) {
      im = b as int;
    } else if (b == b.roundToDouble() &&
        b >= -9223372036854775808.0 &&
        b < 9223372036854775808.0) {
      im = b.toInt();
    } else {
      return false;
    }
    if (re != 0 && im != 0) {
      if (re.abs() > 94906265 || im.abs() > 94906265) {
        final bigRe = BigInt.from(re), bigIm = BigInt.from(im);
        return (bigRe * bigRe + bigIm * bigIm).isProbablyPrime;
      }
      return (re * re + im * im).isProbablyPrime;
    } else {
      final value = re == 0 ? im : re;
      if (value < 0 && value.abs() == value) {
        return false; // minInt64 (-2^63) is even and not prime.
      }
      final sum = value.abs();
      return sum % 4 == 3 && sum.isProbablyPrime;
    }
  }
}
