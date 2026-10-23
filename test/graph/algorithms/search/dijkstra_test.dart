import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../../test_utils.dart';
import 'search_test_utils.dart';

void main() {
  group('dijkstraSearch', () {
    test('simple search', () {
      final graph = dijkstraGraph;
      final result = dijkstraSearch<int>(
        startVertices: [1],
        targetPredicate: (vertex) => vertex == 5,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      );
      check(
        result.single,
      ).which(isPath(source: 1, target: 5, vertices: [1, 3, 6, 5], cost: 20));
    });
    group('hills', () {
      test('default cost', () {
        final search = dijkstraSearch<Point<int>>(
          startVertices: [hillsSource],
          targetPredicate: hillsTargetPredicate,
          successorsOf: hillsSuccessorsOf,
        );
        check(search.single)
            .which(isPath(source: hillsSource, target: hillsTarget, cost: 45));
        check(search.single.vertices).length.equals(46);
      });
      test('custom cost', () {
        final search = dijkstraSearch<Point<int>>(
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
        final search = dijkstraSearch<Point<int>>(
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
    test('alternative paths with different incoming edge values', () {
      final graph = Graph<String, num>(isDirected: true)
        ..addEdge('S', 'A', value: 1)
        ..addEdge('A', 'T', value: 4)
        ..addEdge('S', 'B', value: 3)
        ..addEdge('B', 'T', value: 2);
      final paths = dijkstraSearch<String>(
        startVertices: ['S'],
        targetPredicate: (v) => v == 'T',
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
        includeAlternativePaths: true,
      ).toList();
      check(paths).length.equals(2);
      check(paths.map((p) => p.values).toList()).unorderedMatches([
        (it) => it.deepEquals([1, 4]),
        (it) => it.deepEquals([3, 2]),
      ]);
    });
    test('zero-weight loop to start vertex terminates', () {
      final graph = Graph<String, num>(isDirected: true)
        ..addEdge('S', 'A', value: 0)
        ..addEdge('A', 'S', value: 0)
        ..addEdge('S', 'T', value: 1);
      final paths = dijkstraSearch<String>(
        startVertices: ['S'],
        targetPredicate: (v) => v == 'T',
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => graph.getEdge(source, target)!.value,
      ).toList();
      check(paths).length.equals(1);
      check(paths.single.vertices).deepEquals(['S', 'T']);
    });
  });
}
