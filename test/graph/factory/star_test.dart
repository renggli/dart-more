import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('star', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().star(vertexCount: 0);
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });
    test('single', () {
      final graph = GraphFactory<int, void>().star(vertexCount: 1);
      check(graph.vertices).deepEquals([0]);
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });
    test('full', () {
      final graph = GraphFactory<int, void>().star(vertexCount: 4);
      check(graph.vertices).unorderedEquals([0, 1, 2, 3]);
      check(graph.edges)
          .unorderedMatches([isEdge(0, 1), isEdge(0, 2), isEdge(0, 3)]);
      expectInvariants(graph);
    });
  });
}
