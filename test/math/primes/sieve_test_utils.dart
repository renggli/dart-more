import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void primeSieveTests(PrimeSieve Function(int n) create) {
  test('primes', () {
    check(create(7).primes).deepEquals([2, 3, 5, 7]);
    check(create(12).primes).deepEquals([2, 3, 5, 7, 11]);
    check(create(20).primes).deepEquals([2, 3, 5, 7, 11, 13, 17, 19]);
    check(create(31).primes)
        .deepEquals([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]);
  });
  test('primes (edge cases)', () {
    check(() => create(-1).primes).throws<RangeError>();
    check(create(0).primes).isEmpty();
    check(create(1).primes).isEmpty();
    check(create(2).primes).deepEquals([2]);
  });
  test('isPrime', () {
    const primes = [
      2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, //
      59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, //
      127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, //
      191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, //
      257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, //
    ];
    final sieve = create(primes.last);
    for (var i = 0; i <= primes.last; i++) {
      final isPrime = primes.contains(i);
      check(
        because: '$i expected to ${isPrime ? '' : 'not'} be prime',
        sieve.isPrime(i),
      ).equals(isPrime);
    }
  });
  test('isPrime (edge cases)', () {
    final sieve = create(5);
    check(() => sieve.isPrime(-1)).throws<RangeError>();
    check(() => sieve.isPrime(6)).throws<RangeError>();
  });
  test('large', () {
    check(create(2000).primes.skipWhile((each) => each < 1000).take(5))
        .deepEquals([1009, 1013, 1019, 1021, 1031]);
    check(create(20000).primes.skipWhile((each) => each < 10000).take(5))
        .deepEquals([10007, 10009, 10037, 10039, 10061]);
    check(create(200000).primes.skipWhile((each) => each < 100000).take(5))
        .deepEquals([100003, 100019, 100043, 100049, 100057]);
  });
  test('twins', () {
    final twins = create(150).primes
        .window(2)
        .where((pair) => pair[1] - pair[0] == 2);
    check(twins).deepEquals([
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
