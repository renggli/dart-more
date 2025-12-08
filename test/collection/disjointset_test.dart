import 'dart:math' show Random;

import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  test('initial state', () {
    final disjoinset = DisjointSet([...0.to(5), 2, 3]);
    expect(disjoinset.count, 5);
    expect(disjoinset.sizes, unorderedEquals([1, 1, 1, 1, 1]));
    expect(
      disjoinset.sets,
      unorderedEquals([
        {0},
        {1},
        {2},
        {3},
        {4},
      ]),
    );
    for (var i = 0; i < 5; i++) {
      expect(disjoinset.find(i), i);
    }
  });
  test('union two sets', () {
    final disjoinset = DisjointSet(0.to(5));
    expect(disjoinset.union(0, 1), isTrue);
    expect(disjoinset.count, 4);
    expect(disjoinset.sizes, unorderedEquals([2, 1, 1, 1]));
    expect(
      disjoinset.sets,
      unorderedEquals([
        {0, 1},
        {2},
        {3},
        {4},
      ]),
    );
    expect(disjoinset.find(0), disjoinset.find(1));
    expect(disjoinset.find(2), 2);
  });
  test('union already merged sets', () {
    final disjoinset = DisjointSet(0.to(5));
    disjoinset.union(0, 1);
    expect(disjoinset.union(0, 1), isFalse);
    expect(disjoinset.count, 4);
    expect(disjoinset.sizes, unorderedEquals([2, 1, 1, 1]));
    expect(
      disjoinset.sets,
      unorderedEquals([
        {0, 1},
        {2},
        {3},
        {4},
      ]),
    );
    expect(disjoinset.find(0), disjoinset.find(1));
    expect(disjoinset.find(2), 2);
  });
  test('transitive union', () {
    final disjoinset = DisjointSet(0.to(5));
    disjoinset.union(0, 1);
    disjoinset.union(1, 2);
    expect(disjoinset.count, 3);
    expect(disjoinset.sizes, unorderedEquals([3, 1, 1]));
    expect(
      disjoinset.sets,
      unorderedEquals([
        {0, 1, 2},
        {3},
        {4},
      ]),
    );
    expect(disjoinset.find(0), disjoinset.find(1));
    expect(disjoinset.find(0), disjoinset.find(2));
  });
  test('union all', () {
    final disjoinset = DisjointSet(0.to(5));
    for (var i = 0; i < 4; i++) {
      disjoinset.union(i, i + 1);
    }
    expect(disjoinset.count, 1);
    expect(disjoinset.sizes, unorderedEquals([5]));
    expect(
      disjoinset.sets,
      unorderedEquals([
        {0, 1, 2, 3, 4},
      ]),
    );
    final root = disjoinset.find(0);
    for (var i = 0; i < 5; i++) {
      expect(disjoinset.find(i), root);
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
      expect(disjointSet.count, 1);
      expect(disjointSet.sizes, unorderedEquals([size]));
      expect(disjointSet.sets, unorderedEquals([0.to(size).toSet()]));
    }
  });
  test('error when item not in set', () {
    final disjoinset = DisjointSet(0.to(5));
    expect(() => disjoinset.find(99), throwsArgumentError);
    expect(() => disjoinset.union(99, 0), throwsArgumentError);
    expect(() => disjoinset.union(0, 99), throwsArgumentError);
  });
}
