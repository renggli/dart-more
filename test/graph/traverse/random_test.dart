import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('random walk', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      check(graph.randomWalk(5)).deepEquals([5, 6, 7, 8, 9]);
    });
    test('ring (infinite)', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 4);
      check(graph.randomWalk(0).take(10))
          .deepEquals([0, 1, 2, 3, 0, 1, 2, 3, 0, 1]);
    });
    test('ring (avoid duplicates)', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 4);
      check(graph.randomWalk(0, selfAvoiding: true)).deepEquals([0, 1, 2, 3]);
    });
    test('star (default probabilities)', () {
      final random = Random(3527);
      final graph = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 4);
      final observations = graph
          .randomWalk(0, random: random)
          .take(100)
          .toMultiset();
      check(
        because: 'All vertices should be visited.',
        observations.elementSet,
      ).unorderedEquals([0, 1, 2, 3]);
    });
    test('star (tweaked probabilities)', () {
      final random = Random(3527);
      final graph = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 4);
      final observations = graph
          .randomWalk(
            0,
            random: random,
            edgeProbability: (source, target) => source == 0 ? target : 1,
          )
          .take(1000)
          .toMultiset();
      check(
        because: 'The vertices should be in descending priority.',
        observations
            .asMap()
            .entries
            .toSortedList(comparator: (a, b) => b.value.compareTo(a.value))
            .map((entry) => entry.key),
      ).deepEquals([0, 3, 2, 1]);
    });
    test('custom', () {
      const offsets = [Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0)];
      final walk = RandomWalkIterable<Point<int>>(
        const Point(0, 0),
        successorsOf: (point) => offsets.map((each) => point + each),
      ).take(100).toList();
      check(walk).length.equals(100);
    });
  });
}
