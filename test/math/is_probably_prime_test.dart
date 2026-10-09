import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('isProbablyPrime', () {
    const max = 100000;
    final primes = EratosthenesPrimeSieve(max);
    test('int', () {
      for (var i = 0; i < max; i++) {
        check(i.isProbablyPrime).equals(primes.isPrime(i));
      }
      const prime = 228204732751;
      check(prime.isProbablyPrime).isTrue();
      check((prime + 2).isProbablyPrime).isFalse();
    });
    test('BigInt', () {
      for (var i = 0; i < max; i++) {
        check(BigInt.from(i).isProbablyPrime).equals(primes.isPrime(i));
      }
      final prime = BigInt.parse('170141183460469231731687303715884105727');
      check(prime.isProbablyPrime).isTrue();
      check((prime + BigInt.two).isProbablyPrime).isFalse();
    });
    test('Complex', () {
      const a002145 = [3, 7, 11, 19, 23, 31, 43, 47, 59, 67, 71, 79, 83, 103];
      for (var i = 0; i < a002145.last; i++) {
        final values = [
          Complex(-i),
          Complex(i),
          Complex(0, -i),
          Complex(0, i),
        ].map((value) => value.isProbablyGaussianPrime);
        final expected = a002145.contains(i);
        check(values).every((v) => v.equals(expected));
      }
      const norm5 = [
        Complex(1, 2),
        Complex(-1, 2),
        Complex(1, -2),
        Complex(-1, -2),
        Complex(2, 1),
        Complex(-2, 1),
        Complex(2, -1),
        Complex(-2, -1),
      ];
      for (var a = -5; a <= 5; a++) {
        for (var b = -5; b <= 5; b++) {
          final value = Complex(a, b);
          if (value.norm() == 5) {
            check(value.isProbablyGaussianPrime).equals(norm5.contains(value));
          }
        }
      }
      check(const Complex(math.pi, math.e).isProbablyGaussianPrime).isFalse();
    });
  });
}
