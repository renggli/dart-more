import 'dart:math' as math;

import 'package:more/collection.dart';
import 'package:more/iterable.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:test/test.dart';

void main() {
  const epsilon = 1.0e-6;
  group('binomial', () {
    group('values', () {
      test('int', () {
        expect(7.binomial(0), 1);
        expect(7.binomial(1), 7);
        expect(7.binomial(2), 21);
        expect(7.binomial(3), 35);
        expect(7.binomial(4), 35);
        expect(7.binomial(5), 21);
        expect(7.binomial(6), 7);
        expect(7.binomial(7), 1);
      });
      test('BigInt', () {
        expect(BigInt.from(7).binomial(BigInt.from(0)), BigInt.from(1));
        expect(BigInt.from(7).binomial(BigInt.from(1)), BigInt.from(7));
        expect(BigInt.from(7).binomial(BigInt.from(2)), BigInt.from(21));
        expect(BigInt.from(7).binomial(BigInt.from(3)), BigInt.from(35));
        expect(BigInt.from(7).binomial(BigInt.from(4)), BigInt.from(35));
        expect(BigInt.from(7).binomial(BigInt.from(5)), BigInt.from(21));
        expect(BigInt.from(7).binomial(BigInt.from(6)), BigInt.from(7));
        expect(BigInt.from(7).binomial(BigInt.from(7)), BigInt.from(1));
      });
    });
    group('bounds', () {
      test('int', () {
        expect(() => 7.binomial(-1), throwsArgumentError);
        expect(() => 7.binomial(8), throwsArgumentError);
      });
      test('BigInt', () {
        expect(() => BigInt.from(7).binomial(BigInt.from(-1)),
            throwsArgumentError);
        expect(
            () => BigInt.from(7).binomial(BigInt.from(8)), throwsArgumentError);
      });
    });
  });
  group('bit', () {
    final powersOf2 = List.generate(32, (i) => math.pow(2, i).toInt());
    group('bitCount', () {
      expectBitCount(int value, int expectedBitCount) {
        final bitCount = value.bitCount;
        expect(bitCount, expectedBitCount,
            reason: 'Expected $value (0b${value.toRadixString(2)}) '
                'to have $expectedBitCount bits, but got $bitCount bit.');
        expect(value.hasSingleBit, expectedBitCount == 1);
      }

      test('small', () {
        const bitCount = [
          0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3,
          3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4,
          3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 1, 2,
          2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5,
          3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, //
        ];
        for (var i = 0; i < bitCount.length; i++) {
          expectBitCount(i, bitCount[i]);
        }
      });
      test('single bit set', () {
        for (var i = 1; i <= 0xffffffff; i *= 2) {
          expectBitCount(i, 1);
        }
      });
      test('all bit set', () {
        for (var i = 1; i <= 0xffffffff; i *= 2) {
          expectBitCount(i - 1, i.bitLength - 1);
        }
        expectBitCount(0xffffffff, 32);
      });
      test('random numbers', () {
        final random = math.Random(1121);
        for (var i = 0; i < 1121; i++) {
          final value = random.nextInt(0xffffffff);
          expectBitCount(value, '1'.allMatches(value.toRadixString(2)).length);
        }
      });
    });
    test('hasSingleBit', () {
      for (var value in powersOf2) {
        expect(value.hasSingleBit, isTrue,
            reason: 'Expected $value to have a single bit.');
        if (value > 2) {
          final smaller = value - 1, bigger = value + 1;
          expect(smaller.hasSingleBit, isFalse);
          expect(bigger.hasSingleBit, isFalse);
        }
      }
    });
    test('bitFloor', () {
      for (var i = 0; i < powersOf2.length; i++) {
        final previous = i > 0 ? powersOf2[i - 1] : 0;
        final current = powersOf2[i];
        final middle = (previous + current) ~/ 2;
        expect(previous.bitFloor, previous);
        if (!middle.hasSingleBit) {
          expect(middle.bitFloor, previous);
        }
        expect(current.bitFloor, current);
      }
    });
    test('bitCeil', () {
      for (var i = 0; i < powersOf2.length; i++) {
        final previous = i > 0 ? powersOf2[i - 1] : 1;
        final current = powersOf2[i];
        final middle = (previous + current) ~/ 2;
        expect(previous.bitCeil, previous);
        if (!middle.hasSingleBit) {
          expect(middle.bitCeil, current);
        }
        expect(current.bitCeil, current);
      }
    });
  });
  group('digits', () {
    group('base 10', () {
      test('int', () {
        expect(0.digits(), [0]);
        expect(1.digits(), [1]);
        expect(12.digits(), [2, 1]);
        expect(123.digits(), [3, 2, 1]);
        expect(1001.digits(), [1, 0, 0, 1]);
        expect(10001.digits(), [1, 0, 0, 0, 1]);
        expect(1000.digits(), [0, 0, 0, 1]);
        expect(10000.digits(), [0, 0, 0, 0, 1]);
      });
      test('BigInt', () {
        expect(BigInt.from(0).digits(), [0]);
        expect(BigInt.from(1).digits(), [1]);
        expect(BigInt.from(12).digits(), [2, 1]);
        expect(BigInt.from(123).digits(), [3, 2, 1]);
        expect(BigInt.from(1001).digits(), [1, 0, 0, 1]);
        expect(BigInt.from(10001).digits(), [1, 0, 0, 0, 1]);
        expect(BigInt.from(1000).digits(), [0, 0, 0, 1]);
        expect(BigInt.from(10000).digits(), [0, 0, 0, 0, 1]);
      });
    });
    group('base 2', () {
      test('int', () {
        expect(0.digits(2), [0]);
        expect(1.digits(2), [1]);
        expect(12.digits(2), [0, 0, 1, 1]);
        expect(123.digits(2), [1, 1, 0, 1, 1, 1, 1]);
        expect(1001.digits(2), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(10001.digits(2), [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
        expect(1000.digits(2), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(10000.digits(2), [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      });
      test('BigInt', () {
        expect(BigInt.from(0).digits(2), [0]);
        expect(BigInt.from(1).digits(2), [1]);
        expect(BigInt.from(12).digits(2), [0, 0, 1, 1]);
        expect(BigInt.from(123).digits(2), [1, 1, 0, 1, 1, 1, 1]);
        expect(BigInt.from(1001).digits(2), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(BigInt.from(10001).digits(2),
            [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
        expect(BigInt.from(1000).digits(2), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(BigInt.from(10000).digits(2),
            [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      });
    });
    group('base 16', () {
      test('int', () {
        expect(0.digits(16), [0]);
        expect(1.digits(16), [1]);
        expect(12.digits(16), [12]);
        expect(123.digits(16), [11, 7]);
        expect(1001.digits(16), [9, 14, 3]);
        expect(10001.digits(16), [1, 1, 7, 2]);
        expect(1000.digits(16), [8, 14, 3]);
        expect(10000.digits(16), [0, 1, 7, 2]);
      });
      test('BigInt', () {
        expect(BigInt.from(0).digits(16), [0]);
        expect(BigInt.from(1).digits(16), [1]);
        expect(BigInt.from(12).digits(16), [12]);
        expect(BigInt.from(123).digits(16), [11, 7]);
        expect(BigInt.from(1001).digits(16), [9, 14, 3]);
        expect(BigInt.from(10001).digits(16), [1, 1, 7, 2]);
        expect(BigInt.from(1000).digits(16), [8, 14, 3]);
        expect(BigInt.from(10000).digits(16), [0, 1, 7, 2]);
      });
    });
    group('negative', () {
      test('int', () {
        expect((-0).digits(), [0]);
        expect((-1).digits(), [1]);
        expect((-12).digits(), [2, 1]);
        expect((-123).digits(), [3, 2, 1]);
      });
      test('BigInt', () {
        expect(BigInt.from(-0).digits(), [0]);
        expect(BigInt.from(-1).digits(), [1]);
        expect(BigInt.from(-12).digits(), [2, 1]);
        expect(BigInt.from(-123).digits(), [3, 2, 1]);
      });
    });
  });
  group('factorial', () {
    group('values', () {
      test('int', () {
        expect(0.factorial(), 1);
        expect(1.factorial(), 1);
        expect(5.factorial(), 120);
        expect(12.factorial(), 479001600);
        expect(20.factorial(), 2432902008176640000);
        expect(21.factorial(), 2432902008176640000 * 21);
        expect(22.factorial(), 2432902008176640000 * 21 * 22);
      });
      test('BigInt', () {
        expect(BigInt.from(0).factorial(), BigInt.from(1));
        expect(BigInt.from(1).factorial(), BigInt.from(1));
        expect(BigInt.from(5).factorial(), BigInt.from(120));
        expect(BigInt.from(12).factorial(), BigInt.from(479001600));
        expect(BigInt.from(20).factorial(), BigInt.from(2432902008176640000));
        expect(BigInt.from(21).factorial(),
            BigInt.from(2432902008176640000) * BigInt.from(21));
        expect(BigInt.from(22).factorial(),
            BigInt.from(2432902008176640000) * BigInt.from(21 * 22));
      });
    });
    group('bounds', () {
      test('int', () {
        expect(() => (-1).factorial(), throwsArgumentError);
      });
      test('BigInt', () {
        expect(() => (-BigInt.one).factorial(), throwsArgumentError);
      });
    });
  });
  group('hyperbolic', () {
    test('cosh', () {
      expect(0.cosh(), closeTo(1, epsilon));
      expect(1.cosh(), closeTo(1.5430806348152437, epsilon));
      expect((-1).cosh(), closeTo(1.5430806348152437, epsilon));
    });
    test('acosh', () {
      expect((-1).acosh(), isNaN);
      expect(0.acosh(), isNaN);
      expect(0.5.acosh(), isNaN);
      expect(1.acosh(), closeTo(0, epsilon));
      expect(2.acosh(), closeTo(1.3169578969248166, epsilon));
    });
    test('sinh', () {
      expect(0.sinh(), closeTo(0, epsilon));
      expect(1.sinh(), closeTo(1.1752011936438014, epsilon));
    });
    test('asinh', () {
      expect(1.asinh(), closeTo(0.881373587019543, epsilon));
      expect(0.asinh(), closeTo(0, epsilon));
      expect(double.negativeInfinity.asinh(), double.negativeInfinity);
    });
    test('tanh', () {
      expect(0.tanh(), closeTo(0, epsilon));
      expect(double.infinity.tanh(), closeTo(1, epsilon));
      expect(1.tanh(), closeTo(0.7615941559557649, epsilon));
    });
    test('atanh', () {
      expect(-2.atanh(), isNaN);
      expect(-1.atanh(), double.negativeInfinity);
      expect(0.atanh(), closeTo(0, epsilon));
      expect(0.5.atanh(), closeTo(0.5493061443340548, epsilon));
      expect(1.atanh(), double.infinity);
      expect(2.atanh(), isNaN);
    });
  });
  group('isProbablyPrime', () {
    const max = 100000;
    final primes = EratosthenesPrimeSieve(max);
    test('int', () {
      for (var i = 0; i < max; i++) {
        expect(i.isProbablyPrime, primes.isPrime(i));
      }
      const prime = 228204732751;
      expect(prime.isProbablyPrime, isTrue);
      expect((prime + 2).isProbablyPrime, isFalse);
    });
    test('BigInt', () {
      for (var i = 0; i < max; i++) {
        expect(BigInt.from(i).isProbablyPrime, primes.isPrime(i));
      }
      final prime = BigInt.parse('170141183460469231731687303715884105727');
      expect(prime.isProbablyPrime, isTrue);
      expect((prime + BigInt.two).isProbablyPrime, isFalse);
    });
    test('Complex', () {
      const a002145 = [3, 7, 11, 19, 23, 31, 43, 47, 59, 67, 71, 79, 83, 103];
      for (var i = 0; i < a002145.last; i++) {
        final values = [Complex(-i), Complex(i), Complex(0, -i), Complex(0, i)]
            .map((value) => value.isProbablyGaussianPrime);
        expect(values, everyElement(a002145.contains(i)));
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
            expect(value.isProbablyGaussianPrime, norm5.contains(value));
          }
        }
      }
      expect(const Complex(math.pi, math.e).isProbablyGaussianPrime, isFalse);
    });
  });
  group('lcm', () {
    test('int', () {
      expect(5.lcm(2), 10);
      expect(2.lcm(5), 10);
      expect(5.lcm(0), 0);
      expect(0.lcm(5), 0);
    });
    test('BigInt', () {
      expect(BigInt.from(5).lcm(BigInt.from(2)), BigInt.from(10));
      expect(BigInt.from(2).lcm(BigInt.from(5)), BigInt.from(10));
      expect(BigInt.from(5).lcm(BigInt.from(0)), BigInt.from(0));
      expect(BigInt.from(0).lcm(BigInt.from(5)), BigInt.from(0));
    });
  });
  group('math', () {
    test('pow(x, 0)', () {
      expect((-2).pow(0), 1);
      expect((-1).pow(0), 1);
      expect(0.pow(0), 1);
      expect(1.pow(0), 1);
      expect(2.pow(0), 1);
    });
    test('pow(x, 1)', () {
      expect((-2).pow(1), -2);
      expect((-1).pow(1), -1);
      expect(0.pow(1), 0);
      expect(1.pow(1), 1);
      expect(2.pow(1), 2);
    });
    test('pow(x, 5)', () {
      expect((-2).pow(5), -32);
      expect((-1).pow(5), -1);
      expect(0.pow(5), 0);
      expect(1.pow(5), 1);
      expect(2.pow(5), 32);
    });
    test('pow(x, -2)', () {
      expect((-2).pow(-2), 0.25);
      expect((-1).pow(-2), 1.0);
      expect(1.pow(-2), 1.0);
      expect(2.pow(-2), 0.25);
    });
    test('sin', () {
      expect(0.sin(), closeTo(0, epsilon));
      expect((0.5 * math.pi).sin(), closeTo(1, epsilon));
      expect(math.pi.sin(), closeTo(0, epsilon));
    });
    test('asin', () {
      expect(1.asin(), closeTo(1.5707963267948966, epsilon));
      expect(-1.asin(), closeTo(-1.5707963267948966, epsilon));
    });
    test('cos', () {
      expect(0.cos(), closeTo(1, epsilon));
      expect((0.5 * math.pi).cos(), closeTo(0, epsilon));
      expect(math.pi.cos(), closeTo(-1, epsilon));
    });
    test('acos', () {
      expect(1.acos(), closeTo(0, epsilon));
      expect((-1).acos(), closeTo(math.pi, epsilon));
    });
    test('tan', () {
      expect(0.tan(), closeTo(0, epsilon));
      expect(1.tan(), closeTo(1.55740772465, epsilon));
    });
    test('atan', () {
      expect(1.atan(), closeTo(0.7853981633974483, epsilon));
      expect((-1).atan(), closeTo(-0.7853981633974483, epsilon));
    });
    test('atan2', () {
      expect(1.atan2(2), closeTo(0.4636476090008061, epsilon));
      expect(2.atan2(1), closeTo(1.1071487177940904, epsilon));
    });
    test('sqrt', () {
      expect(2.sqrt(), closeTo(1.4142135623730951, epsilon));
      expect(3.sqrt(), closeTo(1.7320508075688772, epsilon));
      expect(4.sqrt(), closeTo(2.00, epsilon));
    });
    test('exp', () {
      expect(0.exp(), closeTo(1, epsilon));
      expect(1.exp(), closeTo(math.e, epsilon));
      expect((-1).exp(), closeTo(1 / math.e, epsilon));
    });
    test('log', () {
      expect(1.log(), closeTo(0, epsilon));
      expect(math.e.log(), closeTo(1, epsilon));
      expect((1 / math.e).log(), closeTo(-1, epsilon));
    });
    test('between', () {
      expect(2.between(1, 3), isTrue);
      expect(2.between(2, 3), isTrue);
      expect(2.between(1, 2), isTrue);
      expect(2.between(0, 1), isFalse);
      expect(2.between(3, 4), isFalse);
    });
    test('clip', () {
      expect(-2.clip(-1, 1), -1);
      expect(-1.clip(-1, 1), -1);
      expect(0.clip(-1, 1), 0);
      expect(1.clip(-1, 1), 1);
      expect(2.clip(-1, 1), 1);
    });
  });
  group('polynomial', () {
    test('base 2', () {
      expect(<int>[].polynomial(2), 0);
      expect([1, 2].polynomial(2), 5);
      expect([1, 2, 3].polynomial(2), 17);
      expect([1, 2, 3, 4].polynomial(2), 49);
    });
    test('base 10', () {
      expect(<int>[].polynomial(), 0);
      expect([1, 2].polynomial(), 21);
      expect([1, 2, 3].polynomial(), 321);
      expect([1, 2, 3, 4].polynomial(), 4321);
    });
  });
  group('prime sieves', () {
    void primeSieveTests(PrimeSieve Function(int n) create) {
      test('primes', () {
        expect(create(7).primes, [2, 3, 5, 7]);
        expect(create(12).primes, [2, 3, 5, 7, 11]);
        expect(create(20).primes, [2, 3, 5, 7, 11, 13, 17, 19]);
        expect(create(31).primes, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]);
      });
      test('primes (edge cases)', () {
        expect(() => create(-1).primes, throwsRangeError);
        expect(create(0).primes, isEmpty);
        expect(create(1).primes, isEmpty);
        expect(create(2).primes, [2]);
      });
      test('isPrime', () {
        const primes = [
          2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, //
          59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, //
          127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, //
          191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, //
          257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317 //
        ];
        final sieve = create(primes.last);
        for (var i = 0; i <= primes.last; i++) {
          final isPrime = primes.contains(i);
          expect(sieve.isPrime(i), isPrime,
              reason: '$i expected to ${isPrime ? '' : 'not'} be prime');
        }
      });
      test('isPrime (edge cases)', () {
        final sieve = create(5);
        expect(() => sieve.isPrime(-1), throwsRangeError);
        expect(() => sieve.isPrime(6), throwsRangeError);
      });
      test('large', () {
        expect(create(2000).primes.skipWhile((each) => each < 1000).take(5),
            [1009, 1013, 1019, 1021, 1031]);
        expect(create(20000).primes.skipWhile((each) => each < 10000).take(5),
            [10007, 10009, 10037, 10039, 10061]);
        expect(create(200000).primes.skipWhile((each) => each < 100000).take(5),
            [100003, 100019, 100043, 100049, 100057]);
      });
      test('twins', () {
        final twins = create(150)
            .primes
            .window(2)
            .where((pair) => pair[1] - pair[0] == 2);
        expect(twins, [
          [3, 5],
          [5, 7],
          [11, 13],
          [17, 19],
          [29, 31],
          [41, 43],
          [59, 61],
          [71, 73],
          [101, 103],
          [107, 109],
          [137, 139],
        ]);
      });
    }

    group('atkin', () {
      primeSieveTests((n) => AtkinPrimeSieve(n));
    });
    group('eratosthenes', () {
      primeSieveTests((n) => EratosthenesPrimeSieve(n));
    });
    group('euler', () {
      primeSieveTests((n) => EulerPrimeSieve(n));
      test('factorization', () {
        final sieve = EulerPrimeSieve(20);
        final factorization = 0
            .to(sieve.max + 1)
            .toMap<int, List<int>>(value: (each) => sieve.factorize(each));
        expect(factorization, <int, List<int>>{
          0: [],
          1: [],
          2: [2],
          3: [3],
          4: [2, 2],
          5: [5],
          6: [2, 3],
          7: [7],
          8: [2, 2, 2],
          9: [3, 3],
          10: [2, 5],
          11: [11],
          12: [2, 2, 3],
          13: [13],
          14: [2, 7],
          15: [3, 5],
          16: [2, 2, 2, 2],
          17: [17],
          18: [2, 3, 3],
          19: [19],
          20: [2, 2, 5],
        });
      });
      test('factorization (large)', () {
        final sieve = EulerPrimeSieve(100000);
        for (var i = 2; i <= sieve.max; i++) {
          final factors = sieve.factorize(i);
          expect(factors.reduce((a, b) => a * b), i);
        }
      });
      test('factorization (edge cases)', () {
        final sieve = EulerPrimeSieve(20);
        expect(() => sieve.factorize(-1), throwsRangeError);
        expect(() => sieve.factorize(21), throwsRangeError);
      });
    });
  });
}
