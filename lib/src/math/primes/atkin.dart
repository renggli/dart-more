import '../../collection/bitlist.dart';
import 'sieve.dart';

/// Prime sieve of Atkin (linear sieve).
///
/// The implementation has a time complexity of _O(n)_ and a space complexity
/// of _O(n)_.
///
/// See https://en.wikipedia.org/wiki/Sieve_of_Atkin.
class AtkinPrimeSieve extends PrimeSieve {
  /// Constructs the prime sieve of Atkin.
  AtkinPrimeSieve(super.max) : _isPrime = BitList.filled(max + 1, false) {
    if (max >= 2) _isPrime[2] = true;
    if (max >= 3) _isPrime[3] = true;
    for (var i = 1; i * i <= max; i++) {
      for (var j = 1; j * j <= max; j++) {
        final k1 = 4 * i * i + j * j;
        if (k1 <= max && (k1 % 12 == 1 || k1 % 12 == 5)) {
          _isPrime.flip(k1);
        }
        final k2 = 3 * i * i + j * j;
        if (k2 <= max && k2 % 12 == 7) {
          _isPrime.flip(k2);
        }
        final k3 = 3 * i * i - j * j;
        if (i > j && k3 <= max && k3 % 12 == 11) {
          _isPrime.flip(k3);
        }
      }
    }
    for (var i = 5; i * i <= max; i++) {
      if (_isPrime[i]) {
        for (var j = i * i; j <= max; j += i * i) {
          _isPrime[j] = false;
        }
      }
    }
  }

  final BitList _isPrime;

  @override
  bool isPrime(int value) => _isPrime[value];

  @override
  Iterable<int> get primes => _isPrime.indices();
}
