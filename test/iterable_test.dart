library more.test.iterable_test;

import 'package:more/collection.dart';
import 'package:more/iterable.dart';
import 'package:test/test.dart';

void main() {
  String joiner(Iterable<String> iterable) => iterable.join();

  group('chunked', () {
    test('empty', () {
      final iterable = chunked(<int>[], 2);
      expect(iterable, <int>[]);
    });
    test('even', () {
      final iterable = chunked([1, 2, 3, 4], 2);
      expect(iterable, [
        [1, 2],
        [3, 4]
      ]);
    });
    test('odd', () {
      final iterable = chunked([1, 2, 3, 4, 5], 2);
      expect(iterable, [
        [1, 2],
        [3, 4],
        [5]
      ]);
    });
    group('with padding', () {
      test('empty', () {
        final iterable = chunkedWithPadding(<int>[], 2, 0);
        expect(iterable, <int>[]);
      });
      test('even', () {
        final iterable = chunkedWithPadding([1, 2, 3, 4], 2, 0);
        expect(iterable, [
          [1, 2],
          [3, 4]
        ]);
      });
      test('odd', () {
        final iterable = chunkedWithPadding([1, 2, 3, 4, 5], 2, 0);
        expect(iterable, [
          [1, 2],
          [3, 4],
          [5, 0]
        ]);
      });
    });
  });
  group('combinations', () {
    final letters = string('abcd');
    group('with repetitions', () {
      test('take 0', () {
        final iterable = combinations(letters, 0, repetitions: true);
        expect(iterable, isEmpty);
      });
      test('take 1', () {
        final iterable = combinations(letters, 1, repetitions: true);
        expect(iterable, [
          ['a'],
          ['b'],
          ['c'],
          ['d']
        ]);
      });
      test('take 2', () {
        final iterable = combinations(letters, 2, repetitions: true);
        expect(iterable.map(joiner),
            ['aa', 'ab', 'ac', 'ad', 'bb', 'bc', 'bd', 'cc', 'cd', 'dd']);
      });
      test('take 3', () {
        final iterable = combinations(letters, 3, repetitions: true);
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
        final iterable = combinations(letters, 4, repetitions: true);
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
        final iterable = combinations(letters, 5, repetitions: true);
        expect(iterable.first.join(), 'aaaaa');
        expect(iterable.last.join(), 'ddddd');
        expect(iterable.length, 56);
      });
      test('take 6', () {
        final iterable = combinations(letters, 6, repetitions: true);
        expect(iterable.first.join(), 'aaaaaa');
        expect(iterable.last.join(), 'dddddd');
        expect(iterable.length, 84);
      });
    });
    group('without repetions', () {
      test('take 0', () {
        final iterable = combinations(letters, 0, repetitions: false);
        expect(iterable, isEmpty);
      });
      test('take 1', () {
        final iterable = combinations(letters, 1, repetitions: false);
        expect(iterable, [
          ['a'],
          ['b'],
          ['c'],
          ['d']
        ]);
      });
      test('take 2', () {
        final iterable = combinations(letters, 2, repetitions: false);
        expect(iterable.map(joiner), ['ab', 'ac', 'ad', 'bc', 'bd', 'cd']);
      });
      test('take 3', () {
        final iterable = combinations(letters, 3, repetitions: false);
        expect(iterable.map(joiner), ['abc', 'abd', 'acd', 'bcd']);
      });
      test('take 4', () {
        final iterable = combinations(letters, 4, repetitions: false);
        expect(iterable.map(joiner), ['abcd']);
      });
    });
    test('range error', () {
      expect(() => combinations(letters, -1), throwsRangeError);
      expect(
          () => combinations(letters, -1, repetitions: true), throwsRangeError);
      expect(() => combinations(letters, -1, repetitions: false),
          throwsRangeError);
      expect(
          () => combinations(letters, 5, repetitions: false), throwsRangeError);
    });
  });
  group('concat', () {
    final a = [1, 2, 3], b = [4, 5], c = [6], d = [];
    test('void', () {
      expect(concat([]), []);
    });
    test('basic', () {
      expect(concat([a]), [1, 2, 3]);
      expect(concat([a, b]), [1, 2, 3, 4, 5]);
      expect(concat([b, a]), [4, 5, 1, 2, 3]);
      expect(concat([a, b, c]), [1, 2, 3, 4, 5, 6]);
      expect(concat([a, c, b]), [1, 2, 3, 6, 4, 5]);
      expect(concat([b, a, c]), [4, 5, 1, 2, 3, 6]);
      expect(concat([b, c, a]), [4, 5, 6, 1, 2, 3]);
      expect(concat([c, a, b]), [6, 1, 2, 3, 4, 5]);
      expect(concat([c, b, a]), [6, 4, 5, 1, 2, 3]);
    });
    test('empty', () {
      expect(concat([a, b, c, d]), [1, 2, 3, 4, 5, 6]);
      expect(concat([a, b, d, c]), [1, 2, 3, 4, 5, 6]);
      expect(concat([a, d, b, c]), [1, 2, 3, 4, 5, 6]);
      expect(concat([d, a, b, c]), [1, 2, 3, 4, 5, 6]);
    });
    test('repeated', () {
      expect(concat([a, a]), [1, 2, 3, 1, 2, 3]);
      expect(concat([b, b, b]), [4, 5, 4, 5, 4, 5]);
      expect(concat([c, c, c, c]), [6, 6, 6, 6]);
      expect(concat([d, d, d, d, d]), []);
    });
    test('types', () {
      expect(concat([Set.of(c)]), [6]);
      expect(concat([List.of(b)]), [4, 5]);
    });
  });
  group('cycle', () {
    test('empty', () {
      expect(cycle([]), isEmpty);
      expect(cycle([], 5), isEmpty);
      expect(cycle([1, 2], 0), isEmpty);
    });
    test('fixed', () {
      expect(cycle([1, 2], 1), [1, 2]);
      expect(cycle([1, 2], 2), [1, 2, 1, 2]);
      expect(cycle([1, 2], 3), [1, 2, 1, 2, 1, 2]);
    });
    test('infinite', () {
      expect(cycle([1, 2]).isEmpty, isFalse);
      expect(cycle([1, 2]).isNotEmpty, isTrue);
      expect(cycle([1, 2]).take(3), [1, 2, 1]);
      expect(cycle([1, 2]).skip(3).take(3), [2, 1, 2]);
    });
    test('invalid', () {
      expect(() => cycle([1, 2], -1), throwsArgumentError);
    });
    test('infinite', () {
      expect(cycle([1, 2]).isEmpty, isFalse);
      expect(cycle([1, 2]).isNotEmpty, isTrue);
      expect(() => cycle([1, 2]).length, throwsUnsupportedError);
      expect(() => cycle([1, 2]).last, throwsUnsupportedError);
      expect(
          () => cycle([1, 2]).lastWhere((e) => false), throwsUnsupportedError);
      expect(() => cycle([1, 2]).single, throwsUnsupportedError);
      expect(() => cycle([1, 2]).singleWhere((e) => false),
          throwsUnsupportedError);
      expect(() => cycle([1, 2]).toList(), throwsUnsupportedError);
      expect(() => cycle([1, 2]).toSet(), throwsUnsupportedError);
    });
  });
  group('groupBy', () {
    final example = string('aaaabbbccdaabbb');
    test('groupBy empty', () {
      final iterable = groupBy([]);
      expect(iterable, []);
    });
    test('groupBy basic', () {
      final iterable = groupBy(example);
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
      final iterable = groupBy(example.reversed, (key) => key.codeUnitAt(0));
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
      final iterable = indexed([]);
      expect(iterable, []);
    });
    test('simple', () {
      final iterable = indexed(['a', 'b', 'c']);
      expect(iterable.map((each) => each.index), [0, 1, 2]);
      expect(iterable.map((each) => each.value), ['a', 'b', 'c']);
    });
    test('offset', () {
      final actual = indexed(['a', 'b'], offset: 1)
          .map((each) => '${each.value}-${each.index}')
          .join(', ');
      const expected = 'a-1, b-2';
      expect(actual, expected);
    });
  });
  group('fold', () {
    test('single value toggle', () {
      final iterable = fold([1], (e) => -e[0]);
      expect(iterable.take(10), [1, -1, 1, -1, 1, -1, 1, -1, 1, -1]);
    });
    test('fibonacci sequence', () {
      final iterable = fold([0, 1], (e) => e[0] + e[1]);
      expect(iterable.take(10), [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]);
    });
    test('extended fibonacci sequence', () {
      final iterable = fold([0, 0, 1], (e) => e[0] + e[1] + e[2]);
      expect(iterable.take(10), [0, 0, 1, 1, 2, 4, 7, 13, 24, 44]);
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
  group('math', () {
    test('fibonacci', () {
      expect(fibonacci(0, 1).take(8), [0, 1, 1, 2, 3, 5, 8, 13]);
      expect(fibonacci(1, 1).take(8), [1, 1, 2, 3, 5, 8, 13, 21]);
      expect(fibonacci(1, 0).take(8), [1, 0, 1, 1, 2, 3, 5, 8]);
    });
    test('digits', () {
      expect(digits(0).toList(), [0]);
      expect(digits(1).toList(), [1]);
      expect(digits(12).toList(), [2, 1]);
      expect(digits(123).toList(), [3, 2, 1]);
      expect(digits(1001).toList(), [1, 0, 0, 1]);
      expect(digits(10001).toList(), [1, 0, 0, 0, 1]);
      expect(digits(1000).toList(), [0, 0, 0, 1]);
      expect(digits(10000).toList(), [0, 0, 0, 0, 1]);
    });
    test('digits (base 2)', () {
      expect(digits(0, 2).toList(), [0]);
      expect(digits(1, 2).toList(), [1]);
      expect(digits(12, 2).toList(), [0, 0, 1, 1]);
      expect(digits(123, 2).toList(), [1, 1, 0, 1, 1, 1, 1]);
      expect(digits(1001, 2).toList(), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10001, 2).toList(),
          [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      expect(digits(1000, 2).toList(), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10000, 2).toList(),
          [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
    });
    test('digits (base 16)', () {
      expect(digits(0, 16).toList(), [0]);
      expect(digits(1, 16).toList(), [1]);
      expect(digits(12, 16).toList(), [12]);
      expect(digits(123, 16).toList(), [11, 7]);
      expect(digits(1001, 16).toList(), [9, 14, 3]);
      expect(digits(10001, 16).toList(), [1, 1, 7, 2]);
      expect(digits(1000, 16).toList(), [8, 14, 3]);
      expect(digits(10000, 16).toList(), [0, 1, 7, 2]);
    });
  });
  group('permutations', () {
    test('0', () {
      final iterator = permutations(string(''));
      expect(iterator, []);
    });
    test('1', () {
      final iterator = permutations(string('a'));
      expect(iterator, [
        ['a']
      ]);
    });
    test('2', () {
      final iterator = permutations(string('ab'));
      expect(iterator, [
        ['a', 'b'],
        ['b', 'a']
      ]);
    });
    test('3', () {
      final iterator = permutations(string('abc'));
      expect(iterator.map(joiner), ['abc', 'acb', 'bac', 'bca', 'cab', 'cba']);
    });
    test('4', () {
      final iterator = permutations(string('abcd'));
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
        final iterable = periodical(start: date, period: Period.millennially);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(3980, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('centennially', () {
        final iterable = periodical(start: date, period: Period.centennially);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2080, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2180, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('decennially', () {
        final iterable = periodical(start: date, period: Period.decennially);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1990, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(2000, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('yearly', () {
        final iterable = periodical(start: date, period: Period.yearly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1981, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1982, DateTime.june, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('quarterly', () {
        final iterable = periodical(start: date, period: Period.quarterly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.september, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.december, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('monthly', () {
        final iterable = periodical(start: date, period: Period.monthly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.july, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.august, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('weekly', () {
        final iterable = periodical(start: date, period: Period.weekly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 18, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 25, 12, 34, 56, 78, 90),
        ]);
      });
      test('daily', () {
        final iterable = periodical(start: date, period: Period.daily);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 12, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 13, 12, 34, 56, 78, 90),
        ]);
      });
      test('hourly', () {
        final iterable = periodical(start: date, period: Period.hourly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 13, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 14, 34, 56, 78, 90),
        ]);
      });
      test('minutely', () {
        final iterable = periodical(start: date, period: Period.minutely);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 35, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 36, 56, 78, 90),
        ]);
      });
      test('secondly', () {
        final iterable = periodical(start: date, period: Period.secondly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 57, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 58, 78, 90),
        ]);
      });
      test('millisecondly', () {
        final iterable = periodical(start: date, period: Period.millisecondly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 79, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 80, 90),
        ]);
      });
      test('microsecondly', () {
        final iterable = periodical(start: date, period: Period.microsecondly);
        expect(iterable.take(3), [
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 91),
          DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 92),
        ]);
      });
      test('start default', () {
        final first = periodical().first;
        final difference = first.difference(DateTime.now());
        expect(difference.inSeconds, lessThan(1));
      });
      test('invalid step', () {
        expect(() => periodical(step: null), throwsArgumentError);
        expect(() => periodical(step: 0), throwsArgumentError);
      });
      test('invalid period', () {
        expect(() => periodical(period: null), throwsArgumentError);
      });
    });
    group('truncateToPeriod', () {
      test('millennially', () {
        final truncated = truncateToPeriod(date, period: Period.millennially);
        expect(truncated, DateTime(1000));
      });
      test('centennially', () {
        final truncated = truncateToPeriod(date, period: Period.centennially);
        expect(truncated, DateTime(1900));
      });
      test('decennially', () {
        final truncated = truncateToPeriod(date, period: Period.decennially);
        expect(truncated, DateTime(1980));
      });
      test('yearly', () {
        final truncated = truncateToPeriod(date, period: Period.yearly);
        expect(truncated, DateTime(1980));
      });
      test('quarterly', () {
        final truncated = truncateToPeriod(date, period: Period.quarterly);
        expect(truncated, DateTime(1980, DateTime.april));
      });
      test('monthly', () {
        final truncated = truncateToPeriod(date, period: Period.monthly);
        expect(truncated, DateTime(1980, DateTime.june));
      });
      test('weekly', () {
        final truncated = truncateToPeriod(date, period: Period.weekly);
        expect(truncated, DateTime(1980, DateTime.june, 9));
      });
      test('weekly (custom start of the week)', () {
        for (var weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++) {
          final truncated = truncateToPeriod(date,
              period: Period.weekly, startWeekday: weekday);
          expect(truncated.isBefore(date), isTrue);
          expect(truncated.weekday, weekday);
        }
      });
      test('daily', () {
        final truncated = truncateToPeriod(date, period: Period.daily);
        expect(truncated, DateTime(1980, DateTime.june, 11));
      });
      test('hourly', () {
        final truncated = truncateToPeriod(date, period: Period.hourly);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12));
      });
      test('minutely', () {
        final truncated = truncateToPeriod(date, period: Period.minutely);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34));
      });
      test('secondly', () {
        final truncated = truncateToPeriod(date, period: Period.secondly);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56));
      });
      test('millisecondly', () {
        final truncated = truncateToPeriod(date, period: Period.millisecondly);
        expect(truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78));
      });
      test('microsecondly', () {
        final truncated = truncateToPeriod(date, period: Period.microsecondly);
        expect(
            truncated, DateTime(1980, DateTime.june, 11, 12, 34, 56, 78, 90));
      });
      test('invalid timestamp', () {
        expect(() => truncateToPeriod(null), throwsArgumentError);
      });
      test('invalid period', () {
        expect(() => truncateToPeriod(date, period: null), throwsArgumentError);
      });
      test('invalid start weekday', () {
        expect(
            () => truncateToPeriod(date,
                period: Period.weekly, startWeekday: DateTime.monday - 1),
            throwsArgumentError);
        expect(
            () => truncateToPeriod(date,
                period: Period.weekly, startWeekday: DateTime.sunday + 1),
            throwsArgumentError);
      });
    });
  });
  group('product', () {
    test('2', () {
      final iterable = product([
        [1, 2],
      ]);
      expect(iterable, [
        [1],
        [2],
      ]);
    });
    test('2 x 2', () {
      final iterable = product([
        [1, 2],
        [3, 4],
      ]);
      expect(iterable, [
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4],
      ]);
    });
    test('1 x 2 x 3', () {
      final iterable = product([
        [1],
        [2, 3],
        [4, 5, 6],
      ]);
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
      final iterable = product([
        [1, 2, 3],
        [4, 5],
        [6],
      ]);
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
      expect(() => product([], repeat: 0), throwsRangeError);
    });
    test('2 x repeat 2', () {
      final iterable = product([
        [0, 1],
      ], repeat: 2);
      expect(iterable, [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ]);
    });
    test('2 x 1 x repeat 2', () {
      final iterable = product([
        [0, 1],
        [3],
      ], repeat: 2);
      expect(iterable, [
        [0, 3, 0, 3],
        [0, 3, 1, 3],
        [1, 3, 0, 3],
        [1, 3, 1, 3],
      ]);
    });
    test('2 x repeat 3', () {
      final iterable = product([
        [0, 1],
      ], repeat: 3);
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
      final iterable = product([
        [0, 1],
      ], repeat: 3);
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
      expect(product([]), isEmpty);
      expect(product([[]]), isEmpty);
      expect(
          product([
            [1],
            []
          ]),
          isEmpty);
      expect(
          product([
            [],
            [1]
          ]),
          isEmpty);
      expect(
          product([
            [1],
            [],
            [1]
          ]),
          isEmpty);
    });
  });
  group('repeat', () {
    test('finite', () {
      expect(repeat(0, 0), []);
      expect(repeat(0, 1), [0]);
      expect(repeat(0, 2), [0, 0]);
      expect(repeat(0, 3), [0, 0, 0]);
      expect(repeat(0, 4), [0, 0, 0, 0]);
    });
    test('infinite', () {
      final infinite = repeat(1);
      expect(infinite.take(100).every((x) => x == 1), isTrue);
      expect(() => infinite.length, throwsUnsupportedError);
    });
  });
  group('unqiue', () {
    test('identity', () {
      expect(unique([1]), [1]);
      expect(unique([1, 2]), [1, 2]);
      expect(unique([1, 2, 3]), [1, 2, 3]);
    });
    test('duplicates', () {
      expect(unique([1, 1]), [1]);
      expect(unique([1, 2, 2, 1]), [1, 2]);
      expect(unique([1, 2, 3, 3, 2, 1]), [1, 2, 3]);
    });
  });
  group('window', () {
    test('0', () {
      expect(() => window([1], 0), throwsRangeError);
    });
    test('1', () {
      expect(() => window([], 1), throwsRangeError);
      expect(window([1], 1), [
        [1],
      ]);
      expect(window([1, 2], 1), [
        [1],
        [2],
      ]);
      expect(window([1, 2, 3], 1), [
        [1],
        [2],
        [3],
      ]);
    });
    test('2', () {
      expect(() => window([1], 2), throwsRangeError);
      expect(window([1, 2], 2), [
        [1, 2],
      ]);
      expect(window([1, 2, 3], 2), [
        [1, 2],
        [2, 3],
      ]);
      expect(window([1, 2, 3, 4], 2), [
        [1, 2],
        [2, 3],
        [3, 4],
      ]);
    });
    test('3', () {
      expect(() => window([1, 2], 3), throwsRangeError);
      expect(window([1, 2, 3], 3), [
        [1, 2, 3],
      ]);
      expect(window([1, 2, 3, 4], 3), [
        [1, 2, 3],
        [2, 3, 4]
      ]);
      expect(window([1, 2, 3, 4, 5], 3), [
        [1, 2, 3],
        [2, 3, 4],
        [3, 4, 5],
      ]);
    });
    test('4', () {
      expect(() => window([1, 2, 3], 4), throwsRangeError);
      expect(window([1, 2, 3, 4], 4), [
        [1, 2, 3, 4],
      ]);
      expect(window([1, 2, 3, 4, 5], 4), [
        [1, 2, 3, 4],
        [2, 3, 4, 5],
      ]);
      expect(window([1, 2, 3, 4, 5, 6], 4), [
        [1, 2, 3, 4],
        [2, 3, 4, 5],
        [3, 4, 5, 6],
      ]);
    });
  });
  group('zip', () {
    test('empty', () {
      expect(zip([]), []);
    });
    test('empty, includeIncomplete', () {
      expect(zip([], includeIncomplete: true), []);
    });
    test('single', () {
      expect(
          zip([
            [1, 2, 3]
          ]),
          [
            [1],
            [2],
            [3]
          ]);
    });
    test('single, includeIncomplete', () {
      expect(
          zip([
            [1, 2, 3]
          ], includeIncomplete: true),
          [
            [1],
            [2],
            [3]
          ]);
    });
    test('pair', () {
      expect(
          zip([
            [1, 2, 3],
            ['a', 'b', 'c'],
          ]),
          [
            [1, 'a'],
            [2, 'b'],
            [3, 'c'],
          ]);
      expect(
          zip([
            [1, 2],
            ['a', 'b', 'c'],
          ]),
          [
            [1, 'a'],
            [2, 'b'],
          ]);
      expect(
          zip([
            [1, 2, 3],
            ['a', 'b'],
          ]),
          [
            [1, 'a'],
            [2, 'b'],
          ]);
    });
    test('pair, includeIncomplete', () {
      expect(
          zip([
            [1, 2, 3],
            ['a', 'b', 'c'],
          ], includeIncomplete: true),
          [
            [1, 'a'],
            [2, 'b'],
            [3, 'c'],
          ]);
      expect(
          zip([
            [1, 2],
            ['a', 'b', 'c'],
          ], includeIncomplete: true),
          [
            [1, 'a'],
            [2, 'b'],
            [null, 'c'],
          ]);
      expect(
          zip([
            [1, 2, 3],
            ['a', 'b'],
          ], includeIncomplete: true),
          [
            [1, 'a'],
            [2, 'b'],
            [3, null],
          ]);
    });
  });
}
