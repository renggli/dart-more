import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../../test_utils.dart';
import 'search_test_utils.dart';

void main() {
  group('floydWarshallSearch', () {
    test('directed path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      final allShortestPaths = floydWarshallSearch<int>(
        vertices: graph.vertices,
        successorsOf: graph.successorsOf,
      );
      for (var i = 0; i < 10; i++) {
        check(allShortestPaths.distance(0, i)).equals(i);
        check(allShortestPaths.path(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: i));
        if (i != 0) {
          check(allShortestPaths.distance(i, 0)).equals(double.infinity);
          check(allShortestPaths.path(i, 0)).isNull();
        }
      }
    });
    test('undirected path', () {
      final graph = GraphFactory<int, void>(isDirected: false)
          .path(vertexCount: 10);
      final allShortestPaths = floydWarshallSearch<int>(
        vertices: graph.vertices,
        successorsOf: graph.successorsOf,
      );
      for (var i = 0; i < 10; i++) {
        check(allShortestPaths.distance(0, i)).equals(i);
        check(allShortestPaths.path(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: i));
        check(allShortestPaths.distance(i, 0)).equals(i);
        check(allShortestPaths.path(i, 0))
            .isNotNull()
            .which(isPath(source: i, target: 0, cost: i));
      }
    });
    test('dijkstra graph', () {
      final graph = dijkstraGraph;
      final allShortestPaths = floydWarshallSearch<int>(
        vertices: graph.vertices,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(allShortestPaths.allPaths()).unorderedMatches([
        isPath(vertices: [1], cost: 0),
        isPath(vertices: [1, 2], cost: 7),
        isPath(vertices: [1, 3], cost: 9),
        isPath(vertices: [1, 3, 4], cost: 20),
        isPath(vertices: [1, 3, 6, 5], cost: 20),
        isPath(vertices: [1, 3, 6], cost: 11),
        isPath(vertices: [2, 1], cost: 7),
        isPath(vertices: [2], cost: 0),
        isPath(vertices: [2, 3], cost: 10),
        isPath(vertices: [2, 4], cost: 15),
        isPath(vertices: [2, 3, 6, 5], cost: 21),
        isPath(vertices: [2, 3, 6], cost: 12),
        isPath(vertices: [3, 1], cost: 9),
        isPath(vertices: [3, 2], cost: 10),
        isPath(vertices: [3], cost: 0),
        isPath(vertices: [3, 4], cost: 11),
        isPath(vertices: [3, 6, 5], cost: 11),
        isPath(vertices: [3, 6], cost: 2),
        isPath(vertices: [4, 3, 1], cost: 20),
        isPath(vertices: [4, 2], cost: 15),
        isPath(vertices: [4, 3], cost: 11),
        isPath(vertices: [4], cost: 0),
        isPath(vertices: [4, 5], cost: 6),
        isPath(vertices: [4, 3, 6], cost: 13),
        isPath(vertices: [5, 6, 3, 1], cost: 20),
        isPath(vertices: [5, 6, 3, 2], cost: 21),
        isPath(vertices: [5, 6, 3], cost: 11),
        isPath(vertices: [5, 4], cost: 6),
        isPath(vertices: [5], cost: 0),
        isPath(vertices: [5, 6], cost: 9),
        isPath(vertices: [6, 3, 1], cost: 11),
        isPath(vertices: [6, 3, 2], cost: 12),
        isPath(vertices: [6, 3], cost: 2),
        isPath(vertices: [6, 3, 4], cost: 13),
        isPath(vertices: [6, 5], cost: 9),
        isPath(vertices: [6], cost: 0),
      ]);
    });
    test('bellman-ford graph (negative edges)', () {
      final graph = bellmanFordGraph;
      final allShortestPaths = floydWarshallSearch<String>(
        vertices: graph.vertices,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(allShortestPaths.allPaths(sourceVertices: ['s'])).unorderedMatches([
        isPath(vertices: ['s'], cost: 0),
        isPath(vertices: ['s', 'y'], cost: 7),
        isPath(vertices: ['s', 'y', 'x'], cost: 4),
        isPath(vertices: ['s', 'y', 'x', 't'], cost: 2),
        isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
      ]);
      check(allShortestPaths.allPaths(targetVertices: ['z'])).unorderedMatches([
        isPath(vertices: ['z'], cost: 0),
        isPath(vertices: ['t', 'z'], cost: -4),
        isPath(vertices: ['x', 't', 'z'], cost: -6),
        isPath(vertices: ['y', 'x', 't', 'z'], cost: -9),
        isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
      ]);
    });
    test('directed graph with negative cycle', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: -3)
        ..addEdge(2, 0, value: -1);
      check(
        () => floydWarshallSearch<int>(
          vertices: graph.vertices,
          successorsOf: graph.successorsOf,
          edgeCost: (source, target) => graph.getEdge(source, target)!.value,
        ),
      ).throws<GraphError>();
    });
    test('directed graph with negative self-loop', () {
      final graph = Graph<int, int>(isDirected: true)..addEdge(0, 0, value: -1);
      check(
        () => floydWarshallSearch<int>(
          vertices: graph.vertices,
          successorsOf: graph.successorsOf,
          edgeCost: (source, target) => graph.getEdge(source, target)!.value,
        ),
      ).throws<GraphError>();
    });
    test('unknown vertices throw GraphError', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 3);
      final allShortestPaths = floydWarshallSearch<int>(
        vertices: graph.vertices,
        successorsOf: graph.successorsOf,
      );
      check(() => allShortestPaths.distance(99, 1)).throws<GraphError>();
      check(() => allShortestPaths.distance(1, 99)).throws<GraphError>();
      check(() => allShortestPaths.path(99, 1)).throws<GraphError>();
      check(() => allShortestPaths.path(1, 99)).throws<GraphError>();
    });
    group('metrics', () {
      test('undirected path P5 (0-1-2-3-4)', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .path(vertexCount: 5);
        final fw = graph.allShortestPaths();

        // Eccentricities:
        // 0: max dist to 4 is 4
        // 1: max dist to 4 is 3
        // 2: max dist to 0 or 4 is 2
        // 3: max dist to 0 is 3
        // 4: max dist to 0 is 4
        check(fw.eccentricity(0)).equals(4);
        check(fw.eccentricity(1)).equals(3);
        check(fw.eccentricity(2)).equals(2);
        check(fw.eccentricity(3)).equals(3);
        check(fw.eccentricity(4)).equals(4);

        check(fw.diameter).equals(4);
        check(fw.radius).equals(2);
        check(fw.center).unorderedEquals([2]);
        check(fw.periphery).unorderedEquals([0, 4]);

        // Total pairs: 5 * 4 = 20 pairs (directed pairs in FW).
        // For P5, sum of distances:
        // from 0: 1+2+3+4 = 10
        // from 1: 1+1+2+3 = 7
        // from 2: 2+1+1+2 = 6
        // from 3: 3+2+1+1 = 7
        // from 4: 4+3+2+1 = 10
        // Total = 40. 40 / 20 = 2.0.
        check(fw.averagePathLength).equals(2.0);
      });

      test('disconnected graph', () {
        final graph = Graph<int, void>(isDirected: false)
          ..addEdge(0, 1)
          ..addEdge(2, 3);
        final fw = graph.allShortestPaths();

        check(fw.eccentricity(0)).equals(double.infinity);
        check(fw.diameter).equals(double.infinity);
        check(fw.radius).equals(double.infinity);
        check(fw.center).isEmpty();
        check(fw.periphery).isEmpty();
        // Connected pairs: 0-1, 1-0, 2-3, 3-2 (each dist 1). Average = 1.0.
        check(fw.averagePathLength).equals(1.0);
      });

      test('single vertex graph', () {
        final graph = Graph<int, void>(isDirected: false)..addVertex(1);
        final fw = graph.allShortestPaths();

        check(fw.eccentricity(1)).equals(0);
        check(fw.diameter).equals(0);
        check(fw.radius).equals(0);
        check(fw.center).unorderedEquals([1]);
        check(fw.periphery).unorderedEquals([1]);
        check(fw.averagePathLength).equals(0.0);
      });
    });

    group('maze', () {
      test('floyd-warshall', () {
        final search = floydWarshallSearch<Point<int>>(
          vertices: BreadthFirstIterable([
            mazeSource,
          ], successorsOf: mazeSuccessorsOf),
          successorsOf: mazeSuccessorsOf,
        );
        check(search.path(mazeSource, mazeTarget)).isNotNull().which(
          isPath(
            source: mazeSource,
            target: mazeTarget,
            vertices: mazeSolution,
            cost: mazeSolution.length - 1,
          ),
        );
      });
    });
  });
}
