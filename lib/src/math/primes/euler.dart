import 'dart:typed_data';

import '../../../feature.dart';
import 'eratosthenes.dart';
import 'sieve.dart';

/// Prime sieve of Euler (linear sieve).
///
/// As a side-effect the algorithm can also provide the prime factors of all
/// numbers up to and including [max].
///
/// The implementation has a time and space complexity of _O(n)_. However,
/// the space complexity has a much larger constant factor than
/// [EratosthenesPrimeSieve].
///
/// See https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes#Euler's_sieve.
class EulerPrimeSieve extends PrimeSieve {
  /// Constructs the prime sieve of Euler.
  EulerPrimeSieve(super.max)
      : _primes = [],
        _factors = isJavaScript ? Uint32List(max + 1) : Uint64List(max + 1) {
    for (var i = 2; i <= max; i++) {
      if (_factors[i] == 0) {
        _factors[i] = i;
        _primes.add(i);
      }
      for (var j = 0;
          j < _primes.length &&
              _primes[j] <= _factors[i] &&
              i * _primes[j] <= max;
          j++) {
        _factors[i * _primes[j]] = _primes[j];
      }
    }
  }

  final List<int> _primes;
  final List<int> _factors;

  @override
  bool isPrime(int value) => _factors[value] == value && value > 1;

  @override
  Iterable<int> get primes => _primes;

  /// Computes the prime factors of [value].
  List<int> factorize(int value) {
    RangeError.checkValueInInterval(value, 0, max, 'value');
    final result = <int>[];
    while (value > 1) {
      final factor = _factors[value];
      result.add(factor);
      if (factor == value) break;
      value = value ~/ factor;
    }
    return result;
  }
}
