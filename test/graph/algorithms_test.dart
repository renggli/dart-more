import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('AlgorithmsGraphExtension', () {
    test('directed path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      final allShortestPaths = graph.allShortestPaths();
      for (var i = 0; i < 10; i++) {
        check(graph.shortestPath(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: i));
        check(allShortestPaths.distance(0, i)).equals(i);
        check(allShortestPaths.path(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: i));
        if (i != 0) {
          check(graph.shortestPath(i, 0)).isNull();
          check(allShortestPaths.distance(i, 0)).equals(double.infinity);
          check(allShortestPaths.path(i, 0)).isNull();
        }
      }
    });
    test('directed path with alternatives', () {
      final builder = GraphFactory<int, void>().newBuilder()
        ..addEdge(0, 1)
        ..addEdge(0, 2)
        ..addEdge(1, 3)
        ..addEdge(2, 3)
        ..addEdge(3, 4)
        ..addEdge(3, 5)
        ..addEdge(4, 6)
        ..addEdge(5, 6)
        ..addEdge(6, 7);
      final graph = builder.build();
      check(graph.shortestPath(0, 7)).isNotNull();
      check(graph.shortestPathAll(0)).length.equals(8);
      check(
        graph.shortestPathAll(
          0,
          targetPredicate: (v) => v == 7,
          includeAlternativePaths: true,
        ),
      ).unorderedMatches([
        isPath(vertices: [0, 1, 3, 4, 6, 7], cost: 5),
        isPath(vertices: [0, 1, 3, 5, 6, 7], cost: 5),
        isPath(vertices: [0, 2, 3, 4, 6, 7], cost: 5),
        isPath(vertices: [0, 2, 3, 5, 6, 7], cost: 5),
      ]);
    });
    test('directed path with cost', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      int edgeCost(int _, int target) => target;
      final allShortestPaths = graph.allShortestPaths(edgeCost: edgeCost);
      for (var i = 0; i < 10; i++) {
        final cost = i * (i + 1) ~/ 2;
        check(graph.shortestPath(0, i, edgeCost: edgeCost))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: cost));
        check(allShortestPaths.distance(0, i)).equals(cost);
        check(allShortestPaths.path(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: cost));
        if (i != 0) {
          check(graph.shortestPath(i, 0, edgeCost: edgeCost)).isNull();
          check(allShortestPaths.distance(i, 0)).equals(double.infinity);
          check(allShortestPaths.path(i, 0)).isNull();
        }
      }
    });
    test('directed path with cost on edge', () {
      final graph = GraphFactory<int, int>(
        edgeProvider: (source, target) => target,
      ).path(vertexCount: 10);
      final allShortestPaths = graph.allShortestPaths();
      for (var i = 0; i < 10; i++) {
        final cost = i * (i + 1) ~/ 2;
        check(graph.shortestPath(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: cost));
        check(allShortestPaths.distance(0, i)).equals(cost);
        check(allShortestPaths.path(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: cost));
        if (i != 0) {
          check(graph.shortestPath(i, 0)).isNull();
          check(allShortestPaths.distance(i, 0)).equals(double.infinity);
          check(allShortestPaths.path(i, 0)).isNull();
        }
      }
    });
    test('undirected path', () {
      final graph = GraphFactory<int, void>(isDirected: false)
          .path(vertexCount: 10);
      final allShortestPaths = graph.allShortestPaths();
      for (var i = 0; i < 10; i++) {
        check(graph.shortestPath(0, i))
            .isNotNull()
            .which(isPath(source: 0, target: i, cost: i));
        check(graph.shortestPath(i, 0))
            .isNotNull()
            .which(isPath(source: i, target: 0, cost: i));
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
    test('undirected graph with edge cost', () {
      final graph = dijkstraGraph;
      check(graph.shortestPath(1, 5)).isNotNull().which(
        isPath(source: 1, target: 5, vertices: [1, 3, 6, 5], cost: 20),
      );
      check(graph.shortestPathAll(1)).unorderedMatches([
        isPath(vertices: [1], cost: 0),
        isPath(vertices: [1, 2], cost: 7),
        isPath(vertices: [1, 3], cost: 9),
        isPath(vertices: [1, 3, 6], cost: 11),
        isPath(vertices: [1, 3, 4], cost: 20),
        isPath(vertices: [1, 3, 6, 5], cost: 20),
      ]);
    });
    test('undirected graph with constant cost', () {
      final graph = dijkstraGraph;
      check(graph.shortestPath(1, 5, edgeCost: constantFunction2(1)))
          .isNotNull()
          .which(isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2));
      check(graph.shortestPathAll(1, edgeCost: constantFunction2(1)))
          .unorderedMatches([
            isPath(vertices: [1], cost: 0),
            isPath(vertices: [1, 6], cost: 1),
            isPath(vertices: [1, 3], cost: 1),
            isPath(vertices: [1, 2], cost: 1),
            isPath(vertices: [1, 3, 4], cost: 2),
            isPath(vertices: [1, 6, 5], cost: 2),
          ]);
    });
    test('undirected graph with cost estimate', () {
      final graph = dijkstraGraph;
      check(
            graph.shortestPath(
              1,
              5,
              edgeCost: constantFunction2(1),
              costEstimate: (vertex) => 6 - vertex,
            ),
          )
          .isNotNull()
          .which(isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2));
      check(
        graph.shortestPathAll(
          1,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
        ),
      ).unorderedMatches([
        isPath(vertices: [1], cost: 0),
        isPath(vertices: [1, 6], cost: 1),
        isPath(vertices: [1, 3], cost: 1),
        isPath(vertices: [1, 2], cost: 1),
        isPath(vertices: [1, 3, 4], cost: 2),
        isPath(vertices: [1, 6, 5], cost: 2),
      ]);
    });
    test('undirected graph with cost estimate and negative edges', () {
      final graph = dijkstraGraph;
      check(
        () => graph.shortestPath(
          1,
          5,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
          hasNegativeEdges: true,
        ),
      ).throws<GraphError>();
      check(
        () => graph.shortestPathAll(
          1,
          edgeCost: constantFunction2(1),
          costEstimate: (vertex) => 6 - vertex,
          hasNegativeEdges: true,
        ),
      ).throws<GraphError>();
    });
    test('unsupported negative edges', () {
      final graph = bellmanFordGraph;
      check(() => graph.shortestPath('s', 'z')).throws<GraphError>();
      check(
        () => graph.shortestPath('s', 'z', costEstimate: constantFunction1(1)),
      ).throws<GraphError>();
    });
    test('directed graph with negative edges', () {
      final graph = bellmanFordGraph;
      check(graph.shortestPath('s', 'z', hasNegativeEdges: true))
          .isNotNull()
          .which(isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2));
      check(graph.shortestPathAll('s', hasNegativeEdges: true))
          .unorderedMatches([
            isPath(vertices: ['s'], cost: 0),
            isPath(vertices: ['s', 'y'], cost: 7),
            isPath(vertices: ['s', 'y', 'x'], cost: 4),
            isPath(vertices: ['s', 'y', 'x', 't'], cost: 2),
            isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2),
          ]);
    });
    test('directed graph with negative edge', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: 3);
      final path = graph.shortestPath(0, 2, hasNegativeEdges: true);
      check(path).isNotNull().which(isPath(source: 0, target: 2, cost: 1));
    });
    test('directed graph with negative cycle', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: -3)
        ..addEdge(2, 0, value: -1);
      check(() => graph.shortestPath(0, 2, hasNegativeEdges: true))
          .throws<GraphError>();
    });
  });
}
