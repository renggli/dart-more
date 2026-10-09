import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('depth-first (post-order)', () {
    test('path', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 10);
      check(graph.depthFirstPostOrder(graph.vertices.first))
          .deepEquals([9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
    });
    test('ring', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 10);
      check(graph.depthFirstPostOrder(graph.vertices.first))
          .deepEquals([9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
    });
    test('basic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
      check(graph.depthFirstPostOrder(0)).deepEquals([3, 5, 2, 4, 1, 0]);
    });
    test('cyclic', () {
      final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
      check(graph.depthFirstPostOrder(0)).deepEquals([2, 1, 4, 3, 0]);
    });
    test('custom', () {
      final iterable = DepthFirstPostOrderIterable<int>([
        27,
      ], successorsOf: collatzGraph);
      check(iterable)
        ..length.equals(112)
        ..contains(9232)
        ..contains(1);
    });
  });
}
