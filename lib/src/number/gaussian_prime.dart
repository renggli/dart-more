import '../math/is_probably_prime.dart';
import 'complex.dart';

/// Extension on [Complex] providing [isProbablyGaussianPrime].
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
