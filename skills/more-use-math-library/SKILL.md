---
name: more-dart-use-math-library
description: "Mathematical, number-theoretic, and bit-manipulation utilities in package:more/math.dart: primes and sieves, gcd/lcm, factorial/binomial, polynomials, hyperbolic functions, bit operations, and IEEE-754 floats."
---

# MoreDart Math Library (`package:more/math.dart`)

Extends `num`, `int`, `double`, `BigInt`, and `Iterable<num>` with number theory, combinatorics, prime sieves, polynomial evaluation, hyperbolic trigonometry, bit manipulation, and IEEE-754 floating-point inspection.

---

## Number Theory, Combinatorics & Primes

Works on both `int` and `BigInt`:

```dart
import 'package:more/math.dart';

// GCD & LCM on pairs or iterables
final lcmVal = 12.lcm(18); // 36
final gcdAll = [24, 36, 60].gcd(); // 12
final lcmAll = [3, 4, 6].lcm(); // 12

// Factorial, binomial coefficients, and base-N digits (least-significant first)
final fact = 5.factorial(); // 120
final bigComb = BigInt.from(50).binomial(BigInt.from(6)); // 15890700
final base10Digits = 1234.digits(10); // [4, 3, 2, 1]

// Primality testing (deterministic Miller-Rabin for 64-bit int) & prime sieves
final primeCheck = 999983.isProbablyPrime; // true
final sieve = EulerPrimeSieve(30); // Also EratosthenesPrimeSieve, AtkinPrimeSieve
final primesUpTo30 = sieve.primes; // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
```

---

## Polynomials, Elementary & Hyperbolic Functions

```dart
// Horner's method polynomial evaluation: c[0] + c[1]*x + c[2]*x^2 + ...
// Evaluates 1 + 2*x + 3*x^2 at x = 5:
final polyVal = [1, 2, 3].polynomial(5); // 86

// Method-style math & hyperbolic functions on num
final hyp = 0.5.sinh();
final invHyp = hyp.asinh(); // ~0.5
final deg = 3.141592653589793.toDegrees(); // 180.0
final clamped = 15.clip(0, 10); // 10
final inBounds = 5.between(1, 10); // true
```

---

## Bit Manipulation & IEEE-754 Floats

```dart
// Unsigned 32-bit bit operations on int
final popCount = 0x2d.bitCount; // 4 (0b101101)
final isPow2 = 64.hasSingleBit; // true
final floorPow2 = 50.bitFloor; // 32
final ceilPow2 = 50.bitCeil; // 64
final toggled = 0x04.setBit(0).clearBit(2).toggleBit(1); // 3 (0b0011)

// Adjacent representable IEEE-754 doubles and unit in the last place (ULP)
final next = 1.0.nextUp;
final prev = 1.0.nextDown;
final ulp = 1.0.ulp; // 2.220446049250313e-16
```
