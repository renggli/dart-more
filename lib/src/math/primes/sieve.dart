/// Abstract sieve implementation for primes up to and including [max].
abstract class PrimeSieve {
  /// Constructs a prime sieve up to [max].
  /// Throws a [RangeError] if [max] is negative.
  PrimeSieve(int max) : max = RangeError.checkNotNegative(max, 'n');

  /// The maximum number this sieve supports.
  final int max;

  /// Tests if a [value] is prime. Throws a [RangeError] exception if [value] is
  /// larger than [max].
  bool isPrime(int value);

  /// Returns an [Iterable] of all primes up to and including [max].
  Iterable<int> get primes;
}
