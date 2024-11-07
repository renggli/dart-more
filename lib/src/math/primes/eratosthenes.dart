import '../../../collection.dart' show BitList;
import 'sieve.dart';

/// Prime sieve of Eratosthenes.
///
/// The implementation has a time complexity of _O(n * log(log(n)))_ and a
/// space complexity of _O(n)_.
///
/// See https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes.
class EratosthenesPrimeSieve extends PrimeSieve {
  /// Constructs the prime sieve of Eratosthenes.
  EratosthenesPrimeSieve(super.max) : _isPrime = BitList.filled(max + 1, true) {
    _isPrime[0] = false;
    if (max > 0) _isPrime[1] = false;
    for (var i = 4; i <= max; i += 2) {
      _isPrime[i] = false;
    }
    for (var i = 3; i * i <= max; i += 2) {
      if (_isPrime[i]) {
        for (var j = i * i; j <= max; j += 2 * i) {
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
