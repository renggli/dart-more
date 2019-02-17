library more.test.hash_test;

import 'package:more/collection.dart';
import 'package:more/hash.dart';
import 'package:more/iterable.dart';
import 'package:test/test.dart';

void main() {
  group('hash', () {
    test('empty', () {
      final hashCode = HashCode().value;
      expect(hashCode, 0);
    });
    test('add', () {
      final hashCode1 = HashCode().add(1).value;
      final hashCode2 = HashCode().add(1).value;
      expect(hashCode1, hashCode2);
    });
    test('addAll', () {
      final hashCode1 = HashCode().add(1).add(2).add(3).value;
      final hashCode2 = HashCode().addAll([1, 2, 3]).value;
      expect(hashCode1, hashCode2);
    });
    test('combinations', () {
      final hashCodes = <int, List<int>>{};
      for (var combination
          in combinations(IntegerRange(8), 5, repetitions: true)) {
        final hashCode = HashCode().addAll(combination).value;
        if (hashCodes.containsKey(hashCode)) {
          fail('$combination and ${hashCodes[hashCode]} have identical hash.');
        }
      }
    });
    test('permutations', () {
      final hashCodes = <int, List<int>>{};
      for (var permutation in permutations(IntegerRange(8))) {
        final hashCode = HashCode().addAll(permutation).value;
        if (hashCodes.containsKey(hashCode)) {
          fail('$permutation and ${hashCodes[hashCode]} have identical hash.');
        }
      }
    });
  });
}
