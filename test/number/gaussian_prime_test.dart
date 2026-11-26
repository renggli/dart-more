import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('real and imaginary axis primes (OEIS A002145)', () {
    const a002145 = [3, 7, 11, 19, 23, 31, 43, 47, 59, 67, 71, 79, 83, 103];
    for (var i = 0; i < a002145.last; i++) {
      final values = [
        Complex(-i),
        Complex(i),
        Complex(0, -i),
        Complex(0, i),
      ].map((value) => value.isProbablyGaussianPrime);
      final expected = a002145.contains(i);
      check(values).every(.it()..equals(expected));
    }
  });
  test('norm 5 gaussian primes', () {
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
  });
  test('non-integers and non-finite', () {
    check(const Complex(math.pi, math.e).isProbablyGaussianPrime).isFalse;
    check(Complex.nan.isProbablyGaussianPrime).isFalse;
    check(Complex.infinity.isProbablyGaussianPrime).isFalse;
    check(const Complex(0, double.negativeInfinity).isProbablyGaussianPrime)
        .isFalse;
    check(const Complex(1e30, 0).isProbablyGaussianPrime).isFalse;
  });
  test('large Gaussian integers', () {
    check(const Complex(100000000, 1).isProbablyGaussianPrime).isFalse;
    // 100000000^2 + 49^2 = 10000000000002401 (prime)
    check(const Complex(100000000, 49).isProbablyGaussianPrime).isTrue;
    final minInt64 = int.parse('-9223372036854775808');
    check(Complex(minInt64, 0).isProbablyGaussianPrime).isFalse;
  }, testOn: '!js');
}
