library more.test.math_test;

import 'package:more/math.dart';
import 'package:test/test.dart';

void main() {
  final epsilon = pow(2.0, -32);
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
  test('binomial (bounds)', () {
    expect(() => binomial(7, -1), throwsArgumentError);
    expect(() => binomial(7, 8), throwsArgumentError);
  });
  group('math', () {
    test('digits', () {
      expect(digits(0).toList(), [0]);
      expect(digits(1).toList(), [1]);
      expect(digits(12).toList(), [2, 1]);
      expect(digits(123).toList(), [3, 2, 1]);
      expect(digits(1001).toList(), [1, 0, 0, 1]);
      expect(digits(10001).toList(), [1, 0, 0, 0, 1]);
      expect(digits(1000).toList(), [0, 0, 0, 1]);
      expect(digits(10000).toList(), [0, 0, 0, 0, 1]);
    });
    test('digits (base 2)', () {
      expect(digits(0, 2).toList(), [0]);
      expect(digits(1, 2).toList(), [1]);
      expect(digits(12, 2).toList(), [0, 0, 1, 1]);
      expect(digits(123, 2).toList(), [1, 1, 0, 1, 1, 1, 1]);
      expect(digits(1001, 2).toList(), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10001, 2).toList(),
          [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      expect(digits(1000, 2).toList(), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10000, 2).toList(),
          [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
    });
    test('digits (base 16)', () {
      expect(digits(0, 16).toList(), [0]);
      expect(digits(1, 16).toList(), [1]);
      expect(digits(12, 16).toList(), [12]);
      expect(digits(123, 16).toList(), [11, 7]);
      expect(digits(1001, 16).toList(), [9, 14, 3]);
      expect(digits(10001, 16).toList(), [1, 1, 7, 2]);
      expect(digits(1000, 16).toList(), [8, 14, 3]);
      expect(digits(10000, 16).toList(), [0, 1, 7, 2]);
    });
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
    const max = 100000;
    final primes = primesUpTo(max).toSet();
    for (var i = 0; i < max; i++) {
      expect(isProbablyPrime(i), primes.contains(i));
    }
  });
  group('hyperbolic', () {
    test('cosh', () {
      expect(cosh(0), closeTo(1, epsilon));
      expect(cosh(1), closeTo(1.5430806348152437, epsilon));
      expect(cosh(-1), closeTo(1.5430806348152437, epsilon));
    });
    test('acosh', () {
      expect(acosh(-1), isNaN);
      expect(acosh(0), isNaN);
      expect(acosh(0.5), isNaN);
      expect(acosh(1), closeTo(0, epsilon));
      expect(acosh(2), closeTo(1.3169578969248166, epsilon));
    });
    test('sinh', () {
      expect(sinh(0), closeTo(0, epsilon));
      expect(sinh(1), closeTo(1.1752011936438014, epsilon));
    });
    test('asinh', () {
      expect(asinh(1), closeTo(0.881373587019543, epsilon));
      expect(asinh(0), closeTo(0, epsilon));
    });
    test('tanh', () {
      expect(tanh(0), closeTo(0, epsilon));
      expect(tanh(double.infinity), closeTo(1, epsilon));
      expect(tanh(1), closeTo(0.7615941559557649, epsilon));
    });
    test('atanh', () {
      expect(atanh(-2), isNaN);
      expect(atanh(-1), double.negativeInfinity);
      expect(atanh(0), closeTo(0, epsilon));
      expect(atanh(0.5), closeTo(0.5493061443340548, epsilon));
      expect(atanh(1), double.infinity);
      expect(atanh(2), isNaN);
    });
  });
}
