import 'dart:math' show Random;

import 'package:more/collection.dart';
import 'package:more/iterable.dart';
import 'package:test/test.dart';

void main() {
  String joiner(Iterable<String> iterable) => iterable.join();

  group('chunked', () {
    test('empty', () {
      final iterable = <int>[].chunked(2);
      expect(iterable, <int>[]);
    });
    test('even', () {
      final iterable = [1, 2, 3, 4].chunked(2);
      expect(iterable, [
        [1, 2],
        [3, 4]
      ]);
    });
    test('odd', () {
      final iterable = [1, 2, 3, 4, 5].chunked(2);
      expect(iterable, [
        [1, 2],
        [3, 4],
        [5]
      ]);
    });
    group('with padding', () {
      test('empty', () {
        final iterable = <int>[].chunkedWithPadding(2, 0);
        expect(iterable, <int>[]);
      });
      test('even', () {
        final iterable = [1, 2, 3, 4].chunkedWithPadding(2, 0);
        expect(iterable, [
          [1, 2],
          [3, 4]
        ]);
      });
      test('odd', () {
        final iterable = [1, 2, 3, 4, 5].chunkedWithPadding(2, 0);
        expect(iterable, [
          [1, 2],
          [3, 4],
          [5, 0]
        ]);
      });
    });
  });
  group('combinations', () {
    final letters = 'abcd'.toList();
    group('with repetitions', () {
      test('take 0', () {
        final iterable = letters.combinations(0, repetitions: true);
        expect(iterable, isEmpty);
      });
      test('take 1', () {
        final iterable = letters.combinations(1, repetitions: true);
        expect(iterable, [
          ['a'],
          ['b'],
          ['c'],
          ['d']
        ]);
      });
      test('take 2', () {
        final iterable = letters.combinations(2, repetitions: true);
        expect(iterable.map(joiner),
            ['aa', 'ab', 'ac', 'ad', 'bb', 'bc', 'bd', 'cc', 'cd', 'dd']);
      });
      test('take 3', () {
        final iterable = letters.combinations(3, repetitions: true);
        expect(iterable.map(joiner), [
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
          'ddd'
        ]);
      });
      test('take 4', () {
        final iterable = letters.combinations(4, repetitions: true);
        expect(iterable.map(joiner), [
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
          'dddd'
        ]);
      });
      test('take 5', () {
        final iterable = letters.combinations(5, repetitions: true);
        expect(iterable.first.join(), 'aaaaa');
        expect(iterable.last.join(), 'ddddd');
        expect(iterable.length, 56);
      });
      test('take 6', () {
        final iterable = letters.combinations(6, repetitions: true);
        expect(iterable.first.join(), 'aaaaaa');
        expect(iterable.last.join(), 'dddddd');
        expect(iterable.length, 84);
      });
    });
    group('without repetions', () {
      test('take 0', () {
        final iterable = letters.combinations(0, repetitions: false);
        expect(iterable, isEmpty);
      });
      test('take 1', () {
        final iterable = letters.combinations(1, repetitions: false);
        expect(iterable, [
          ['a'],
          ['b'],
          ['c'],
          ['d']
        ]);
      });
      test('take 2', () {
        final iterable = letters.combinations(2, repetitions: false);
        expect(iterable.map(joiner), ['ab', 'ac', 'ad', 'bc', 'bd', 'cd']);
      });
      test('take 3', () {
        final iterable = letters.combinations(3, repetitions: false);
        expect(iterable.map(joiner), ['abc', 'abd', 'acd', 'bcd']);
      });
      test('take 4', () {
        final iterable = letters.combinations(4, repetitions: false);
        expect(iterable.map(joiner), ['abcd']);
      });
    });
    test('range error', () {
      expect(() => letters.combinations(-1), throwsRangeError);
      expect(
          () => letters.combinations(-1, repetitions: true), throwsRangeError);
      expect(
          () => letters.combinations(-1, repetitions: false), throwsRangeError);
      expect(
          () => letters.combinations(5, repetitions: false), throwsRangeError);
    });
  });
  group('cycle', () {
    test('empty', () {
      expect([].cycle(), isEmpty);
      expect([].cycle(5), isEmpty);
      expect([1, 2].cycle(0), isEmpty);
    });
    test('fixed', () {
      expect([1, 2].cycle(1), [1, 2]);
      expect([1, 2].cycle(2), [1, 2, 1, 2]);
      expect([1, 2].cycle(3), [1, 2, 1, 2, 1, 2]);
    });
    test('infinite', () {
      expect([1, 2].cycle().isEmpty, isFalse);
      expect([1, 2].cycle().isNotEmpty, isTrue);
      expect([1, 2].cycle().take(3), [1, 2, 1]);
      expect([1, 2].cycle().skip(3).take(3), [2, 1, 2]);
    });
    test('invalid', () {
      expect(() => [1, 2].cycle(-1), throwsArgumentError);
    });
    test('infinite', () {
      final infinite = [1, 2].cycle();
      expect(infinite.cycle().isEmpty, isFalse);
      expect(infinite.isNotEmpty, isTrue);
      expect(() => infinite.length, throwsUnsupportedError);
      expect(() => infinite.last, throwsUnsupportedError);
      expect(() => infinite.lastWhere((e) => false), throwsUnsupportedError);
      expect(() => infinite.single, throwsUnsupportedError);
      expect(() => infinite.singleWhere((e) => false), throwsUnsupportedError);
      expect(() => infinite.toList(), throwsUnsupportedError);
      expect(() => infinite.toSet(), throwsUnsupportedError);
    });
  });
  group('flatMap', () {
    test('empty', () {
      expect([].flatMap((each) => throw StateError('Never to be called')), []);
    });
    test('expand', () {
      expect(['a'].flatMap((each) => [1, 2]), [1, 2]);
    });
    test('collapse', () {
      expect(['a', 'b'].flatMap((each) => []), []);
    });
  });
  group('flatten', () {
    test('empty', () {
      expect([[], [], []].flatten(), []);
    });
    test('single', () {
      expect(
          [
            [1],
            [2],
            [3],
          ].flatten(),
          [1, 2, 3]);
    });
    test('double', () {
      expect(
          [
            [1, 2],
            [3, 4],
            [5, 6],
          ].flatten(),
          [1, 2, 3, 4, 5, 6]);
    });
  });
  group('groupBy', () {
    final example = 'aaaabbbccdaabbb'.toList();
    test('groupBy empty', () {
      final iterable = [].groupBy();
      expect(iterable, []);
    });
    test('groupBy basic', () {
      final iterable = example.groupBy();
      expect(iterable.map((each) => each.key), ['a', 'b', 'c', 'd', 'a', 'b']);
      expect(iterable.map((each) => each.values), [
        ['a', 'a', 'a', 'a'],
        ['b', 'b', 'b'],
        ['c', 'c'],
        ['d'],
        ['a', 'a'],
        ['b', 'b', 'b'],
      ]);
    });
    test('groupBy mapping', () {
      final iterable = example.reversed.groupBy((key) => key.codeUnitAt(0));
      expect(iterable.map((each) => each.key), [98, 97, 100, 99, 98, 97]);
      expect(iterable.map((each) => each.values), [
        ['b', 'b', 'b'],
        ['a', 'a'],
        ['d'],
        ['c', 'c'],
        ['b', 'b', 'b'],
        ['a', 'a', 'a', 'a']
      ]);
    });
  });
  group('indexed', () {
    test('empty', () {
      final iterable = [].indexed();
      expect(iterable, []);
    });
    test('simple', () {
      final iterable = ['a', 'b', 'c'].indexed();
      expect(iterable.map((each) => each.index), [0, 1, 2]);
      expect(iterable.map((each) => each.value), ['a', 'b', 'c']);
    });
    test('offset', () {
      final actual = ['a', 'b']
          .indexed(offset: 1)
          .map((each) => '${each.value}-${each.index}')
          .join(', ');
      const expected = 'a-1, b-2';
      expect(actual, expected);
    });
  });
  group('iterate', () {
    test('natural numbers', () {
      final iterable = iterate<int>(0, (a) => a + 1);
      expect(iterable.take(10), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('powers of two', () {
      final iterable = iterate<int>(1, (a) => 2 * a);
      expect(iterable.take(10), [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]);
    });
  });
  group('operators', () {
    final empty = <int>[];
    final bools = {true, false};
    group('min', () {
      test('empty error', () {
        expect(() => empty.min(), throwsStateError);
        expect(empty.min(orElse: () => -1), -1);
      });
      test('comparable', () {
        expect([1, 2, 3].min(), 1);
        expect([3, 2, 1].min(), 1);
      });
      test('comparable, with key', () {
        expect([1, 2, 3].min(key: (value) => -value), 3);
        expect([3, 2, 1].min(key: (value) => -value), 3);
      });
      test('not comparable', () {
        expect(() => bools.min(), throwsA(isA<TypeError>()));
      });
      test('not comparable, with key', () {
        expect(bools.min(key: (value) => value.toString().length), isTrue);
      });
    });
    group('max', () {
      test('empty error', () {
        expect(() => empty.max(), throwsStateError);
        expect(empty.max(orElse: () => -1), -1);
      });
      test('comparable', () {
        expect([1, 2, 3].max(), 3);
        expect([3, 2, 1].max(), 3);
      });
      test('comparable, with key', () {
        expect([1, 2, 3].max(key: (value) => -value), 1);
        expect([3, 2, 1].max(key: (value) => -value), 1);
      });
      test('not comparable', () {
        expect(() => bools.max(), throwsA(isA<TypeError>()));
      });
      test('not comparable, with key', () {
        expect(bools.max(key: (value) => value.toString().length), isFalse);
      });
    });
    group('percentile', () {
      test('empty error', () {
        expect(() => empty.percentile(0.5), throwsStateError);
        expect(empty.percentile(0.5, orElse: () => -1), -1);
      });
      test('range error', () {
        expect(() => [0].percentile(-1), throwsRangeError);
        expect(() => [0].percentile(2), throwsRangeError);
      });
      test('comparable', () {
        expect([1, 2, 3].percentile(0.0), 1);
        expect([1, 2, 3].percentile(0.5), 2);
        expect([1, 2, 3].percentile(1.0), 3);
        expect([3, 2, 1].percentile(0.0), 1);
        expect([3, 2, 1].percentile(0.5), 2);
        expect([3, 2, 1].percentile(1.0), 3);
      });
      test('comparable, with key', () {
        expect([1, 2, 3].percentile(0.0, key: (value) => -value), 3);
        expect([1, 2, 3].percentile(0.5, key: (value) => -value), 2);
        expect([1, 2, 3].percentile(1.0, key: (value) => -value), 1);
        expect([3, 2, 1].percentile(0.0, key: (value) => -value), 3);
        expect([3, 2, 1].percentile(0.5, key: (value) => -value), 2);
        expect([3, 2, 1].percentile(1.0, key: (value) => -value), 1);
      });
      test('not comparable', () {
        expect(() => bools.percentile(0), throwsA(isA<TypeError>()));
        expect(() => bools.percentile(1), throwsA(isA<TypeError>()));
      });
      test('not comparable, with key', () {
        expect(bools.percentile(0, key: (value) => value.toString().length),
            isTrue);
        expect(bools.percentile(1, key: (value) => value.toString().length),
            isFalse);
      });
      test('already ordered', () {
        expect([1, 2, 3].percentile(0.0, isOrdered: true), 1);
        expect([1, 2, 3].percentile(0.5, isOrdered: true), 2);
        expect([1, 2, 3].percentile(1.0, isOrdered: true), 3);
        expect([3, 2, 1].percentile(0.0, isOrdered: true), 3);
        expect([3, 2, 1].percentile(0.5, isOrdered: true), 2);
        expect([3, 2, 1].percentile(1.0, isOrdered: true), 1);
      });
    });
  });
  group('permutations', () {
    test('0', () {
      final iterator = ''.toList().permutations();
      expect(iterator, []);
    });
    test('1', () {
      final iterator = 'a'.toList().permutations();
      expect(iterator, [
        ['a']
      ]);
    });
    test('2', () {
      final iterator = 'ab'.toList().permutations();
      expect(iterator, [
        ['a', 'b'],
        ['b', 'a']
      ]);
    });
    test('3', () {
      final iterator = 'abc'.toList().permutations();
      expect(iterator.map(joiner), ['abc', 'acb', 'bac', 'bca', 'cab', 'cba']);
    });
    test('4', () {
      final iterator = 'abcd'.toList().permutations();
      expect(iterator.map(joiner), [
        'abcd',
        'abdc',
        'acbd',
        'acdb',
        'adbc',
        'adcb',
        'bacd',
        'badc',
        'bcad',
        'bcda',
        'bdac',
        'bdca',
        'cabd',
        'cadb',
        'cbad',
        'cbda',
        'cdab',
        'cdba',
        'dabc',
        'dacb',
        'dbac',
        'dbca',
        'dcab',
        'dcba'
      ]);
    });
  });
  group('periodical', () {
    final date = DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90);
    group('periodical', () {
      test('millennially', () {
        final iterable = date.periodical(period: Period.millennially);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(3980, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('centennially', () {
        final iterable = date.periodical(period: Period.centennially);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2080, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2180, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('decennially', () {
        final iterable = date.periodical(period: Period.decennially);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1990, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2000, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('yearly', () {
        final iterable = date.periodical(period: Period.yearly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1981, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1982, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('quarterly', () {
        final iterable = date.periodical(period: Period.quarterly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.september, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.december, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('monthly', () {
        final iterable = date.periodical(period: Period.monthly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.july, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.august, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('weekly', () {
        final iterable = date.periodical(period: Period.weekly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 18, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 25, 12, 34, 56, 78, 90),
        ]);
      });
      test('daily', () {
        final iterable = date.periodical(period: Period.daily);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 12, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 13, 12, 34, 56, 78, 90),
        ]);
      });
      test('hourly', () {
        final iterable = date.periodical(period: Period.hourly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 13, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 14, 34, 56, 78, 90),
        ]);
      });
      test('minutely', () {
        final iterable = date.periodical(period: Period.minutely);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 35, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 36, 56, 78, 90),
        ]);
      });
      test('secondly', () {
        final iterable = date.periodical(period: Period.secondly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 57, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 58, 78, 90),
        ]);
      });
      test('millisecondly', () {
        final iterable = date.periodical(period: Period.millisecondly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 79, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 80, 90),
        ]);
      });
      test('microsecondly', () {
        final iterable = date.periodical(period: Period.microsecondly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 91),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 92),
        ]);
      });
      test('invalid step', () {
        expect(() => date.periodical(step: 0), throwsArgumentError);
      });
    });
    group('truncate', () {
      test('millennially', () {
        final truncated = date.truncate(period: Period.millennially);
        expect(truncated, DateTime(1000));
      });
      test('centennially', () {
        final truncated = date.truncate(period: Period.centennially);
        expect(truncated, DateTime(1900));
      });
      test('decennially', () {
        final truncated = date.truncate(period: Period.decennially);
        expect(truncated, DateTime(1980));
      });
      test('yearly', () {
        final truncated = date.truncate(period: Period.yearly);
        expect(truncated, DateTime(1980));
      });
      test('quarterly', () {
        final truncated = date.truncate(period: Period.quarterly);
        expect(truncated, DateTime(1980, DateTime.april));
      });
      test('monthly', () {
        final truncated = date.truncate(period: Period.monthly);
        expect(truncated, DateTime(1980, DateTime.june));
      });
      test('weekly', () {
        final truncated = date.truncate(period: Period.weekly);
        expect(truncated, DateTime(1980, DateTime.june, 9));
      });
      test('weekly (custom start of the week)', () {
        for (var weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++) {
          final truncated =
              date.truncate(period: Period.weekly, startWeekday: weekday);
          expect(truncated.isBefore(date), isTrue);
          expect(truncated.weekday, weekday);
        }
      });
      test('daily', () {
        final truncated = date.truncate(period: Period.daily);
        expect(truncated, DateTime(1980, DateTime.june, 11));
      });
      test('hourly', () {
        final truncated = date.truncate(period: Period.hourly);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12));
      });
      test('minutely', () {
        final truncated = date.truncate(period: Period.minutely);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34));
      });
      test('secondly', () {
        final truncated = date.truncate(period: Period.secondly);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56));
      });
      test('millisecondly', () {
        final truncated = date.truncate(period: Period.millisecondly);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78));
      });
      test('microsecondly', () {
        final truncated = date.truncate(period: Period.microsecondly);
        expect(
            truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90));
      });
      test('invalid start weekday', () {
        expect(
            () => date.truncate(
                period: Period.weekly, startWeekday: DateTime.monday - 1),
            throwsArgumentError);
        expect(
            () => date.truncate(
                period: Period.weekly, startWeekday: DateTime.sunday + 1),
            throwsArgumentError);
      });
    });
  });
  group('product', () {
    test('2', () {
      final iterable = [
        [1, 2],
      ].product();
      expect(iterable, [
        [1],
        [2],
      ]);
    });
    test('2 x 2', () {
      final iterable = [
        [1, 2],
        [3, 4],
      ].product();
      expect(iterable, [
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4],
      ]);
    });
    test('1 x 2 x 3', () {
      final iterable = [
        [1],
        [2, 3],
        [4, 5, 6],
      ].product();
      expect(iterable, [
        [1, 2, 4],
        [1, 2, 5],
        [1, 2, 6],
        [1, 3, 4],
        [1, 3, 5],
        [1, 3, 6],
      ]);
    });
    test('3 x 2 x 1', () {
      final iterable = [
        [1, 2, 3],
        [4, 5],
        [6],
      ].product();
      expect(iterable, [
        [1, 4, 6],
        [1, 5, 6],
        [2, 4, 6],
        [2, 5, 6],
        [3, 4, 6],
        [3, 5, 6],
      ]);
    });
    test('repeat 0', () {
      expect(() => <Iterable>[].product(repeat: 0), throwsRangeError);
    });
    test('2 x repeat 2', () {
      final iterable = [
        [0, 1],
      ].product(repeat: 2);
      expect(iterable, [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ]);
    });
    test('2 x 1 x repeat 2', () {
      final iterable = [
        [0, 1],
        [3],
      ].product(repeat: 2);
      expect(iterable, [
        [0, 3, 0, 3],
        [0, 3, 1, 3],
        [1, 3, 0, 3],
        [1, 3, 1, 3],
      ]);
    });
    test('2 x repeat 3', () {
      final iterable = [
        [0, 1],
      ].product(repeat: 3);
      expect(iterable, [
        [0, 0, 0],
        [0, 0, 1],
        [0, 1, 0],
        [0, 1, 1],
        [1, 0, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 1, 1],
      ]);
    });
    test('1 x 2, repeat 3', () {
      final iterable = [
        [0, 1],
      ].product(repeat: 3);
      expect(iterable, [
        [0, 0, 0],
        [0, 0, 1],
        [0, 1, 0],
        [0, 1, 1],
        [1, 0, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 1, 1],
      ]);
    });
    test('empty', () {
      expect(<Iterable<int>>[].product(), isEmpty);
      expect([[]].product(), isEmpty);
      expect(
          [
            [1],
            []
          ].product(),
          isEmpty);
      expect(
          [
            [],
            [1]
          ].product(),
          isEmpty);
      expect(
          [
            [1],
            [],
            [1]
          ].product(),
          isEmpty);
    });
  });
  group('random', () {
    test('empty', () {
      expect(() => [].atRandom(), throwsStateError);
      expect([].atRandom(orElse: () => -1), -1);
    });
    test('single', () {
      expect([1].atRandom(), 1);
      expect([2].atRandom(), 2);
      expect([3].atRandom(), 3);
    });
    test('larger', () {
      final seen = <int>{};
      final picks = 0.to(10);
      while (seen.length < picks.length) {
        seen.add(picks.atRandom());
      }
    });
    test('secure', () {
      final seen = <int>{};
      final picks = 0.to(10);
      final random = Random.secure();
      while (seen.length < picks.length) {
        seen.add(picks.atRandom(random: random));
      }
    });
  });
  group('repeat', () {
    test('empty', () {
      expect([].repeat(), []);
      expect([].repeat(count: 0), []);
      expect([].repeat(count: 1), []);
      expect([].repeat(count: 2), []);
      expect([].repeat(count: 3), []);
    });
    test('single', () {
      expect([1].repeat().take(3), [1, 1, 1]);
      expect([1].repeat(count: 0), []);
      expect([1].repeat(count: 1), [1]);
      expect([1].repeat(count: 2), [1, 1]);
      expect([1].repeat(count: 3), [1, 1, 1]);
    });
    test('double', () {
      expect([1, 2].repeat().take(5), [1, 2, 1, 2, 1]);
      expect([1, 2].repeat(count: 0), []);
      expect([1, 2].repeat(count: 1), [1, 2]);
      expect([1, 2].repeat(count: 2), [1, 2, 1, 2]);
      expect([1, 2].repeat(count: 3), [1, 2, 1, 2, 1, 2]);
    });
    test('triple', () {
      expect([1, 2, 3].repeat().take(7), [1, 2, 3, 1, 2, 3, 1]);
      expect([1, 2, 3].repeat(count: 0), []);
      expect([1, 2, 3].repeat(count: 1), [1, 2, 3]);
      expect([1, 2, 3].repeat(count: 2), [1, 2, 3, 1, 2, 3]);
      expect([1, 2, 3].repeat(count: 3), [1, 2, 3, 1, 2, 3, 1, 2, 3]);
    });
    test('infinite', () {
      final infinite = iterate<int>(0, (n) => n + 1);
      expect(infinite.repeat().take(7), [0, 1, 2, 3, 4, 5, 6]);
      expect(infinite.repeat(count: 0), []);
      expect(infinite.repeat(count: 1).take(7), [0, 1, 2, 3, 4, 5, 6]);
      expect(infinite.repeat(count: 2).take(7), [0, 1, 2, 3, 4, 5, 6]);
      expect(infinite.repeat(count: 3).take(7), [0, 1, 2, 3, 4, 5, 6]);
    });
    test('constructor', () {
      expect(repeat(1, count: 0), []);
      expect(repeat(1, count: 1), [1]);
      expect(repeat(1, count: 2), [1, 1]);
      expect(repeat(1, count: 3), [1, 1, 1]);
    });
  });
  group('separatedBy', () {
    group('without before or after', () {
      test('empty', () {
        var s = 0;
        expect([].separatedBy(() => s++), []);
        expect(s, 0);
      });
      test('single', () {
        var s = 0;
        expect([10].separatedBy(() => s++), [10]);
        expect(s, 0);
      });
      test('double', () {
        var s = 0;
        expect([10, 20].separatedBy(() => s++), [10, 0, 20]);
        expect(s, 1);
      });
      test('triple', () {
        var s = 0;
        expect([10, 20, 30].separatedBy(() => s++), [10, 0, 20, 1, 30]);
        expect(s, 2);
      });
      test('iterator', () {
        final iterator = [42].separatedBy(() => 0).iterator;
        expect(iterator.moveNext(), isTrue);
        for (var i = 0; i <= 3; i++) {
          expect(iterator.current, 42);
        }
        for (var i = 0; i <= 3; i++) {
          expect(iterator.moveNext(), isFalse);
        }
      });
    });
    group('with before', () {
      test('empty', () {
        var s = 0, b = 0;
        expect(
            [].separatedBy(
              () => s++,
              before: () => b++ + 5,
            ),
            []);
        expect(s, 0);
        expect(b, 0);
      });
      test('single', () {
        var s = 0, b = 0;
        expect(
            [10].separatedBy(
              () => s++,
              before: () => b++ + 5,
            ),
            [5, 10]);
        expect(s, 0);
        expect(b, 1);
      });
      test('double', () {
        var s = 0, b = 0;
        expect(
            [10, 20].separatedBy(
              () => s++,
              before: () => b++ + 5,
            ),
            [5, 10, 0, 20]);
        expect(s, 1);
        expect(b, 1);
      });
      test('triple', () {
        var s = 0, b = 0;
        expect(
            [10, 20, 30].separatedBy(
              () => s++,
              before: () => b++ + 5,
            ),
            [5, 10, 0, 20, 1, 30]);
        expect(s, 2);
        expect(b, 1);
      });
    });
    group('with after', () {
      test('empty', () {
        var s = 0, a = 0;
        expect(
            [].separatedBy(
              () => s++,
              after: () => a++ + 15,
            ),
            []);
        expect(s, 0);
        expect(a, 0);
      });
      test('single', () {
        var s = 0, a = 0;
        expect(
            [10].separatedBy(
              () => s++,
              after: () => a++ + 15,
            ),
            [10, 15]);
        expect(s, 0);
        expect(a, 1);
      });
      test('double', () {
        var s = 0, a = 0;
        expect(
            [10, 20].separatedBy(
              () => s++,
              after: () => a++ + 15,
            ),
            [10, 0, 20, 15]);
        expect(s, 1);
        expect(a, 1);
      });
      test('triple', () {
        var s = 0, a = 0;
        expect(
            [10, 20, 30].separatedBy(
              () => s++,
              after: () => a++ + 15,
            ),
            [10, 0, 20, 1, 30, 15]);
        expect(s, 2);
        expect(a, 1);
      });
    });
    group('with before and after', () {
      test('empty', () {
        var s = 0, b = 0, a = 0;
        expect(
            [].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            []);
        expect(s, 0);
        expect(b, 0);
        expect(a, 0);
      });
      test('single', () {
        var s = 0, b = 0, a = 0;
        expect(
            [10].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            [5, 10, 15]);
        expect(s, 0);
        expect(b, 1);
        expect(a, 1);
      });
      test('double', () {
        var s = 0, b = 0, a = 0;
        expect(
            [10, 20].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            [5, 10, 0, 20, 15]);
        expect(s, 1);
        expect(b, 1);
        expect(a, 1);
      });
      test('triple', () {
        var s = 0, b = 0, a = 0;
        expect(
            [10, 20, 30].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            [5, 10, 0, 20, 1, 30, 15]);
        expect(s, 2);
        expect(b, 1);
        expect(a, 1);
      });
    });
  });
  group('statistics', () {
    const epsilon = 1.0e-6;
    test('sum', () {
      expect([3, 2.25, 4.5, -0.5, 1.0].sum(), closeTo(10.25, epsilon));
    });
    test('sum (int)', () {
      expect([-1, 2, 3, 5, 7].sum(), 16);
    });
    test('average', () {
      expect(<num>[].average(), isNaN);
      expect([1, 2, 3, 4, 4].average(), closeTo(2.8, epsilon));
    });
    test('arithmeticMean', () {
      expect(<num>[].arithmeticMean(), isNaN);
      expect([1, 2, 3, 4, 4].arithmeticMean(), closeTo(2.8, epsilon));
    });
    test('geometricMean', () {
      expect(<num>[].geometricMean(), isNaN);
      expect([54, 24, 36].geometricMean(), closeTo(36.0, epsilon));
    });
    test('harmonicMean', () {
      expect(<num>[].harmonicMean(), isNaN);
      expect([1, -1].harmonicMean(), isNaN);
      expect([2.5, 3, 10].harmonicMean(), closeTo(3.6, epsilon));
    });
    test('variance', () {
      expect(<num>[].variance(), isNaN);
      expect([2.75].variance(), isNaN);
      expect([2.75, 1.75].variance(), closeTo(0.5, epsilon));
      expect([2.75, 1.75, 1.25, 0.25, 0.5, 1.25, 3.5].variance(),
          closeTo(1.372023809523809, epsilon));
    });
    test('populationVariance', () {
      expect(<num>[].populationVariance(), isNaN);
      expect([0.0].populationVariance(), closeTo(0.0, epsilon));
      expect(
          [0.0, 0.25, 0.25, 1.25, 1.5, 1.75, 2.75, 3.25].populationVariance(),
          closeTo(1.25, epsilon));
    });
    test('standardDeviation', () {
      expect(<num>[].standardDeviation(), isNaN);
      expect([1.5].standardDeviation(), isNaN);
      expect(
          [1.5, 2.5].standardDeviation(), closeTo(0.707106781186547, epsilon));
      expect([1.5, 2.5, 2.5, 2.75, 3.25, 4.75].standardDeviation(),
          closeTo(1.081087415521982, epsilon));
    });
    test('populationStandardDeviation', () {
      expect(<num>[].populationStandardDeviation(), isNaN);
      expect([1.5].populationStandardDeviation(), closeTo(0.0, epsilon));
      expect([1.5, 2.5, 2.5, 2.75, 3.25, 4.75].populationStandardDeviation(),
          closeTo(0.98689327352725, epsilon));
    });
  });
  group('unique', () {
    test('identity', () {
      expect([1].unique(), [1]);
      expect([1, 2].unique(), [1, 2]);
      expect([1, 2, 3].unique(), [1, 2, 3]);
    });
    test('duplicates', () {
      expect([1, 1].unique(), [1]);
      expect([1, 2, 2, 1].unique(), [1, 2]);
      expect([1, 2, 3, 3, 2, 1].unique(), [1, 2, 3]);
    });
  });
  group('window', () {
    test('error', () {
      expect(() => [1, 2, 3].window(0), throwsRangeError);
      expect(() => [1, 2, 3].window(1, step: 0), throwsRangeError);
    });
    test('size = 1', () {
      expect([].window(1), []);
      expect([1].window(1), [
        [1]
      ]);
      expect([1, 2].window(1), [
        [1],
        [2]
      ]);
      expect([1, 2, 3].window(1), [
        [1],
        [2],
        [3]
      ]);
      expect([1, 2, 3, 4].window(1), [
        [1],
        [2],
        [3],
        [4]
      ]);
    });
    test('size = 2', () {
      expect([].window(2), []);
      expect([1].window(2), []);
      expect([1, 2].window(2), [
        [1, 2]
      ]);
      expect([1, 2, 3].window(2), [
        [1, 2],
        [2, 3]
      ]);
      expect([1, 2, 3, 4].window(2), [
        [1, 2],
        [2, 3],
        [3, 4]
      ]);
    });
    test('size = 2, step = 2', () {
      expect([].window(2, step: 2), []);
      expect([1].window(2, step: 2), []);
      expect([1, 2].window(2, step: 2), [
        [1, 2]
      ]);
      expect([1, 2, 3].window(2, step: 2), [
        [1, 2]
      ]);
      expect([1, 2, 3, 4].window(2, step: 2), [
        [1, 2],
        [3, 4]
      ]);
    });
    test('size = 2, step = 3', () {
      expect([].window(2, step: 3), []);
      expect([1].window(2, step: 3), []);
      expect([1, 2].window(2, step: 3), [
        [1, 2]
      ]);
      expect([1, 2, 3].window(2, step: 3), [
        [1, 2]
      ]);
      expect([1, 2, 3, 4].window(2, step: 3), [
        [1, 2]
      ]);
    });
    test('size = 2, includePartial', () {
      expect([].window(2, includePartial: true), []);
      expect([1].window(2, includePartial: true), [
        [1]
      ]);
      expect([1, 2].window(2, includePartial: true), [
        [1, 2],
        [2]
      ]);
      expect([1, 2, 3].window(2, includePartial: true), [
        [1, 2],
        [2, 3],
        [3]
      ]);
      expect([1, 2, 3, 4].window(2, includePartial: true), [
        [1, 2],
        [2, 3],
        [3, 4],
        [4]
      ]);
    });
    test('size = 2, step = 2, includePartial', () {
      expect([].window(2, step: 2, includePartial: true), []);
      expect([1].window(2, step: 2, includePartial: true), [
        [1]
      ]);
      expect([1, 2].window(2, step: 2, includePartial: true), [
        [1, 2]
      ]);
      expect([1, 2, 3].window(2, step: 2, includePartial: true), [
        [1, 2],
        [3]
      ]);
      expect([1, 2, 3, 4].window(2, step: 2, includePartial: true), [
        [1, 2],
        [3, 4]
      ]);
    });
    test('size = 2, step = 3, includePartial', () {
      expect([].window(2, step: 3, includePartial: true), []);
      expect([1].window(2, step: 3, includePartial: true), [
        [1]
      ]);
      expect([1, 2].window(2, step: 3, includePartial: true), [
        [1, 2]
      ]);
      expect([1, 2, 3].window(2, step: 3, includePartial: true), [
        [1, 2]
      ]);
      expect([1, 2, 3, 4].window(2, step: 3, includePartial: true), [
        [1, 2],
        [4]
      ]);
    });
  });
  group('zip', () {
    group('default', () {
      test('empty', () {
        expect(<Iterable<int>>[].zip(), <int>[]);
      });
      test('single', () {
        expect(
            [
              [1, 2, 3]
            ].zip(),
            [
              [1],
              [2],
              [3]
            ]);
      });
      test('pair', () {
        expect(
            [
              [1, 2, 3],
              ['a', 'b', 'c'],
            ].zip(),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 'c'],
            ]);
        expect(
            [
              [1, 2],
              ['a', 'b', 'c'],
            ].zip(),
            [
              [1, 'a'],
              [2, 'b'],
            ]);
        expect(
            [
              [1, 2, 3],
              ['a', 'b'],
            ].zip(),
            [
              [1, 'a'],
              [2, 'b'],
            ]);
      });
    });
    group('partial', () {
      test('empty', () {
        expect(<Iterable<int>>[].zipPartial(), <int>[]);
      });
      test('single', () {
        expect(
            [
              [1, 2, 3]
            ].zipPartial(),
            [
              [1],
              [2],
              [3]
            ]);
      });
      test('pair', () {
        expect(
            [
              [1, 2, 3],
              ['a', 'b', 'c'],
            ].zipPartial(),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 'c'],
            ]);
        expect(
            [
              [1, 2],
              ['a', 'b', 'c'],
            ].zipPartial(),
            [
              [1, 'a'],
              [2, 'b'],
              [null, 'c'],
            ]);
        expect(
            [
              [1, 2, 3],
              ['a', 'b'],
            ].zipPartial(),
            [
              [1, 'a'],
              [2, 'b'],
              [3, null],
            ]);
      });
    });
    group('partial with', () {
      test('empty', () {
        expect(<Iterable<int>>[].zipPartialWith(0), <int>[]);
      });
      test('single', () {
        expect(
            [
              [1, 2, 3]
            ].zipPartialWith(0),
            [
              [1],
              [2],
              [3]
            ]);
      });
      test('pair', () {
        expect(
            [
              [1, 2, 3],
              ['a', 'b', 'c'],
            ].zipPartialWith(0),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 'c'],
            ]);
        expect(
            [
              [1, 2],
              ['a', 'b', 'c'],
            ].zipPartialWith(0),
            [
              [1, 'a'],
              [2, 'b'],
              [0, 'c'],
            ]);
        expect(
            [
              [1, 2, 3],
              ['a', 'b'],
            ].zipPartialWith(0),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 0],
            ]);
      });
    });
  });
}
