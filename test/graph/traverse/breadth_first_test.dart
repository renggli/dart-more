import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('breadth-first', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      check(graph.breadthFirst(graph.vertices.first))
          .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      check(graph.breadthFirst(graph.vertices.first))
          .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      check(graph.breadthFirst(0)).deepEquals([0, 3, 2, 1, 5, 4]);
    });
    test('cyclic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
      check(graph.breadthFirst(0)).deepEquals([0, 3, 1, 4, 2]);
    });
    test('infinite', () {
      final iterable = BreadthFirstIterable([
        1,
      ], successorsOf: reverseCollatzGraph);
      check(iterable.take(10)).deepEquals([1, 2, 4, 8, 16, 5, 32, 10, 64, 3]);
    });
  });
}
