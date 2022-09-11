import 'package:more/interval.dart';
import 'package:more/src/interval/bound.dart';
import 'package:test/test.dart';

final intervals = <Interval>[];

void verifyBound<T>(Bound<T> bound) {
  test('isOpen / isClosed', () {
    if (bound.isOpen) {
      expect(bound.isClosed, isFalse);
    } else {
      expect(bound.isClosed, isTrue);
    }
  });
  test('isBounded / isUnbounded', () {
    if (bound.isBounded) {
      expect(bound.isUnbounded, isFalse);
      expect(bound.endpoint, isNotNull);
    } else {
      expect(bound.isUnbounded, isTrue);
      expect(() => bound.endpoint, throwsStateError);
    }
  });
}

void verify<T>(
  Interval<T> interval, {
  required Iterable<T> included,
  required Iterable<T> excluded,
  bool isEmpty = false,
  bool isSingle = false,
  num? intLength,
  num? doubleLength,
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
  group('lower', () => verifyBound<T>(interval.lower));
  group('upper', () => verifyBound<T>(interval.upper));
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
  if (intLength != null) {
    test('toIntLength', () {
      if (intLength.isInfinite) {
        expect(
            () => LengthIntervalIntExtension(interval as Interval<int>)
                .toIntLength(),
            throwsArgumentError);
      } else {
        final result =
            LengthIntervalIntExtension(interval as Interval<int>).toIntLength();
        expect(result, intLength.toInt());
      }
    });
  }
  if (doubleLength != null) {
    test('toDoubleLength', () {
      final result = LengthIntervalNumExtension(interval as Interval<num>)
          .toDoubleLength();
      expect(result, doubleLength.toDouble());
    });
  }
  test('equal', () {
    expect(interval == interval, isTrue);
    for (var other in intervals) {
      expect(interval == other, isFalse);
      expect(other == interval, isFalse);
    }
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
      final interval = Interval.open(3, 5);
      verify(
        interval,
        included: [4],
        excluded: [2, 3, 5, 6],
        intLength: 0,
        doubleLength: 2,
        toString: '(3..5)',
      );
    });
    group('closed', () {
      final interval = Interval.closed(3, 5);
      verify(
        interval,
        included: [3, 4, 5],
        excluded: [2, 6],
        intLength: 2,
        doubleLength: 2,
        toString: '[3..5]',
      );
    });
    group('openClosed', () {
      final interval = Interval.openClosed(3, 5);
      verify(
        interval,
        included: [4, 5],
        excluded: [2, 3, 6],
        intLength: 1,
        doubleLength: 2,
        toString: '(3..5]',
      );
    });
    group('closedOpen', () {
      final interval = Interval.closedOpen(3, 5);
      verify(
        interval,
        included: [3, 4],
        excluded: [2, 5, 6],
        intLength: 1,
        doubleLength: 2,
        toString: '[3..5)',
      );
    });
    group('greaterThan', () {
      final interval = Interval.greaterThan(4);
      verify(
        interval,
        included: [5, 6, 7],
        excluded: [2, 3, 4],
        intLength: double.infinity,
        doubleLength: double.infinity,
        toString: '(4..+∞)',
      );
    });
    group('atLeast', () {
      final interval = Interval.atLeast(4);
      verify(
        interval,
        included: [4, 5, 6],
        excluded: [1, 2, 3],
        intLength: double.infinity,
        doubleLength: double.infinity,
        toString: '[4..+∞)',
      );
    });
    group('lessThan', () {
      final interval = Interval.lessThan(4);
      verify(
        interval,
        included: [1, 2, 3],
        excluded: [4, 5, 6],
        intLength: double.infinity,
        doubleLength: double.infinity,
        toString: '(-∞..4)',
      );
    });
    group('atMost', () {
      final interval = Interval.atMost(4);
      verify(
        interval,
        included: [2, 3, 4],
        excluded: [5, 6, 7],
        intLength: double.infinity,
        doubleLength: double.infinity,
        toString: '(-∞..4]',
      );
    });
    group('empty', () {
      final interval = Interval<int>.empty();
      verify(
        interval,
        included: <int>[],
        excluded: [1, 2, 3],
        isEmpty: true,
        intLength: 0,
        doubleLength: 0,
        toString: '∅',
      );
    });
    group('single', () {
      final interval = Interval.single(4);
      verify(
        interval,
        included: [4],
        excluded: [2, 3, 5, 6],
        isSingle: true,
        intLength: 1,
        doubleLength: 0,
        toString: '[4..4]',
      );
    });
    group('all', () {
      final interval = Interval<int>.all();
      verify(
        interval,
        included: [1, 2, 3],
        excluded: <int>[],
        intLength: double.infinity,
        doubleLength: double.infinity,
        toString: '(-∞..+∞)',
      );
    });
  });
}
