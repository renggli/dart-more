library more.test.int_math_test;

import 'package:more/int_math.dart';
import 'package:test/test.dart';

void main() {
  test('gcd', () {
    expect(gcd(8, 12), 4);
    expect(gcd(12, 8), 4);
    expect(gcd(8, 0), 8);
    expect(gcd(0, 8), 8);
  });
  test('lcm', () {
    expect(lcm(5, 2), 10);
    expect(lcm(2, 5), 10);
    expect(lcm(5, 0), 0);
    expect(lcm(0, 5), 0);
  });
  test('factorial', () {
    expect(factorial(0), 1);
    expect(factorial(1), 1);
    expect(factorial(5), 120);
    expect(factorial(12), 479001600);
    expect(factorial(20), 2432902008176640000);
    expect(factorial(21), 2432902008176640000 * 21);
    expect(factorial(22), 2432902008176640000 * 21 * 22);
  });
  test('factorial (bounds)', () {
    expect(() => factorial(-1), throwsArgumentError);
  });
  test('binomial', () {
    expect(binomial(7, 0), 1);
    expect(binomial(7, 1), 7);
    expect(binomial(7, 2), 21);
    expect(binomial(7, 3), 35);
    expect(binomial(7, 4), 35);
    expect(binomial(7, 5), 21);
    expect(binomial(7, 6), 7);
    expect(binomial(7, 7), 1);
  });
  test('binomial (large)', () {
    final cache = <int, Map<int, int>>{};
    int verifyBinomial(int n, int k) {
      if (k == 0 || k == n) {
        return 1;
      } else if (k == 1 || k == n - 1) {
        return n;
      } else {
        return cache.putIfAbsent(n, () => {}).putIfAbsent(
            k, () => verifyBinomial(n - 1, k - 1) + verifyBinomial(n - 1, k));
      }
    }

    for (var n = 0; n <= 60; n++) {
      for (var k = 0; k <= n; k++) {
        expect(binomial(n, k), verifyBinomial(n, k));
      }
    }
  }, onPlatform: {'browser': const Skip('64-bit integers')});
  test('binomial (bounds)', () {
    expect(() => binomial(7, -1), throwsArgumentError);
    expect(() => binomial(7, 8), throwsArgumentError);
  });
  test('pow(x, 0)', () {
    expect(pow(-2, 0), 1);
    expect(pow(-1, 0), 1);
    expect(pow(0, 0), 1);
    expect(pow(1, 0), 1);
    expect(pow(2, 0), 1);
  });
  test('pow(x, 1)', () {
    expect(pow(-2, 1), -2);
    expect(pow(-1, 1), -1);
    expect(pow(0, 1), 0);
    expect(pow(1, 1), 1);
    expect(pow(2, 1), 2);
  });
  test('pow(x, 5)', () {
    expect(pow(-2, 5), -32);
    expect(pow(-1, 5), -1);
    expect(pow(0, 5), 0);
    expect(pow(1, 5), 1);
    expect(pow(2, 5), 32);
  });
  test('pow(x, -2)', () {
    expect(pow(-2, -2), 0.25);
    expect(pow(-1, -2), 1.0);
    expect(pow(1, -2), 1.0);
    expect(pow(2, -2), 0.25);
  });
  test('powMod(x, y, m)', () {
    for (var x = 0; x < 10; x++) {
      for (var y = 0; y < 10; y++) {
        for (var m = 2; m < 20; m++) {
          expect(powMod(x, y, m), pow(x, y) % m);
        }
      }
    }
    expect(() => powMod(1, 1, 0), throwsArgumentError);
    expect(() => powMod(1, -1, 1), throwsArgumentError);
  });
  test('polynomial', () {
    expect(polynomial([], 10), 0);
    expect(polynomial([1, 2], 10), 21);
    expect(polynomial([1, 2, 3], 10), 321);
    expect(polynomial([1, 2, 3, 4], 10), 4321);
  });
  test('primes', () {
    expect(primesUpTo(10), [2, 3, 5, 7]);
    expect(primesUpTo(20), [2, 3, 5, 7, 11, 13, 17, 19]);
  });
  test('isProbablyPrime', () {
    final max = 100000;
    final primes = primesUpTo(max).toSet();
    for (var i = 0; i < max; i++) {
      expect(isProbablyPrime(i), primes.contains(i));
    }
  });
}
