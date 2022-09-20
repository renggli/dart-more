import 'primes/eratosthenes.dart';
import 'primes/euler.dart';

extension PrimesIntegerExtension on int {
  /// Returns primes up to and including this [int] computed by the Sieve of
  /// Eratosthenes.
  ///
  /// Deprecated: Use [EratosthenesPrimeSieve] or [EulerPrimeSieve] for a
  /// better and more performant interface.
  @Deprecated('Use EratosthenesPrimeSieve or EulerPrimeSieve directly')
  Iterable<int> get primes => EratosthenesPrimeSieve(this).primes;
}
