import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/feature.dart';
import 'package:more/interval.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

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
    test('constructor', () {
      check(Interval(1, 1)).equals(Interval(1));
      check(Interval(1, 2)).equals(Interval(1, 2));
      if (hasAssertionsEnabled) {
        check(() => Interval(2, 1)).throws<AssertionError>();
      }
    });
    test('lower', () {
      check(interval0to7.lower).equals(0);
      check(interval8to9.lower).equals(8);
      check(interval1to3.lower).equals(1);
      check(interval3to6.lower).equals(3);
      check(interval2to4.lower).equals(2);
      check(interval5to5.lower).equals(5);
    });
    test('upper', () {
      check(interval0to7.upper).equals(7);
      check(interval8to9.upper).equals(9);
      check(interval1to3.upper).equals(3);
      check(interval3to6.upper).equals(6);
      check(interval2to4.upper).equals(4);
      check(interval5to5.upper).equals(5);
    });
    test('isSingle', () {
      check(interval0to7).isNotSingle();
      check(interval8to9).isNotSingle();
      check(interval1to3).isNotSingle();
      check(interval3to6).isNotSingle();
      check(interval2to4).isNotSingle();
      check(interval5to5).isSingle();
    });
    test('contains', () {
      for (final interval in intervals) {
        check(interval.contains(interval.lower - 1)).isFalse();
        for (var i = interval.lower; i <= interval.upper; i++) {
          check(interval.contains(i)).isTrue();
        }
        check(interval.contains(interval.upper + 1)).isFalse();
      }
    });
    test('intersects', () {
      final intersects = [
        intervals,
        intervals,
      ].product().where((pair) => pair.first.intersects(pair.last));
      check(intersects).deepEquals([
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
      final encloses = [
        intervals,
        intervals,
      ].product().where((pair) => pair.first.encloses(pair.last));
      check(encloses).deepEquals([
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
        check(a.intersection(b)).equals(r);
        check(b.intersection(a)).equals(r);
        check(a.intersects(b)).equals(r != null);
        check(b.intersects(a)).equals(r != null);
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
        check(a.union(b)).equals(r);
        check(b.union(a)).equals(r);
      }
    });
    test('equals', () {
      for (var i = 0; i < intervals.length; i++) {
        for (var j = 0; j < intervals.length; j++) {
          check(intervals[i] == intervals[j]).equals(i == j);
        }
      }
      check(Interval(1, 2)).equals(Interval(1, 2));
    });
    test('hashCode', () {
      for (var i = 0; i < intervals.length; i++) {
        for (var j = 0; j < intervals.length; j++) {
          check(intervals[i].hashCode == intervals[j].hashCode).equals(i == j);
        }
      }
      check(Interval(1, 2).hashCode).equals(Interval(1, 2).hashCode);
    });
    test('toString', () {
      check(interval0to7.toString()).equals('0..7');
      check(interval8to9.toString()).equals('8..9');
      check(interval1to3.toString()).equals('1..3');
      check(interval3to6.toString()).equals('3..6');
      check(interval2to4.toString()).equals('2..4');
      check(interval5to5.toString()).equals('5..5');
    });
  });
}
