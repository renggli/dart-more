import 'dart:math' show Random;

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('initial state', () {
    final disjoinset = DisjointSet([...0.to(5), 2, 3]);
    check(disjoinset.elements).unorderedEquals(0.to(5));
    check(disjoinset.count).equals(5);
    check(disjoinset.sizes).unorderedEquals([1, 1, 1, 1, 1]);
    check(disjoinset.sets).unorderedSets([
      {0},
      {1},
      {2},
      {3},
      {4},
    ]);
    for (var i = 0; i < 5; i++) {
      check(disjoinset.find(i)).equals(i);
    }
  });
  test('union two sets', () {
    final disjoinset = DisjointSet(0.to(5));
    check(disjoinset.union(0, 1)).isTrue();
    check(disjoinset.count).equals(4);
    check(disjoinset.sizes).unorderedEquals([2, 1, 1, 1]);
    check(disjoinset.sets).unorderedSets([
      {0, 1},
      {2},
      {3},
      {4},
    ]);
    check(disjoinset.find(0)).equals(disjoinset.find(1));
    check(disjoinset.find(2)).equals(2);
  });
  test('union already merged sets', () {
    final disjoinset = DisjointSet(0.to(5));
    disjoinset.union(0, 1);
    check(disjoinset.union(0, 1)).isFalse();
    check(disjoinset.count).equals(4);
    check(disjoinset.sizes).unorderedEquals([2, 1, 1, 1]);
    check(disjoinset.sets).unorderedSets([
      {0, 1},
      {2},
      {3},
      {4},
    ]);
    check(disjoinset.find(0)).equals(disjoinset.find(1));
    check(disjoinset.find(2)).equals(2);
  });
  test('transitive union', () {
    final disjoinset = DisjointSet(0.to(5));
    disjoinset.union(0, 1);
    disjoinset.union(1, 2);
    check(disjoinset.count).equals(3);
    check(disjoinset.sizes).unorderedEquals([3, 1, 1]);
    check(disjoinset.sets).unorderedSets([
      {0, 1, 2},
      {3},
      {4},
    ]);
    check(disjoinset.find(0)).equals(disjoinset.find(1));
    check(disjoinset.find(0)).equals(disjoinset.find(2));
  });
  test('union all', () {
    final disjoinset = DisjointSet(0.to(5));
    for (var i = 0; i < 4; i++) {
      disjoinset.union(i, i + 1);
    }
    check(disjoinset.count).equals(1);
    check(disjoinset.sizes).unorderedEquals([5]);
    check(disjoinset.sets).unorderedSets([
      {0, 1, 2, 3, 4},
    ]);
    final root = disjoinset.find(0);
    for (var i = 0; i < 5; i++) {
      check(disjoinset.find(i)).equals(root);
    }
  });
  test('stress test', () {
    final random = Random(572315);
    for (var size = 990; size < 1010; size++) {
      final disjointSet = DisjointSet(0.to(size).toList()..shuffle(random));
      final sequence = 0.to(size).toList()..shuffle(random);
      final pairs = sequence.window(2).toList()..shuffle(random);
      for (final pair in pairs) {
        disjointSet.union(pair.first, pair.last);
      }
      check(disjointSet.count).equals(1);
      check(disjointSet.sizes).unorderedEquals([size]);
      check(disjointSet.sets).unorderedSets([0.to(size).toSet()]);
    }
  });
  test('error when item not in set', () {
    final disjoinset = DisjointSet(0.to(5));
    check(() => disjoinset.find(99)).throws<ArgumentError>();
    check(() => disjoinset.union(99, 0)).throws<ArgumentError>();
    check(() => disjoinset.union(0, 99)).throws<ArgumentError>();
  });
}
