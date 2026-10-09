import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

class _CustomPrimeSieve extends PrimeSieve {
  new(super.max);

  @override
  bool isPrime(int value) => false;

  @override
  Iterable<int> get primes => const [];
}

void main() {
  group('PrimeSieve', () {
    test('max property', () {
      final sieve = _CustomPrimeSieve(10);
      check(sieve.max).equals(10);
    });
    test('negative max throws', () {
      check(() => _CustomPrimeSieve(-1)).throws<RangeError>();
    });
  });
}
