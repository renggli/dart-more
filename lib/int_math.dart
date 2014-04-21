/**
 * A collection of common mathematical functions on integers.
 */
library int_math;

import 'bit_list.dart';

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
    throw new ArgumentError('factorial($n) is undefined for negative arguments.');
  }
  if (n < _FACTORIALS.length) {
    return _FACTORIALS[n];
  }
  var r = _FACTORIALS.last;
  for (var i = _FACTORIALS.length; i <= n; i++) {
    r *= i;
  }
  return r;
}

const List<int> _FACTORIALS = const [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800,
    39916800, 479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 355687428096000,
    6402373705728000, 121645100408832000, 2432902008176640000];

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
 * Returns the power [x] raised to [y], where [y] is an [int].
 */
num pow(num x, int y) {
  if (y < 0) {
    return 1 / pow(x, -y);
  }
  var r = 1;
  while (y > 0) {
    if (y.isOdd) {
      r *= x;
    }
    x *= x;
    y ~/= 2;
  }
  return r;
}

/**
 * Returns the power [x] raised to [y] modulo [m], where [x], [m] and [y] are [int]s.
 */
int powMod(int x, int y, int m) {
  if (m < 1 || y < 0) {
    throw new ArgumentError('powMod($x, $y, $m) is undefined for y < 0 and m < 1.');
  }
  var r = 1;
  while (y > 0) {
    if (y.isOdd) {
      r *= x;
      if (r >= m) {
        r %= m;
      }
    }
    x *= x;
    if (x >= m) {
      x %= m;
    }
    y ~/= 2;
  }
  return r;
}

/**
 * Evaluates the polynomial described by the given coefficients [cs] and the
 * value [x].
 *
 * For example, if the list [cs] has 4 elements the function computes:
 *
 *     c[0]*x^0 + c[1]*x^1 + c[2]*x^3 + c[3]*x^3
 */
num polynomial(Iterable<num> cs, [num x = 10]) {
  var r = 0, e = 1;
  for (var c in cs) {
    r += c * e;
    e *= x;
  }
  return r;
}

/**
 * Returns primes up to a [limit] compued by the Sieve of Eratosthenes.
 */
List<int> primesUpTo(int limit) {
  var sieve = new BitList(limit + 1);
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

/**
 * Tests if the number [n] is probably a prime.
 *
 * The output of this variant of the probabilistic primality test
 * by Miller–Rabin is deterministic. It has been verified to return
 * correct results for all n < 341,550,071,728,321.
 */
bool isProbablyPrime(int n) {
  if (n == 2 || n == 3 || n == 5) {
    return true;
  }
  if (n < 2 || n % 2 == 0 || n % 3 == 0 || n % 5 == 0) {
    return false;
  }
  if (n < 25) {
    return true;
  }
  var d = n - 1, s = 0;
  while (d % 2 == 0) {
    d ~/= 2;
    s++;
  }
  loop: for (var a in [2, 3, 5, 7, 11, 13, 17]) {
    var x = powMod(a, d, n);
    if (x == 1 || x == n - 1) {
      continue loop;
    }
    for (var r = 0; r <= s - 1; r++) {
      x = powMod(x, 2, n);
      if (x == 1) {
        return false;
      }
      if (x == n - 1) {
        continue loop;
      }
    }
    return false;
  }
  return true;
}
