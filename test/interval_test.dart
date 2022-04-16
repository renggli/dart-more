import 'package:more/interval.dart';
import 'package:test/test.dart';

final intervals = <Interval>[];

verify<T extends Comparable<T>>(
  Interval<T> interval, {
  required Iterable<T> included,
  required Iterable<T> excluded,
  bool isEmpty = false,
  bool isSingle = false,
  required String toString,
}) {
  final empty = Interval<T>.empty();
  final all = Interval<T>.all();
  test('included', () {
    for (var value in included) {
      expect(interval.contains(value), isTrue);
    }
  });
  test('excluded', () {
    for (var value in excluded) {
      expect(interval.contains(value), isFalse);
    }
  });
  test('equals', () {
    expect(interval == interval, isTrue);
    for (var other in intervals) {
      expect(interval == other, isFalse);
    }
  });
  group('intersection', () {
    test('empty', () {
      expect(empty.intersection(interval), empty);
      expect(interval.intersection(empty), empty);
    });
    test('single (included)', () {
      for (var value in included) {
        final single = Interval<T>.single(value);
        expect(single.intersection(interval), single);
        expect(interval.intersection(single), single);
      }
    });
    test('single (excluded)', () {
      for (var value in excluded) {
        final single = Interval<T>.single(value);
        expect(single.intersection(interval), empty);
        expect(interval.intersection(single), empty);
      }
    });
    test('all', () {
      expect(all.intersection(interval), interval);
      expect(interval.intersection(all), interval);
    });
  });
  group('span', () {
    test('empty', () {
      expect(empty.span(interval), interval);
      expect(interval.span(empty), interval);
    });
    test('single (included)', () {
      for (var value in included) {
        final single = Interval<T>.single(value);
        expect(single.span(interval), interval);
        expect(interval.span(single), interval);
      }
    });
    test('single (excluded)', () {
      for (var value in excluded) {
        final single = Interval<T>.single(value);
        final one = single.span(interval);
        expect(
            (one.lower == single.lower && one.upper == interval.upper) ||
                (one.lower == interval.lower && one.upper == single.upper) ||
                (interval.isEmpty && one == single),
            isTrue);
        final two = single.span(interval);
        expect(
            (two.lower == single.lower && two.upper == interval.upper) ||
                (two.lower == interval.lower && two.upper == single.upper) ||
                (interval.isEmpty && two == single),
            isTrue);
      }
    });
    test('all', () {
      expect(all.span(interval), all);
      expect(interval.span(all), all);
    });
  });
  test('isEmpty', () {
    expect(interval.isEmpty, isEmpty);
  });
  test('isSingle', () {
    expect(interval.isSingle, isSingle);
  });
  test('hash', () {
    expect(interval.hashCode == interval.hashCode, isTrue);
    for (var other in intervals) {
      expect(interval.hashCode == other.hashCode, isFalse);
    }
  });
  test('toString', () {
    expect(interval.toString(), toString);
  });
  tearDownAll(() {
    intervals.add(interval);
  });
}

void main() {
  group('interval', () {
    group('open', () {
      final interval = Interval<num>.open(3, 5);
      verify(
        interval,
        included: [4],
        excluded: [2, 3, 5, 6],
        toString: '(3..5)',
      );
    });
    group('closed', () {
      final interval = Interval<num>.closed(3, 5);
      verify(
        interval,
        included: [3, 4, 5],
        excluded: [2, 6],
        toString: '[3..5]',
      );
    });
    group('openClosed', () {
      final interval = Interval<num>.openClosed(3, 5);
      verify(
        interval,
        included: [4, 5],
        excluded: [2, 3, 6],
        toString: '(3..5]',
      );
    });
    group('closedOpen', () {
      final interval = Interval<num>.closedOpen(3, 5);
      verify(
        interval,
        included: [3, 4],
        excluded: [2, 5, 6],
        toString: '[3..5)',
      );
    });
    group('greaterThan', () {
      final interval = Interval<num>.greaterThan(4);
      verify(
        interval,
        included: [5, 6, 7],
        excluded: [2, 3, 4],
        toString: '(4..+∞)',
      );
    });
    group('atLeast', () {
      final interval = Interval<num>.atLeast(4);
      verify(
        interval,
        included: [4, 5, 6],
        excluded: [1, 2, 3],
        toString: '[4..+∞)',
      );
    });
    group('lessThan', () {
      final interval = Interval<num>.lessThan(4);
      verify(
        interval,
        included: [1, 2, 3],
        excluded: [4, 5, 6],
        toString: '(-∞..4)',
      );
    });
    group('atMost', () {
      final interval = Interval<num>.atMost(4);
      verify(
        interval,
        included: [2, 3, 4],
        excluded: [5, 6, 7],
        toString: '(-∞..4]',
      );
    });
    group('empty', () {
      final interval = Interval<num>.empty();
      verify<num>(
        interval,
        included: [],
        excluded: [1, 2, 3],
        isEmpty: true,
        toString: '∅',
      );
    });
    group('single', () {
      final interval = Interval<num>.single(4);
      verify(
        interval,
        included: [4],
        excluded: [2, 3, 5, 6],
        isSingle: true,
        toString: '[4..4]',
      );
    });
    group('all', () {
      final interval = Interval<num>.all();
      verify<num>(
        interval,
        included: [1, 2, 3],
        excluded: [],
        toString: '(-∞..+∞)',
      );
    });
  });
}
