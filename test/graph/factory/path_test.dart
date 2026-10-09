import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('path', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 0);
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });
    test('single', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 1);
      check(graph.vertices).deepEquals([0]);
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });
    test('full', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 3);
      check(graph.vertices).unorderedEquals([0, 1, 2]);
      check(graph.edges).unorderedMatches([isEdge(0, 1), isEdge(1, 2)]);
      expectInvariants(graph);
    });
  });
}
