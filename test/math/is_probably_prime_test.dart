import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  const max = 100000;
  final primes = EratosthenesPrimeSieve(max);
  test('int', () {
    for (var i = 0; i < max; i++) {
      check(i.isProbablyPrime).equals(primes.isPrime(i));
    }
    const prime = 228204732751;
    check(prime.isProbablyPrime).isTrue;
    check((prime + 2).isProbablyPrime).isFalse;
    check(3037000507.isProbablyPrime).isTrue;
    check((3037000507 + 2).isProbablyPrime).isFalse;
    check(999999999989.isProbablyPrime).isTrue;
    check((999999999989 + 2).isProbablyPrime).isFalse;
    check(9007199254740881.isProbablyPrime).isTrue;
    check((9007199254740881 + 2).isProbablyPrime).isFalse;
  });
  test('BigInt', () {
    for (var i = 0; i < max; i++) {
      check(BigInt.from(i).isProbablyPrime).equals(primes.isPrime(i));
    }
    final prime = BigInt.parse('170141183460469231731687303715884105727');
    check(prime.isProbablyPrime).isTrue;
    check((prime + BigInt.two).isProbablyPrime).isFalse;
  });
}
