library more.test.iterable_test;

import 'package:more/collection.dart';
import 'package:more/iterable.dart';
import 'package:test/test.dart';

void main() {
  String joiner(Iterable<String> iterable) => iterable.join();
  group('combinations', () {
    var letters = string('abcd');
    group('with repetitions', () {
      test('take 0', () {
        var iterable = combinations(letters, 0, repetitions: true);
        expect(iterable, isEmpty);
      });
      test('take 1', () {
        var iterable =
            combinations(letters, 1, repetitions: true).map((iterable) => iterable.join());
        expect(iterable, ['a', 'b', 'c', 'd']);
      });
      test('take 2', () {
        var iterable = combinations(letters, 2, repetitions: true);
        expect(iterable.map(joiner), ['aa', 'ab', 'ac', 'ad', 'bb', 'bc', 'bd', 'cc', 'cd', 'dd']);
      });
      test('take 3', () {
        var iterable = combinations(letters, 3, repetitions: true);
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
        var iterable = combinations(letters, 4, repetitions: true);
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
        var iterable = combinations(letters, 5, repetitions: true);
        expect(iterable.first.join(), 'aaaaa');
        expect(iterable.last.join(), 'ddddd');
        expect(iterable.length, 56);
      });
      test('take 6', () {
        var iterable = combinations(letters, 6, repetitions: true);
        expect(iterable.first.join(), 'aaaaaa');
        expect(iterable.last.join(), 'dddddd');
        expect(iterable.length, 84);
      });
    });
    group('without repetions', () {
      test('take 0', () {
        var iterable = combinations(letters, 0, repetitions: false);
        expect(iterable, isEmpty);
      });
      test('take 1', () {
        var iterable = combinations(letters, 1, repetitions: false);
        expect(iterable.map(joiner), ['a', 'b', 'c', 'd']);
      });
      test('take 2', () {
        var iterable = combinations(letters, 2, repetitions: false);
        expect(iterable.map(joiner), ['ab', 'ac', 'ad', 'bc', 'bd', 'cd']);
      });
      test('take 3', () {
        var iterable = combinations(letters, 3, repetitions: false);
        expect(iterable.map(joiner), ['abc', 'abd', 'acd', 'bcd']);
      });
      test('take 4', () {
        var iterable = combinations(letters, 4, repetitions: false);
        expect(iterable.map(joiner), ['abcd']);
      });
    });
    test('range error', () {
      expect(() => combinations(letters, -1), throwsRangeError);
      expect(() => combinations(letters, -1, repetitions: true), throwsRangeError);
      expect(() => combinations(letters, -1, repetitions: false), throwsRangeError);
      expect(() => combinations(letters, 5, repetitions: false), throwsRangeError);
    });
  });
  group('concat', () {
    var a = [1, 2, 3], b = [4, 5], c = [6], d = [];
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
      expect(concat([new Set.from(c)]), [6]);
      expect(concat([new List.from(b)]), [4, 5]);
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
      expect(() => cycle([1, 2]).lastWhere((e) => false), throwsUnsupportedError);
      expect(() => cycle([1, 2]).single, throwsUnsupportedError);
      expect(() => cycle([1, 2]).singleWhere((e) => false), throwsUnsupportedError);
      expect(() => cycle([1, 2]).toList(), throwsUnsupportedError);
      expect(() => cycle([1, 2]).toSet(), throwsUnsupportedError);
    });
  });
  group('empty (deprecated)', () {
    test('empty', () {
      expect(empty().isEmpty, isTrue);
    });
    test('emptyIterable', () {
      expect(emptyIterable().isEmpty, isTrue);
    });
    test('emptyIterator', () {
      expect(emptyIterator().moveNext(), isFalse);
      expect(emptyIterator().current, isNull);
    });
  });
  group('indexed', () {
    test('empty', () {
      var iterable = indexed(const Iterable.empty());
      expect(iterable, []);
    });
    test('simple', () {
      var iterable = indexed(['a', 'b', 'c']);
      expect(iterable.map((each) => each.index), [0, 1, 2]);
      expect(iterable.map((each) => each.value), ['a', 'b', 'c']);
      expect(iterable.map((each) => each.toString()), ['0: a', '1: b', '2: c']);
    });
    test('offset', () {
      var iterable = indexed(['a', 'b', 'c']);
      expect(iterable.map((each) => each.index), [0, 1, 2]);
      expect(iterable.map((each) => each.value), ['a', 'b', 'c']);
      expect(iterable.map((each) => each.toString()), ['0: a', '1: b', '2: c']);
    });
    test('example', () {
      var actual =
          indexed(['a', 'b'], offset: 1).map((each) => '${each.value}-${each.index}').join(', ');
      var expected = 'a-1, b-2';
      expect(actual, expected);
    });
    test('reversed', () {
      var iterable =
          indexed(indexed(['a', 'b', 'c']).map((each) => each.toString()).toList().reversed)
              .map((each) => each.toString())
              .toList();
      expect(iterable, ['0: 2: c', '1: 1: b', '2: 0: a']);
    });
  });
  group('fold', () {
    test('single value toggle', () {
      var iterable = fold([1], (e) => -e[0]);
      expect(iterable.take(10), [1, -1, 1, -1, 1, -1, 1, -1, 1, -1]);
    });
    test('fibonacci sequence', () {
      var iterable = fold([0, 1], (e) => e[0] + e[1]);
      expect(iterable.take(10), [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]);
    });
    test('extended fibonacci sequence', () {
      var iterable = fold([0, 0, 1], (e) => e[0] + e[1] + e[2]);
      expect(iterable.take(10), [0, 0, 1, 1, 2, 4, 7, 13, 24, 44]);
    });
  });
  group('iterate', () {
    test('natural numbers', () {
      var iterable = iterate(0, (a) => a + 1);
      expect(iterable.take(10), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('powers of two', () {
      var iterable = iterate(1, (a) => 2 * a);
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
      expect(digits(10001, 2).toList(), [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      expect(digits(1000, 2).toList(), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10000, 2).toList(), [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
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
      var iterator = permutations(string(''));
      expect(iterator.map(joiner), []);
    });
    test('1', () {
      var iterator = permutations(string('a'));
      expect(iterator.map(joiner), ['a']);
    });
    test('2', () {
      var iterator = permutations(string('ab'));
      expect(iterator.map(joiner), ['ab', 'ba']);
    });
    test('3', () {
      var iterator = permutations(string('abc'));
      expect(iterator.map(joiner), ['abc', 'acb', 'bac', 'bca', 'cab', 'cba']);
    });
    test('4', () {
      var iterator = permutations(string('abcd'));
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
  group('partition', () {
    test('empty', () {
      var iterable = partition([], 2);
      expect(iterable, []);
    });
    test('empty with padding', () {
      var iterable = partition([], 2, 0);
      expect(iterable, []);
    });
    test('even', () {
      var iterable = partition([1, 2, 3, 4], 2);
      expect(iterable, [
        [1, 2],
        [3, 4]
      ]);
    });
    test('even with padding', () {
      var iterable = partition([1, 2, 3, 4], 2, 0);
      expect(iterable, [
        [1, 2],
        [3, 4]
      ]);
    });
    test('odd', () {
      var iterable = partition([1, 2, 3, 4, 5], 2);
      expect(iterable, [
        [1, 2],
        [3, 4],
        [5]
      ]);
    });
    test('odd with padding', () {
      var iterable = partition([1, 2, 3, 4, 5], 2, 0);
      expect(iterable, [
        [1, 2],
        [3, 4],
        [5, 0]
      ]);
    });
  });
  group('periodical', () {
    var date = new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90);
    group('periodical', () {
      test('millennially', () {
        var iterable = periodical(start: date, period: Period.millennially);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(2980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(3980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('centennially', () {
        var iterable = periodical(start: date, period: Period.centennially);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(2080, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(2180, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('decennially', () {
        var iterable = periodical(start: date, period: Period.decennially);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1990, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(2000, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('yearly', () {
        var iterable = periodical(start: date, period: Period.yearly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1981, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1982, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('quarterly', () {
        var iterable = periodical(start: date, period: Period.quarterly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.SEPTEMBER, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.DECEMBER, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('monthly', () {
        var iterable = periodical(start: date, period: Period.monthly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JULY, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.AUGUST, 11, 12, 34, 56, 78, 90),
        ]);
      });
      test('weekly', () {
        var iterable = periodical(start: date, period: Period.weekly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 18, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 25, 12, 34, 56, 78, 90),
        ]);
      });
      test('daily', () {
        var iterable = periodical(start: date, period: Period.daily);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 12, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 13, 12, 34, 56, 78, 90),
        ]);
      });
      test('hourly', () {
        var iterable = periodical(start: date, period: Period.hourly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 13, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 14, 34, 56, 78, 90),
        ]);
      });
      test('minutely', () {
        var iterable = periodical(start: date, period: Period.minutely);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 35, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 36, 56, 78, 90),
        ]);
      });
      test('secondly', () {
        var iterable = periodical(start: date, period: Period.secondly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 57, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 58, 78, 90),
        ]);
      });
      test('millisecondly', () {
        var iterable = periodical(start: date, period: Period.millisecondly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 79, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 80, 90),
        ]);
      });
      test('microsecondly', () {
        var iterable = periodical(start: date, period: Period.microsecondly);
        expect(iterable.take(3), [
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90),
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 91),
          new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 92),
        ]);
      });
      test('start default', () {
        var first = periodical().first;
        var difference = first.difference(new DateTime.now());
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
        var truncated = truncateToPeriod(date, period: Period.millennially);
        expect(truncated, new DateTime(1000));
      });
      test('centennially', () {
        var truncated = truncateToPeriod(date, period: Period.centennially);
        expect(truncated, new DateTime(1900));
      });
      test('decennially', () {
        var truncated = truncateToPeriod(date, period: Period.decennially);
        expect(truncated, new DateTime(1980));
      });
      test('yearly', () {
        var truncated = truncateToPeriod(date, period: Period.yearly);
        expect(truncated, new DateTime(1980));
      });
      test('quarterly', () {
        var truncated = truncateToPeriod(date, period: Period.quarterly);
        expect(truncated, new DateTime(1980, DateTime.APRIL));
      });
      test('monthly', () {
        var truncated = truncateToPeriod(date, period: Period.monthly);
        expect(truncated, new DateTime(1980, DateTime.JUNE));
      });
      test('weekly', () {
        var truncated = truncateToPeriod(date, period: Period.weekly);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 9));
      });
      test('weekly (custom start of the week)', () {
        for (var weekday = DateTime.MONDAY; weekday <= DateTime.SUNDAY; weekday++) {
          var truncated = truncateToPeriod(date, period: Period.weekly, startWeekday: weekday);
          expect(truncated.isBefore(date), isTrue);
          expect(truncated.weekday, weekday);
        }
      });
      test('daily', () {
        var truncated = truncateToPeriod(date, period: Period.daily);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 11));
      });
      test('hourly', () {
        var truncated = truncateToPeriod(date, period: Period.hourly);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 11, 12));
      });
      test('minutely', () {
        var truncated = truncateToPeriod(date, period: Period.minutely);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 11, 12, 34));
      });
      test('secondly', () {
        var truncated = truncateToPeriod(date, period: Period.secondly);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56));
      });
      test('millisecondly', () {
        var truncated = truncateToPeriod(date, period: Period.millisecondly);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78));
      });
      test('microsecondly', () {
        var truncated = truncateToPeriod(date, period: Period.microsecondly);
        expect(truncated, new DateTime(1980, DateTime.JUNE, 11, 12, 34, 56, 78, 90));
      });
      test('invalid timestamp', () {
        expect(() => truncateToPeriod(null), throwsArgumentError);
      });
      test('invalid period', () {
        expect(() => truncateToPeriod(date, period: null), throwsArgumentError);
      });
      test('invalid start weekday', () {
        expect(
            () => truncateToPeriod(date, period: Period.weekly, startWeekday: DateTime.MONDAY - 1),
            throwsArgumentError);
        expect(
            () => truncateToPeriod(date, period: Period.weekly, startWeekday: DateTime.SUNDAY + 1),
            throwsArgumentError);
      });
    });
  });
  group('product', () {
    test('2 x 2', () {
      var iterable = product([
        [1, 2],
        [3, 4]
      ]);
      expect(iterable, [
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4]
      ]);
    });
    test('1 x 2 x 3', () {
      var iterable = product([
        [1],
        [2, 3],
        [4, 5, 6]
      ]);
      expect(iterable, [
        [1, 2, 4],
        [1, 2, 5],
        [1, 2, 6],
        [1, 3, 4],
        [1, 3, 5],
        [1, 3, 6]
      ]);
    });
    test('3 x 2 x 1', () {
      var iterable = product([
        [1, 2, 3],
        [4, 5],
        [6]
      ]);
      expect(iterable, [
        [1, 4, 6],
        [1, 5, 6],
        [2, 4, 6],
        [2, 5, 6],
        [3, 4, 6],
        [3, 5, 6]
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
      var infinite = repeat(1);
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
}
