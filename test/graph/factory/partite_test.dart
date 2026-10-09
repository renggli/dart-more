import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('partite', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: []);
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });
    test('path graph (p: 1, q: 1)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [1, 1]);
      check(graph.vertices).unorderedEquals([0, 1]);
      check(graph.edges).unorderedMatches([isEdge(0, 1)]);
      expectInvariants(graph);
    });
    test('claw graph (p: 1, q: 3)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [1, 3]);
      check(graph.vertices).unorderedEquals([0, 1, 2, 3]);
      check(graph.edges)
          .unorderedMatches([isEdge(0, 1), isEdge(0, 2), isEdge(0, 3)]);
      expectInvariants(graph);
    });
    test('square graph (p: 2, q: 2)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [2, 2]);
      check(graph.vertices).unorderedEquals([0, 1, 2, 3]);
      check(graph.edges).unorderedMatches([
        isEdge(0, 2),
        isEdge(0, 3),
        isEdge(1, 2),
        isEdge(1, 3),
      ]);
      expectInvariants(graph);
    });
    test('utility graph (p: 3, q: 3)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [3, 3]);
      check(graph.vertices).unorderedEquals([0, 1, 2, 3, 4, 5]);
      check(graph.edges).unorderedMatches([
        isEdge(0, 3),
        isEdge(0, 4),
        isEdge(0, 5),
        isEdge(1, 3),
        isEdge(1, 4),
        isEdge(1, 5),
        isEdge(2, 3),
        isEdge(2, 4),
        isEdge(2, 5),
      ]);
      expectInvariants(graph);
    });
  });
}
