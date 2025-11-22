import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

import 'utils/graph.dart';

void main() {
  group('breadth-first', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      expect(graph.breadthFirst(graph.vertices.first), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      ]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      expect(graph.breadthFirst(graph.vertices.first), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      ]);
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      expect(graph.breadthFirst(0), [0, 3, 2, 1, 5, 4]);
    });
    test('cyclic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
      expect(graph.breadthFirst(0), [0, 3, 1, 4, 2]);
    });
    test('infinite', () {
      final iterable = BreadthFirstIterable([
        1,
      ], successorsOf: reverseCollatzGraph);
      expect(iterable.take(10), [1, 2, 4, 8, 16, 5, 32, 10, 64, 3]);
    });
  });
  group('depth-first', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      expect(graph.depthFirst(graph.vertices.first), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      ]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      expect(graph.depthFirst(graph.vertices.first), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      ]);
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      expect(graph.depthFirst(0), [0, 3, 2, 5, 1, 4]);
    });
    test('cyclic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
      expect(graph.depthFirst(0), [0, 3, 1, 2, 4]);
    });
    test('infinite', () {
      final iterable = DepthFirstIterable([
        1,
      ], successorsOf: reverseCollatzGraph);
      expect(iterable.take(10), [1, 2, 4, 8, 16, 5, 10, 3, 6, 12]);
    });
  });
  group('depth-first (post-order)', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      expect(graph.depthFirstPostOrder(graph.vertices.first), [
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
      ]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      expect(graph.depthFirstPostOrder(graph.vertices.first), [
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1,
        0,
      ]);
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      expect(graph.depthFirstPostOrder(0), [3, 5, 2, 4, 1, 0]);
    });
    test('cyclic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
      expect(graph.depthFirstPostOrder(0), [2, 1, 4, 3, 0]);
    });
    test('custom', () {
      final iterable = DepthFirstPostOrderIterable<int>([
        27,
      ], successorsOf: collatzGraph);
      expect(iterable, allOf(hasLength(112), contains(9232), contains(1)));
    });
  });
  group('topological', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      expect(graph.topological(graph.vertices.first), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      ]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      expect(graph.topological(graph.vertices.first), isEmpty);
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      expect(graph.topological(0), [0, 1, 4, 2, 5, 3]);
    });
    test('custom', () {
      final iterable = TopologicalIterable<int>(
        [1],
        successorsOf: (vertex) =>
            [2 * vertex, 3 * vertex].where((each) => each < 50),
        predecessorsOf: (vertex) => [
          if (vertex > 0 && vertex % 2 == 0) vertex ~/ 2,
          if (vertex > 0 && vertex % 3 == 0) vertex ~/ 3,
        ],
      );
      expect(iterable, [1, 3, 9, 27, 2, 6, 18, 4, 12, 36, 8, 24, 16, 48, 32]);
    });
  });
  group('random walk', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      expect(graph.randomWalk(5), [5, 6, 7, 8, 9]);
    });
    test('ring (infinite)', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 4);
      expect(graph.randomWalk(0).take(10), [0, 1, 2, 3, 0, 1, 2, 3, 0, 1]);
    });
    test('ring (avoid duplicates)', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 4);
      expect(graph.randomWalk(0, selfAvoiding: true), [0, 1, 2, 3]);
    });
    test('star (default probabilities)', () {
      final random = Random(3527);
      final graph = GraphFactory<int, void>(
        isDirected: false,
      ).star(vertexCount: 4);
      final observations = graph
          .randomWalk(0, random: random)
          .take(100)
          .toMultiset();
      expect(observations.elementSet, {
        0,
        1,
        2,
        3,
      }, reason: 'All vertices should be visited.');
    });
    test('star (tweaked probabilities)', () {
      final random = Random(3527);
      final graph = GraphFactory<int, void>(
        isDirected: false,
      ).star(vertexCount: 4);
      final observations = graph
          .randomWalk(
            0,
            random: random,
            edgeProbability: (source, target) => source == 0 ? target : 1,
          )
          .take(1000)
          .toMultiset();
      expect(
        observations
            .asMap()
            .entries
            .toSortedList(comparator: (a, b) => b.value.compareTo(a.value))
            .map((entry) => entry.key),
        [0, 3, 2, 1],
        reason: 'The vertices should be in descending priority.',
      );
    });
    test('custom', () {
      const offsets = [Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0)];
      final walk = RandomWalkIterable<Point<int>>(
        const Point(0, 0),
        successorsOf: (point) => offsets.map((each) => point + each),
      ).take(100).toList();
      expect(walk, hasLength(100));
    });
  });
}
