import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('tree', () {
    group('complete', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().completeTree(vertexCount: 0);
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('unary', () {
        final graph = GraphFactory<int, void>().completeTree(
          vertexCount: 3,
          arity: 1,
        );
        check(graph.vertices).unorderedEquals([0, 1, 2]);
        check(graph.edges).unorderedMatches([isEdge(0, 1), isEdge(1, 2)]);
        expectInvariants(graph);
      });
      test('binary', () {
        final graph = GraphFactory<int, void>().completeTree(vertexCount: 6);
        check(graph.vertices).unorderedEquals([0, 1, 2, 3, 4, 5]);
        check(graph.edges).unorderedMatches([
          isEdge(0, 1),
          isEdge(0, 2),
          isEdge(1, 3),
          isEdge(1, 4),
          isEdge(2, 5),
        ]);
        expectInvariants(graph);
      });
      test('ternary', () {
        final graph = GraphFactory<int, void>().completeTree(
          vertexCount: 7,
          arity: 3,
        );
        check(graph.vertices).unorderedEquals([0, 1, 2, 3, 4, 5, 6]);
        check(graph.edges).unorderedMatches([
          isEdge(0, 1),
          isEdge(0, 2),
          isEdge(0, 3),
          isEdge(1, 4),
          isEdge(1, 5),
          isEdge(1, 6),
        ]);
        expectInvariants(graph);
      });
    });
    group('perfect', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().perfectTree(height: 0);
        check(graph.vertices).deepEquals([0]);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('unary', () {
        final graph = GraphFactory<int, void>().perfectTree(
          height: 2,
          arity: 1,
        );
        check(graph.vertices).unorderedEquals([0, 1, 2]);
        check(graph.edges).unorderedMatches([isEdge(0, 1), isEdge(1, 2)]);
        expectInvariants(graph);
      });
      test('binary', () {
        final graph = GraphFactory<int, void>().perfectTree(height: 2);
        check(graph.vertices).unorderedEquals([0, 1, 2, 3, 4, 5, 6]);
        check(graph.edges).unorderedMatches([
          isEdge(0, 1),
          isEdge(0, 2),
          isEdge(1, 3),
          isEdge(1, 4),
          isEdge(2, 5),
          isEdge(2, 6),
        ]);
        expectInvariants(graph);
      });
      test('ternary', () {
        final graph = GraphFactory<int, void>().perfectTree(
          height: 1,
          arity: 3,
        );
        check(graph.vertices).unorderedEquals([0, 1, 2, 3]);
        check(graph.edges)
            .unorderedMatches([isEdge(0, 1), isEdge(0, 2), isEdge(0, 3)]);
        expectInvariants(graph);
      });
    });
  });
}
