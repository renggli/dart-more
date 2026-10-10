import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('combinations', () {
    final letters = 'abcd'.toList();

    group('with repetitions', () {
      test('take 0', () {
        final iterable = letters.combinations(0, repetitions: true);
        check(iterable).deepEquals(<List<String>>[[]]);
      });
      test('take 1', () {
        final iterable = letters.combinations(1, repetitions: true);
        check(iterable).deepEquals([
          ['a'],
          ['b'],
          ['c'],
          ['d'],
        ]);
      });
      test('take 2', () {
        final iterable = letters.combinations(2, repetitions: true);
        check(iterable.map(joiner)).deepEquals([
          'aa',
          'ab',
          'ac',
          'ad',
          'bb',
          'bc',
          'bd',
          'cc',
          'cd',
          'dd',
        ]);
      });
      test('take 3', () {
        final iterable = letters.combinations(3, repetitions: true);
        check(iterable.map(joiner)).deepEquals([
          'aaa',
          'aab',
          'aac',
          'aad',
          'abb',
          'abc',
          'abd',
          'acc',
          'acd',
          'add',
          'bbb',
          'bbc',
          'bbd',
          'bcc',
          'bcd',
          'bdd',
          'ccc',
          'ccd',
          'cdd',
          'ddd',
        ]);
      });
      test('take 4', () {
        final iterable = letters.combinations(4, repetitions: true);
        check(iterable.map(joiner)).deepEquals([
          'aaaa',
          'aaab',
          'aaac',
          'aaad',
          'aabb',
          'aabc',
          'aabd',
          'aacc',
          'aacd',
          'aadd',
          'abbb',
          'abbc',
          'abbd',
          'abcc',
          'abcd',
          'abdd',
          'accc',
          'accd',
          'acdd',
          'addd',
          'bbbb',
          'bbbc',
          'bbbd',
          'bbcc',
          'bbcd',
          'bbdd',
          'bccc',
          'bccd',
          'bcdd',
          'bddd',
          'cccc',
          'cccd',
          'ccdd',
          'cddd',
          'dddd',
        ]);
      });
      test('take 5', () {
        final iterable = letters.combinations(5, repetitions: true);
        check(iterable.first.join()).equals('aaaaa');
        check(iterable.last.join()).equals('ddddd');
        check(iterable.length).equals(56);
      });
      test('take 6', () {
        final iterable = letters.combinations(6, repetitions: true);
        check(iterable.first.join()).equals('aaaaaa');
        check(iterable.last.join()).equals('dddddd');
        check(iterable.length).equals(84);
      });
    });

    group('without repetions', () {
      test('take 0', () {
        final iterable = letters.combinations(0, repetitions: false);
        check(iterable).deepEquals(<List<String>>[[]]);
      });
      test('take 1', () {
        final iterable = letters.combinations(1, repetitions: false);
        check(iterable).deepEquals([
          ['a'],
          ['b'],
          ['c'],
          ['d'],
        ]);
      });
      test('take 2', () {
        final iterable = letters.combinations(2, repetitions: false);
        check(iterable.map(joiner))
            .deepEquals(['ab', 'ac', 'ad', 'bc', 'bd', 'cd']);
      });
      test('take 3', () {
        final iterable = letters.combinations(3, repetitions: false);
        check(iterable.map(joiner)).deepEquals(['abc', 'abd', 'acd', 'bcd']);
      });
      test('take 4', () {
        final iterable = letters.combinations(4, repetitions: false);
        check(iterable.map(joiner)).deepEquals(['abcd']);
      });
    });

    test('range error', () {
      check(() => letters.combinations(-1)).throws<RangeError>();
      check(() => letters.combinations(-1, repetitions: true))
          .throws<RangeError>();
      check(() => letters.combinations(-1, repetitions: false))
          .throws<RangeError>();
      check(() => letters.combinations(5, repetitions: false))
          .throws<RangeError>();
    });

    test('empty input', () {
      check(<int>[].combinations(0, repetitions: true))
          .deepEquals(<List<int>>[[]]);
      check(<int>[].combinations(0, repetitions: false))
          .deepEquals(<List<int>>[[]]);
      check(<int>[].combinations(2, repetitions: true)).isEmpty();
    });
  });
}
