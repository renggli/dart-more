import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/interval.dart';
import 'package:test/test.dart';

void verifyInvariants<V>(IntervalTree<num, V> tree) {
  for (final value in tree) {
    final interval = tree.getter(value);
    final average = (interval.lower + interval.upper) / 2;
    final includes = contains(same(value)), excludes = isNot(includes);
    // Query point invariants
    expect(tree.queryPoint(average), includes);
    expect(tree.queryPoint(interval.lower), includes);
    expect(tree.queryPoint(interval.upper), includes);
    expect(tree.queryPoint(interval.lower - 1), excludes);
    expect(tree.queryPoint(interval.upper + 1), excludes);
    // Query interval invariants
    expect(tree.queryInterval(interval), includes);
    expect(tree.queryInterval(Interval(average)), includes);
    expect(tree.queryInterval(Interval(interval.lower)), includes);
    expect(tree.queryInterval(Interval(interval.upper)), includes);
    expect(
      tree.queryInterval(Interval(interval.lower - 1, interval.lower + 1)),
      includes,
    );
    expect(
      tree.queryInterval(Interval(interval.upper - 1, interval.upper + 1)),
      includes,
    );
    expect(
      tree.queryInterval(Interval(interval.lower - 1, interval.upper + 1)),
      includes,
    );
    expect(
      tree.queryInterval(Interval(interval.lower - 10, interval.upper + 10)),
      includes,
    );
    expect(tree.queryInterval(Interval(interval.lower - 1)), excludes);
    expect(
      tree.queryInterval(Interval(interval.lower - 10, interval.lower - 1)),
      excludes,
    );
    expect(tree.queryInterval(Interval(interval.upper + 1)), excludes);
    expect(
      tree.queryInterval(Interval(interval.upper + 1, interval.upper + 10)),
      excludes,
    );
  }
}

void main() {
  group('interval', () {
    final interval0to7 = Interval<num>(0, 7);
    final interval8to9 = Interval<num>(8, 9);
    final interval1to3 = Interval<num>(1, 3);
    final interval3to6 = Interval<num>(3, 6);
    final interval2to4 = Interval<num>(2, 4);
    final interval5to5 = Interval<num>(5, 5);
    final intervals = [
      interval0to7,
      interval8to9,
      interval1to3,
      interval3to6,
      interval2to4,
      interval5to5,
    ];
    test('lower', () {
      expect(interval0to7.lower, 0);
      expect(interval8to9.lower, 8);
      expect(interval1to3.lower, 1);
      expect(interval3to6.lower, 3);
      expect(interval2to4.lower, 2);
      expect(interval5to5.lower, 5);
    });
    test('upper', () {
      expect(interval0to7.upper, 7);
      expect(interval8to9.upper, 9);
      expect(interval1to3.upper, 3);
      expect(interval3to6.upper, 6);
      expect(interval2to4.upper, 4);
      expect(interval5to5.upper, 5);
    });
    test('isSingle', () {
      expect(interval0to7.isSingle, isFalse);
      expect(interval8to9.isSingle, isFalse);
      expect(interval1to3.isSingle, isFalse);
      expect(interval3to6.isSingle, isFalse);
      expect(interval2to4.isSingle, isFalse);
      expect(interval5to5.isSingle, isTrue);
    });
    test('contains', () {
      for (final interval in intervals) {
        expect(interval.contains(interval.lower - 1), isFalse);
        for (var i = interval.lower; i <= interval.upper; i++) {
          expect(interval.contains(i), isTrue);
        }
        expect(interval.contains(interval.upper + 1), isFalse);
      }
    });
    test('intersects', () {
      final intersects = [intervals, intervals]
          .product()
          .where((pair) => pair.first.intersects(pair.last));
      expect(intersects, [
        [interval0to7, interval0to7],
        [interval0to7, interval1to3],
        [interval0to7, interval3to6],
        [interval0to7, interval2to4],
        [interval0to7, interval5to5],
        [interval8to9, interval8to9],
        [interval1to3, interval0to7],
        [interval1to3, interval1to3],
        [interval1to3, interval3to6],
        [interval1to3, interval2to4],
        [interval3to6, interval0to7],
        [interval3to6, interval1to3],
        [interval3to6, interval3to6],
        [interval3to6, interval2to4],
        [interval3to6, interval5to5],
        [interval2to4, interval0to7],
        [interval2to4, interval1to3],
        [interval2to4, interval3to6],
        [interval2to4, interval2to4],
        [interval5to5, interval0to7],
        [interval5to5, interval3to6],
        [interval5to5, interval5to5],
      ]);
    });
    test('encloses', () {
      final encloses = [intervals, intervals]
          .product()
          .where((pair) => pair.first.encloses(pair.last));
      expect(encloses, [
        [interval0to7, interval0to7],
        [interval0to7, interval1to3],
        [interval0to7, interval3to6],
        [interval0to7, interval2to4],
        [interval0to7, interval5to5],
        [interval8to9, interval8to9],
        [interval1to3, interval1to3],
        [interval3to6, interval3to6],
        [interval3to6, interval5to5],
        [interval2to4, interval2to4],
        [interval5to5, interval5to5],
      ]);
    });
    test('intersection', () {
      final fixtures = [
        (a: interval0to7, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval8to9, r: null),
        (a: interval0to7, b: interval1to3, r: Interval<num>(1, 3)),
        (a: interval0to7, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval0to7, b: interval2to4, r: Interval<num>(2, 4)),
        (a: interval0to7, b: interval5to5, r: Interval<num>(5, 5)),
        (a: interval8to9, b: interval0to7, r: null),
        (a: interval8to9, b: interval8to9, r: Interval<num>(8, 9)),
        (a: interval8to9, b: interval1to3, r: null),
        (a: interval8to9, b: interval3to6, r: null),
        (a: interval8to9, b: interval2to4, r: null),
        (a: interval8to9, b: interval5to5, r: null),
        (a: interval1to3, b: interval0to7, r: Interval<num>(1, 3)),
        (a: interval1to3, b: interval8to9, r: null),
        (a: interval1to3, b: interval1to3, r: Interval<num>(1, 3)),
        (a: interval1to3, b: interval3to6, r: Interval<num>(3, 3)),
        (a: interval1to3, b: interval2to4, r: Interval<num>(2, 3)),
        (a: interval1to3, b: interval5to5, r: null),
        (a: interval3to6, b: interval0to7, r: Interval<num>(3, 6)),
        (a: interval3to6, b: interval8to9, r: null),
        (a: interval3to6, b: interval1to3, r: Interval<num>(3, 3)),
        (a: interval3to6, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval3to6, b: interval2to4, r: Interval<num>(3, 4)),
        (a: interval3to6, b: interval5to5, r: Interval<num>(5, 5)),
        (a: interval2to4, b: interval0to7, r: Interval<num>(2, 4)),
        (a: interval2to4, b: interval8to9, r: null),
        (a: interval2to4, b: interval1to3, r: Interval<num>(2, 3)),
        (a: interval2to4, b: interval3to6, r: Interval<num>(3, 4)),
        (a: interval2to4, b: interval2to4, r: Interval<num>(2, 4)),
        (a: interval2to4, b: interval5to5, r: null),
        (a: interval5to5, b: interval0to7, r: Interval<num>(5, 5)),
        (a: interval5to5, b: interval8to9, r: null),
        (a: interval5to5, b: interval1to3, r: null),
        (a: interval5to5, b: interval3to6, r: Interval<num>(5, 5)),
        (a: interval5to5, b: interval2to4, r: null),
        (a: interval5to5, b: interval5to5, r: Interval<num>(5, 5)),
      ];
      for (final (:a, :b, :r) in fixtures) {
        expect(a.intersection(b), r);
        expect(b.intersection(a), r);
        expect(a.intersects(b), r != null);
        expect(b.intersects(a), r != null);
      }
    });
    test('union', () {
      final fixtures = [
        (a: interval0to7, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval8to9, r: Interval<num>(0, 9)),
        (a: interval0to7, b: interval1to3, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval3to6, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval2to4, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval5to5, r: Interval<num>(0, 7)),
        (a: interval8to9, b: interval0to7, r: Interval<num>(0, 9)),
        (a: interval8to9, b: interval8to9, r: Interval<num>(8, 9)),
        (a: interval8to9, b: interval1to3, r: Interval<num>(1, 9)),
        (a: interval8to9, b: interval3to6, r: Interval<num>(3, 9)),
        (a: interval8to9, b: interval2to4, r: Interval<num>(2, 9)),
        (a: interval8to9, b: interval5to5, r: Interval<num>(5, 9)),
        (a: interval1to3, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval1to3, b: interval8to9, r: Interval<num>(1, 9)),
        (a: interval1to3, b: interval1to3, r: Interval<num>(1, 3)),
        (a: interval1to3, b: interval3to6, r: Interval<num>(1, 6)),
        (a: interval1to3, b: interval2to4, r: Interval<num>(1, 4)),
        (a: interval1to3, b: interval5to5, r: Interval<num>(1, 5)),
        (a: interval3to6, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval3to6, b: interval8to9, r: Interval<num>(3, 9)),
        (a: interval3to6, b: interval1to3, r: Interval<num>(1, 6)),
        (a: interval3to6, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval3to6, b: interval2to4, r: Interval<num>(2, 6)),
        (a: interval3to6, b: interval5to5, r: Interval<num>(3, 6)),
        (a: interval2to4, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval2to4, b: interval8to9, r: Interval<num>(2, 9)),
        (a: interval2to4, b: interval1to3, r: Interval<num>(1, 4)),
        (a: interval2to4, b: interval3to6, r: Interval<num>(2, 6)),
        (a: interval2to4, b: interval2to4, r: Interval<num>(2, 4)),
        (a: interval2to4, b: interval5to5, r: Interval<num>(2, 5)),
        (a: interval5to5, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval5to5, b: interval8to9, r: Interval<num>(5, 9)),
        (a: interval5to5, b: interval1to3, r: Interval<num>(1, 5)),
        (a: interval5to5, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval5to5, b: interval2to4, r: Interval<num>(2, 5)),
        (a: interval5to5, b: interval5to5, r: Interval<num>(5, 5)),
      ];
      for (final (:a, :b, :r) in fixtures) {
        expect(a.union(b), r);
        expect(b.union(a), r);
      }
    });
    test('equals', () {
      for (var i = 0; i < intervals.length; i++) {
        for (var j = 0; j < intervals.length; j++) {
          expect(intervals[i] == intervals[j], i == j ? isTrue : isFalse);
        }
      }
    });
    test('hashCode', () {
      for (var i = 0; i < intervals.length; i++) {
        for (var j = 0; j < intervals.length; j++) {
          expect(intervals[i].hashCode == intervals[j].hashCode,
              i == j ? isTrue : isFalse);
        }
      }
    });
    test('toString', () {
      expect(interval0to7.toString(), '0..7');
      expect(interval8to9.toString(), '8..9');
      expect(interval1to3.toString(), '1..3');
      expect(interval3to6.toString(), '3..6');
      expect(interval2to4.toString(), '2..4');
      expect(interval5to5.toString(), '5..5');
    });
  });
  group('tree', () {
    test('empty', () {
      final tree = IntervalTree.fromIntervals<num>();
      expect(tree, isEmpty);
      expect(tree.length, 0);
      expect(tree.isEmpty, isTrue);
      expect(tree.toString(), '()');
      expect(tree.queryPoint(0), isEmpty);
      expect(tree.queryInterval(Interval(0)), isEmpty);
      verifyInvariants(tree);
    });
    test('single', () {
      final interval = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([interval]);
      expect(tree, isNotEmpty);
      expect(tree.length, 1);
      expect(tree.isEmpty, isFalse);
      expect(tree.toString(), '(1980..2023)');
      expect(tree.queryPoint(2000), [interval]);
      expect(tree.queryInterval(interval), [interval]);
      verifyInvariants(tree);
    });
    test('separate', () {
      final first = Interval<num>(1903, 1975);
      final second = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([first, second]);
      expect(tree, isNotEmpty);
      expect(tree.length, 2);
      expect(tree.isEmpty, isFalse);
      expect(tree.queryPoint(1900), isEmpty);
      expect(tree.queryPoint(1945), [first]);
      expect(tree.queryPoint(1978), isEmpty);
      expect(tree.queryPoint(2000), [second]);
      expect(tree.queryPoint(2030), isEmpty);
      expect(tree.queryInterval(Interval(1900, 1960)), [first]);
      expect(tree.queryInterval(first), [first]);
      expect(tree.queryInterval(Interval(1903, 2023)),
          unorderedEquals([first, second]));
      expect(tree.queryInterval(second), [second]);
      expect(tree.queryInterval(Interval(2000, 2030)), [second]);
      verifyInvariants(tree);
    });
    test('overlapping', () {
      final first = Interval<num>(1945, 2012);
      final second = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([first, second]);
      expect(tree, isNotEmpty);
      expect(tree.length, 2);
      expect(tree.isEmpty, isFalse);
      expect(tree.queryPoint(1900), isEmpty);
      expect(tree.queryPoint(1960), [first]);
      expect(tree.queryPoint(1980), [first, second]);
      expect(tree.queryPoint(2020), [second]);
      expect(tree.queryPoint(2030), isEmpty);
      expect(tree.queryInterval(Interval(1900, 1950)), [first]);
      expect(tree.queryInterval(first), unorderedEquals([first, second]));
      expect(tree.queryInterval(second), unorderedEquals([first, second]));
      expect(tree.queryInterval(Interval(2015, 2030)), [second]);
      verifyInvariants(tree);
    });
    group('stress', () {
      void stress(
        String name, {
        required int count,
        required int range,
        required int size,
      }) =>
          test(name, () {
            final random = Random(name.hashCode);
            final list = List.generate(count, (_) {
              final base = random.nextInt(range);
              final length = random.nextInt(size);
              return Interval<num>(base, base + length);
            });
            final tree = IntervalTree.fromIntervals<num>(list);
            expect(tree, unorderedEquals(list));
            verifyInvariants(tree);
          });
      stress('very small intervals in small range',
          count: 500, range: 1000, size: 10);
      stress('very large intervals in small range',
          count: 500, range: 1000, size: 1000);
      stress('very small intervals in large range',
          count: 500, range: 1000000, size: 10);
      stress('very large intervals in large range',
          count: 500, range: 1000000, size: 1000000);
    });
  });
}
