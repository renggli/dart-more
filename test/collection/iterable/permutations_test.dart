import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('permutations', () {
    group('full permutations', () {
      test('empty', () {
        final iterator = ''.toList().permutations();
        check(iterator).deepEquals(<List<String>>[[]]);
      });
      test('single', () {
        final iterator = 'a'.toList().permutations();
        check(iterator.map(joiner)).deepEquals(['a']);
      });
      test('2 element list', () {
        final iterator = 'ab'.toList().permutations();
        check(iterator.map(joiner)).deepEquals(['ab', 'ba']);
      });
      test('3 element list', () {
        final iterator = 'abc'.toList().permutations();
        check(iterator.map(joiner))
            .deepEquals(['abc', 'acb', 'bac', 'bca', 'cab', 'cba']);
      });
    });

    group('partial permutations', () {
      test('0 of 2', () {
        final iterator = 'abc'.toList().permutations(0);
        check(iterator).deepEquals(<List<String>>[[]]);
      });
      test('1 of 3', () {
        final iterator = 'abc'.toList().permutations(1);
        check(iterator.map(joiner)).deepEquals(['a', 'b', 'c']);
      });
      test('2 of 3', () {
        final iterator = 'abc'.toList().permutations(2);
        check(iterator.map(joiner))
            .deepEquals(['ab', 'ac', 'ba', 'bc', 'ca', 'cb']);
      });
      test('2 of 4', () {
        final iterator = 'abcd'.toList().permutations(2);
        check(iterator.map(joiner)).deepEquals([
          'ab',
          'ac',
          'ad',
          'ba',
          'bc',
          'bd',
          'ca',
          'cb',
          'cd',
          'da',
          'db',
          'dc',
        ]);
      });
      test('error', () {
        check(() => 'abc'.toList().permutations(4)).throws<RangeError>();
        check(() => 'abc'.toList().permutations(-1)).throws<RangeError>();
      });
    });

    group('nextPermutation', () {
      test('none', () {
        check(<int>[].nextPermutation()).isFalse();
        check([1].nextPermutation()).isFalse();
      });
      test('default', () {
        final list = [1, 2, 3];
        check(list.nextPermutation()).isTrue();
        check(list).deepEquals([1, 3, 2]);
        check(list.nextPermutation()).isTrue();
        check(list).deepEquals([2, 1, 3]);
        check(list.nextPermutation()).isTrue();
        check(list).deepEquals([2, 3, 1]);
        check(list.nextPermutation()).isTrue();
        check(list).deepEquals([3, 1, 2]);
        check(list.nextPermutation()).isTrue();
        check(list).deepEquals([3, 2, 1]);
        check(list.nextPermutation()).isFalse();
        check(list).deepEquals([3, 2, 1]);
      });
      test('custom', () {
        final list = [
          const Point<int>(2, 2),
          const Point<int>(3, 3),
          const Point<int>(1, 1),
        ];
        check(list.nextPermutation(comparator: (a, b) => a.x.compareTo(b.x)))
            .isTrue();
        check(list).deepEquals([
          const Point<int>(3, 3),
          const Point<int>(1, 1),
          const Point<int>(2, 2),
        ]);
      });
    });

    group('previousPermutation', () {
      test('none', () {
        check(<int>[].previousPermutation()).isFalse();
        check([1].previousPermutation()).isFalse();
      });
      test('default', () {
        final list = [3, 2, 1];
        check(list.previousPermutation()).isTrue();
        check(list).deepEquals([3, 1, 2]);
        check(list.previousPermutation()).isTrue();
        check(list).deepEquals([2, 3, 1]);
        check(list.previousPermutation()).isTrue();
        check(list).deepEquals([2, 1, 3]);
        check(list.previousPermutation()).isTrue();
        check(list).deepEquals([1, 3, 2]);
        check(list.previousPermutation()).isTrue();
        check(list).deepEquals([1, 2, 3]);
        check(list.previousPermutation()).isFalse();
        check(list).deepEquals([1, 2, 3]);
      });
      test('custom', () {
        final list = [
          const Point<int>(2, 2),
          const Point<int>(3, 3),
          const Point<int>(1, 1),
        ];
        check(
          list.previousPermutation(comparator: (a, b) => a.x.compareTo(b.x)),
        ).isTrue();
        check(list).deepEquals([
          const Point<int>(2, 2),
          const Point<int>(1, 1),
          const Point<int>(3, 3),
        ]);
      });
    });
  });
}
