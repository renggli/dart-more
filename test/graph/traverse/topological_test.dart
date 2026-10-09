import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('topological', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      check(graph.topological(graph.vertices.first))
          .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('path from intermediate vertex', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      check(graph.topological(5)).deepEquals([5, 6, 7, 8, 9]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      check(graph.topological(graph.vertices.first)).isEmpty();
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      check(graph.topological(0)).deepEquals([0, 1, 4, 2, 5, 3]);
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
      check(iterable)
          .deepEquals([1, 3, 9, 27, 2, 6, 18, 4, 12, 36, 8, 24, 16, 48, 32]);
    });
  });
}
