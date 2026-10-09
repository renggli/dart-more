import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/interval.dart';
import 'package:test/scaffolding.dart';

void verifyInvariants<V>(IntervalTree<num, V> tree) {
  for (final value in tree) {
    final interval = tree.getter(value);
    final average = (interval.lower + interval.upper) / 2;
    // Query point invariants
    check(tree.queryPoint(average)).contains(value);
    check(tree.queryPoint(interval.lower)).contains(value);
    check(tree.queryPoint(interval.upper)).contains(value);
    check(tree.queryPoint(interval.lower - 1)).not((it) => it.contains(value));
    check(tree.queryPoint(interval.upper + 1)).not((it) => it.contains(value));
    // Query interval invariants
    check(tree.queryInterval(interval)).contains(value);
    check(tree.queryInterval(Interval(average))).contains(value);
    check(tree.queryInterval(Interval(interval.lower))).contains(value);
    check(tree.queryInterval(Interval(interval.upper))).contains(value);
    check(tree.queryInterval(Interval(interval.lower - 1, interval.lower + 1)))
        .contains(value);
    check(tree.queryInterval(Interval(interval.upper - 1, interval.upper + 1)))
        .contains(value);
    check(tree.queryInterval(Interval(interval.lower - 1, interval.upper + 1)))
        .contains(value);
    check(
      tree.queryInterval(Interval(interval.lower - 10, interval.upper + 10)),
    ).contains(value);
    check(tree.queryInterval(Interval(interval.lower - 1)))
        .not((it) => it.contains(value));
    check(tree.queryInterval(Interval(interval.lower - 10, interval.lower - 1)))
        .not((it) => it.contains(value));
    check(tree.queryInterval(Interval(interval.upper + 1)))
        .not((it) => it.contains(value));
    check(tree.queryInterval(Interval(interval.upper + 1, interval.upper + 10)))
        .not((it) => it.contains(value));
  }
}

void main() {
  group('tree', () {
    test('empty', () {
      final tree = IntervalTree.fromIntervals<num>();
      check(tree).isEmpty();
      check(tree.length).equals(0);
      check(tree.isEmpty).isTrue();
      check(tree.toString()).equals('()');
      check(tree.queryPoint(0)).isEmpty();
      check(tree.queryInterval(Interval(0))).isEmpty();
      verifyInvariants(tree);
    });
    test('single', () {
      final interval = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([interval]);
      check(tree).isNotEmpty();
      check(tree.length).equals(1);
      check(tree.isEmpty).isFalse();
      check(tree.toString()).equals('(1980..2023)');
      check(tree.queryPoint(2000)).deepEquals([interval]);
      check(tree.queryInterval(interval)).deepEquals([interval]);
      verifyInvariants(tree);
    });
    test('separate', () {
      final first = Interval<num>(1903, 1975);
      final second = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([first, second]);
      check(tree).isNotEmpty();
      check(tree.length).equals(2);
      check(tree.isEmpty).isFalse();
      check(tree.queryPoint(1900)).isEmpty();
      check(tree.queryPoint(1945)).deepEquals([first]);
      check(tree.queryPoint(1978)).isEmpty();
      check(tree.queryPoint(2000)).deepEquals([second]);
      check(tree.queryPoint(2030)).isEmpty();
      check(tree.queryInterval(Interval(1900, 1960))).deepEquals([first]);
      check(tree.queryInterval(first)).deepEquals([first]);
      check(tree.queryInterval(Interval(1903, 2023)))
          .unorderedEquals([first, second]);
      check(tree.queryInterval(second)).deepEquals([second]);
      check(tree.queryInterval(Interval(2000, 2030))).deepEquals([second]);
      verifyInvariants(tree);
    });
    test('overlapping', () {
      final first = Interval<num>(1945, 2012);
      final second = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([first, second]);
      check(tree).isNotEmpty();
      check(tree.length).equals(2);
      check(tree.isEmpty).isFalse();
      check(tree.queryPoint(1900)).isEmpty();
      check(tree.queryPoint(1960)).deepEquals([first]);
      check(tree.queryPoint(1980)).deepEquals([first, second]);
      check(tree.queryPoint(2020)).deepEquals([second]);
      check(tree.queryPoint(2030)).isEmpty();
      check(tree.queryInterval(Interval(1900, 1950))).deepEquals([first]);
      check(tree.queryInterval(first)).unorderedEquals([first, second]);
      check(tree.queryInterval(second)).unorderedEquals([first, second]);
      check(tree.queryInterval(Interval(2015, 2030))).deepEquals([second]);
      verifyInvariants(tree);
    });
    test('repeat', () {
      final first = Interval<num>(1980, 2023);
      final second = Interval<num>(1980, 2023);
      final tree = IntervalTree.fromIntervals<num>([first, second]);
      check(tree).isNotEmpty();
      check(tree.length).equals(2);
      check(tree.isEmpty).isFalse();
      check(tree.queryPoint(1970)).isEmpty();
      check(tree.queryPoint(1980)).deepEquals([first, second]);
      check(tree.queryPoint(2000)).deepEquals([first, second]);
      check(tree.queryPoint(2023)).deepEquals([first, second]);
      check(tree.queryPoint(2030)).isEmpty();
      check(tree.queryInterval(Interval(1900, 1950))).isEmpty();
      check(tree.queryInterval(first)).unorderedEquals([first, second]);
      check(tree.queryInterval(second)).unorderedEquals([first, second]);
      check(tree.queryInterval(Interval(2100, 2200))).isEmpty();
      verifyInvariants(tree);
    });
    group('stress', () {
      void stress(
        String name, {
        required int count,
        required int range,
        required int size,
      }) => test(name, () {
        final random = Random(name.hashCode);
        final list = List.generate(count, (_) {
          final base = random.nextInt(range);
          final length = random.nextInt(size);
          return Interval<num>(base, base + length);
        });
        final tree = IntervalTree.fromIntervals<num>(list);
        check(tree).unorderedEquals(list);
        verifyInvariants(tree);
      });
      stress(
        'very small intervals in small range',
        count: 500,
        range: 1000,
        size: 10,
      );
      stress(
        'very large intervals in small range',
        count: 500,
        range: 1000,
        size: 1000,
      );
      stress(
        'very small intervals in large range',
        count: 500,
        range: 1000000,
        size: 10,
      );
      stress(
        'very large intervals in large range',
        count: 500,
        range: 1000000,
        size: 1000000,
      );
    });
  });
}
