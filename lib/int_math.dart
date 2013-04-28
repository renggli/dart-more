// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 * A collection of mathematical functions on [int]s.
 */
library int_math;

import 'package:more/bit_set.dart';

/**
 * Returns the greatest common divisor (GCD) of two or more integers (at least
 * one of which is not zero). This is the largest positive integer that divides
 * the numbers without a remainder. For example, the GCD of 8 and 12 is 4.
 */
int gcd(int a, int b) {
  while (b != 0) {
    var t = b;
    b = a % b;
    a = t;
  }
  return a;
}

/**
 * Returns the least common multiple (LCM) of two integers a and b. This is the
 * smallest positive integer that is divisible by both a and b.
 */
int lcm(int a, int b) {
  return a * b ~/ gcd(a, b);
}

/**
 * Returns the factorial of the argument. This is the number of ways to arrange
 * [n] distinct objects into a sequence.
 */
int factorial(int n) {
  if (n < 0) {
    throw new ArgumentError('Not valid for negative integers');
  }
  var r = _FACTORIALS[n < _FACTORIALS.length ? n : _FACTORIALS.length - 1];
  for (var i = _FACTORIALS.length; i <= n; i++) {
    r *= i;
  }
  return r;
}

final List<int> _FACTORIALS = const [1, 1, 2, 6, 24, 120, 720, 5040, 40320,
  362880, 3628800, 39916800, 479001600, 6227020800, 87178291200, 1307674368000,
  20922789888000, 355687428096000, 6402373705728000, 121645100408832000,
  2432902008176640000];

/**
 * Returns the binomial coefficient of the arguments. This is the number of
 * ways, disregarding order, that [k] objects can be chosen from among [n]
 * objects.
 */
int binomial(int n, int k) {
  if (k < 0 || k > n) {
    return 0;
  }
  if (k > n - k) {
    k = n - k;
  }
  var r = 1;
  for (var i = 1; i <= k; i++) {
    r *= n--;
    r = r ~/ i;
  }
  return r;
}

/**
 * Returns the power [x] raised to [n], where [n] is an [int].
 */
num pow(num x, int n) {
  if (n < 0) {
    return 1 / pow(x, -n);
  }
  var r = 1;
  while (n > 0) {
    if (n.isOdd) {
      r *= x;
    }
    n = n ~/ 2;
    x *= x;
  }
  return r;
}

/**
 * Returns primes up to a [limit] compued by the Sieve of Eratosthenes.
 */
List<int> primesUpTo(int limit) {
  var sieve = new BitSet(limit + 1);
  for (var i = 2; i * i <= limit; i++) {
    if (!sieve[i]) {
      for (var j = i * i; j <= limit; j += i) {
        sieve[j] = true;
      }
    }
  }
  var primes = new List();
  for (var i = 2; i <= limit; i++) {
    if (!sieve[i]) {
      primes.add(i);
    }
  }
  return primes;
}
