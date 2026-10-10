import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../../test_utils.dart';
import 'search_test_utils.dart';

void main() {
  group('aStarSearch', () {
    test('simple search', () {
      final graph = dijkstraGraph;
      final result = aStarSearch<int>(
        startVertices: [1],
        targetPredicate: (vertex) => vertex == 5,
        successorsOf: graph.successorsOf,
        edgeCost: (source, target) => 1,
        costEstimate: (vertex) => 6 - vertex,
      );
      check(result.single)
          .which(isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2));
    });
    group('hills', () {
      test('default cost', () {
        final search = aStarSearch<Point<int>>(
          startVertices: [hillsSource],
          targetPredicate: hillsTargetPredicate,
          successorsOf: hillsSuccessorsOf,
          costEstimate: hillsCostEstimate,
        );
        final path = search.single;
        check(path)
            .which(isPath(source: hillsSource, target: hillsTarget, cost: 45));
        check(path.vertices).length.equals(46);
      });
      test('custom cost', () {
        final search = aStarSearch<Point<int>>(
          startVertices: [hillsSource],
          targetPredicate: hillsTargetPredicate,
          successorsOf: hillsSuccessorsOf,
          edgeCost: hillsEdgeCost,
          costEstimate: hillsCostEstimate,
        );
        final path = search.single;
        check(path).which(isPath(source: hillsSource, target: hillsTarget));
        check(path.vertices).length.equals(47);
        check(path.cost).isCloseTo(63.79, 0.1);
      });
    });
    group('maze', () {
      test('default cost', () {
        final search = aStarSearch<Point<int>>(
          startVertices: [mazeSource],
          targetPredicate: mazeTargetPredicate,
          successorsOf: mazeSuccessorsOf,
          costEstimate: mazeCostEstimate,
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
      test('bad estimate', () {
        final generator = Random(85642);
        final search = aStarSearch<Point<int>>(
          startVertices: [mazeSource],
          targetPredicate: mazeTargetPredicate,
          successorsOf: mazeSuccessorsOf,
          costEstimate: (vertex) => generator.nextDouble(),
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
