library more.test.iterable_test;

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
        final iterable = <int>[].chunkedWithPadding(2, padding: 0);
        expect(iterable, <int>[]);
      });
      test('even', () {
        final iterable = [1, 2, 3, 4].chunkedWithPadding(2, padding: 0);
        expect(iterable, [
          [1, 2],
          [3, 4]
        ]);
      });
      test('odd', () {
        final iterable = [1, 2, 3, 4, 5].chunkedWithPadding(2, padding: 0);
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
  group('concat', () {
    final a = [1, 2, 3], b = [4, 5], c = [6], d = [];
    test('void', () {
      expect([[]].concat(), []);
    });
    test('basic', () {
      expect([a].concat(), [1, 2, 3]);
      expect([a, b].concat(), [1, 2, 3, 4, 5]);
      expect([b, a].concat(), [4, 5, 1, 2, 3]);
      expect([a, b, c].concat(), [1, 2, 3, 4, 5, 6]);
      expect([a, c, b].concat(), [1, 2, 3, 6, 4, 5]);
      expect([b, a, c].concat(), [4, 5, 1, 2, 3, 6]);
      expect([b, c, a].concat(), [4, 5, 6, 1, 2, 3]);
      expect([c, a, b].concat(), [6, 1, 2, 3, 4, 5]);
      expect([c, b, a].concat(), [6, 4, 5, 1, 2, 3]);
    });
    test('empty', () {
      expect([a, b, c, d].concat(), [1, 2, 3, 4, 5, 6]);
      expect([a, b, d, c].concat(), [1, 2, 3, 4, 5, 6]);
      expect([a, d, b, c].concat(), [1, 2, 3, 4, 5, 6]);
      expect([d, a, b, c].concat(), [1, 2, 3, 4, 5, 6]);
    });
    test('repeated', () {
      expect([a, a].concat(), [1, 2, 3, 1, 2, 3]);
      expect([b, b, b].concat(), [4, 5, 4, 5, 4, 5]);
      expect([c, c, c, c].concat(), [6, 6, 6, 6]);
      expect([d, d, d, d, d].concat(), []);
    });
    test('types', () {
      expect([Set.of(c)].concat(), [6]);
      expect([List.of(b)].concat(), [4, 5]);
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
      final iterable = iterate(0, (a) => a + 1);
      expect(iterable.take(10), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('powers of two', () {
      final iterable = iterate<int>(1, (a) => 2 * a);
      expect(iterable.take(10), [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]);
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
        expect(() => date.periodical(step: null), throwsArgumentError);
        expect(() => date.periodical(step: 0), throwsArgumentError);
      });
      test('invalid period', () {
        expect(() => date.periodical(period: null), throwsArgumentError);
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
      test('invalid period', () {
        expect(() => date.truncate(period: null), throwsArgumentError);
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
  group('repeat', () {
    test('finite', () {
      expect(repeat(0, count: 0), []);
      expect(repeat(0, count: 1), [0]);
      expect(repeat(0, count: 2), [0, 0]);
      expect(repeat(0, count: 3), [0, 0, 0]);
      expect(repeat(0, count: 4), [0, 0, 0, 0]);
    });
    test('infinite', () {
      final infinite = repeat(1);
      expect(infinite.take(100).every((x) => x == 1), isTrue);
      expect(() => infinite.length, throwsUnsupportedError);
    });
  });
  group('unqiue', () {
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
    test('empty', () {
      expect(<Iterable>[].zip(), []);
    });
    test('empty, includePartial', () {
      expect(<Iterable>[].zip(includePartial: true), []);
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
    test('single, includePartial', () {
      expect(
          [
            [1, 2, 3]
          ].zip(includePartial: true),
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
    test('pair, includePartial', () {
      expect(
          [
            [1, 2, 3],
            ['a', 'b', 'c'],
          ].zip(includePartial: true),
          [
            [1, 'a'],
            [2, 'b'],
            [3, 'c'],
          ]);
      expect(
          [
            [1, 2],
            ['a', 'b', 'c'],
          ].zip(includePartial: true),
          [
            [1, 'a'],
            [2, 'b'],
            [null, 'c'],
          ]);
      expect(
          [
            [1, 2, 3],
            ['a', 'b'],
          ].zip(includePartial: true),
          [
            [1, 'a'],
            [2, 'b'],
            [3, null],
          ]);
    });
  });
}
