library more.math.primes_up_to;

import '../collection/bitlist.dart';

extension PrimesIntExtension on int {
  /// Returns primes up to and including this [int] computed by the Sieve of
  /// Eratosthenes.
  Iterable<int> get primes sync* {
    final sieve = BitList(this + 1);
    for (var i = 2; i * i <= this; i++) {
      if (!sieve[i]) {
        for (var j = i * i; j <= this; j += i) {
          sieve[j] = true;
        }
      }
    }
    for (var i = 2; i <= this; i++) {
      if (!sieve[i]) {
        yield i;
      }
    }
  }
}
