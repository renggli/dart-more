library more.test.hash_test;

import 'package:more/collection.dart';
import 'package:more/hash.dart';
import 'package:more/iterable.dart';
import 'package:test/test.dart';

void main() {
  group('hash', () {
    test('hash0', () {
      expect(hash([]), isZero);
    });
    test('hash1', () {
      expect(hash([1]), hash1(1));
    });
    test('hash2', () {
      expect(hash([1, 2]), hash2(1, 2));
    });
    test('hash3', () {
      expect(hash([1, 2, 3]), hash3(1, 2, 3));
    });
    test('hash4', () {
      expect(hash([1, 2, 3, 4]), hash4(1, 2, 3, 4));
    });
    test('hash5', () {
      expect(hash([1, 2, 3, 4, 5]), hash5(1, 2, 3, 4, 5));
    });
    test('hash6', () {
      expect(hash([1, 2, 3, 4, 5, 6]), hash6(1, 2, 3, 4, 5, 6));
    });
    test('hash7', () {
      expect(hash([1, 2, 3, 4, 5, 6, 7]), hash7(1, 2, 3, 4, 5, 6, 7));
    });
    test('hash8', () {
      expect(hash([1, 2, 3, 4, 5, 6, 7, 8]), hash8(1, 2, 3, 4, 5, 6, 7, 8));
    });
    test('hash9', () {
      expect(
          hash([1, 2, 3, 4, 5, 6, 7, 8, 9]), hash9(1, 2, 3, 4, 5, 6, 7, 8, 9));
    });
    test('combinations', () {
      final hashCodes = <int, List<int>>{};
      for (final combination in 0.to(7).combinations(5, repetitions: true)) {
        final hashCode = hash(combination);
        if (hashCodes.containsKey(hashCode)) {
          fail('$combination and ${hashCodes[hashCode]} have identical hash.');
        }
        hashCodes[hashCode] = combination;
      }
    });
    test('permutations', () {
      final hashCodes = <int, List<int>>{};
      for (final permutation in 0.to(7).permutations()) {
        final hashCode = hash(permutation);
        if (hashCodes.containsKey(hashCode)) {
          fail('$permutation and ${hashCodes[hashCode]} have identical hash.');
        }
        hashCodes[hashCode] = permutation;
      }
    });
  });
}
