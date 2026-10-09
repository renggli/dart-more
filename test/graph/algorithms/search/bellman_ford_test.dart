import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';
import 'search_test_utils.dart';

void main() {
  group('bellmanFordSearch', () {
    test('directed graph with negative edges', () {
      final graph = bellmanFordGraph;
      final search = bellmanFordSearch<String>(
        startVertices: ['s'],
        targetPredicate: (vertex) => vertex == 'z',
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(search.single)
          .which(isPath(vertices: ['s', 'y', 'x', 't', 'z'], cost: -2));
    });
    test('directed graph with negative edge', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: 3);
      final search = bellmanFordSearch<int>(
        startVertices: [0],
        targetPredicate: (vertex) => vertex == 2,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(search.single).which(isPath(source: 0, target: 2, cost: 1));
    });
    test('directed graph with negative cycle', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: -3)
        ..addEdge(2, 0, value: -1);
      final search = bellmanFordSearch<int>(
        startVertices: [0],
        targetPredicate: (vertex) => vertex == 2,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(() => search.first).throws<GraphError>();
    });
    test(
      'directed graph with negative cycle detected before yielding paths',
      () {
        final graph = Graph<int, int>(isDirected: true)
          ..addEdge(0, 1, value: 1)
          ..addEdge(0, 2, value: 1)
          ..addEdge(2, 3, value: -2)
          ..addEdge(3, 2, value: -2);
        final search = bellmanFordSearch<int>(
          startVertices: [0],
          targetPredicate: (vertex) => true,
          successorsOf: graph.successorsOf,
          edgeCost: (source, target) => graph.getEdge(source, target)!.value,
        );
        check(() => search.first).throws<GraphError>();
      },
    );
    test('directed graph with negative edge and positive cycle', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: -2)
        ..addEdge(1, 2, value: 3)
        ..addEdge(2, 0, value: 1);
      final search = bellmanFordSearch<int>(
        startVertices: [0],
        targetPredicate: (vertex) => vertex == 2,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(search.single).which(isPath(source: 0, target: 2, cost: 1));
    });
    group('hills', () {
      test('default cost', () {
        final search = bellmanFordSearch<Point<int>>(
          startVertices: [hillsSource],
          targetPredicate: hillsTargetPredicate,
          successorsOf: hillsSuccessorsOf,
        );
        final path = search.single;
        check(path)
            .which(isPath(source: hillsSource, target: hillsTarget, cost: 45));
        check(path.vertices).length.equals(46);
      });
      test('custom cost', () {
        final search = bellmanFordSearch<Point<int>>(
          startVertices: [hillsSource],
          targetPredicate: hillsTargetPredicate,
          successorsOf: hillsSuccessorsOf,
          edgeCost: hillsEdgeCost,
        );
        final path = search.single;
        check(path).which(isPath(source: hillsSource, target: hillsTarget));
        check(path.vertices).length.equals(47);
        check(path.cost).isCloseTo(63.79, 0.1);
      });
    });
    group('maze', () {
      test('default cost', () {
        final search = bellmanFordSearch<Point<int>>(
          startVertices: [mazeSource],
          targetPredicate: mazeTargetPredicate,
          successorsOf: mazeSuccessorsOf,
        );
        check(search.single).which(
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
