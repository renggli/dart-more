import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

import 'sieve_test_utils.dart';

void main() {
  group('EulerPrimeSieve', () {
    primeSieveTests(EulerPrimeSieve.new);
    test('factorization', () {
      final sieve = EulerPrimeSieve(20);
      final factorization = 0
          .to(sieve.max + 1)
          .toMap<int, List<int>>(value: sieve.factorize);
      check(factorization).deepEquals(<int, List<int>>{
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
        check(factors.reduce((a, b) => a * b)).equals(i);
      }
    });
    test('factorization (edge cases)', () {
      final sieve = EulerPrimeSieve(20);
      check(() => sieve.factorize(-1)).throws<RangeError>();
      check(() => sieve.factorize(21)).throws<RangeError>();
    });
  });
}
