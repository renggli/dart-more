import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  group('kruskalSpanningTree', () {
    test('empty', () {
      final graph = Graph<String, int>(isDirected: false);
      final spanning = graph.spanningTree();
      check(spanning.vertices).isEmpty();
      check(spanning.edges).isEmpty();
    });
    test('edgeless', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addVertices(['a', 'b']);
      final spanning = graph.spanningTree();
      check(spanning.vertices).deepEquals(['a', 'b']);
      check(spanning.edges).isEmpty();
    });
    test('undirected', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree();
      check(spanning.isDirected).isFalse();
      check(spanning.vertices).unorderedEquals(graph.vertices);
      check(spanning.edges.unique()).unorderedMatches([
        isEdge('a', 'd', value: 1),
        isEdge('a', 'b', value: 2),
        isEdge('d', 'c', value: 3),
      ]);
    });
    test('maximum', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree(
        weightComparator: reverseComparable<num>,
      );
      check(spanning.isDirected).isFalse();
      check(spanning.vertices).unorderedEquals(graph.vertices);
      check(spanning.edges.unique()).unorderedMatches([
        isEdge('a', 'b', value: 2),
        isEdge('b', 'd', value: 2),
        isEdge('d', 'c', value: 3),
      ]);
    });
    test('directed', () {
      final graph = Graph<String, int>(isDirected: true)
        ..addEdge('a', 'b', value: 2)
        ..addEdge('a', 'd', value: 1)
        ..addEdge('b', 'd', value: 2)
        ..addEdge('d', 'c', value: 3);
      final spanning = graph.spanningTree();
      check(spanning.isDirected).isTrue();
      check(spanning.vertices).unorderedEquals(graph.vertices);
      check(spanning.edges).unorderedMatches([
        isEdge('a', 'd', value: 1),
        isEdge('a', 'b', value: 2),
        isEdge('d', 'c', value: 3),
      ]);
    });
    test('large', () {
      final graph = Graph<int, int>(isDirected: false)
        ..addEdge(1, 2, value: 2)
        ..addEdge(1, 4, value: 1)
        ..addEdge(1, 5, value: 4)
        ..addEdge(2, 3, value: 3)
        ..addEdge(2, 4, value: 3)
        ..addEdge(2, 6, value: 7)
        ..addEdge(3, 4, value: 5)
        ..addEdge(3, 6, value: 8)
        ..addEdge(4, 5, value: 9);
      final spanning = graph.spanningTree();
      check(spanning.vertices).unorderedEquals(graph.vertices);
      check(spanning.edges.unique()).unorderedMatches([
        isEdge(1, 2, value: 2),
        isEdge(1, 4, value: 1),
        isEdge(1, 5, value: 4),
        isEdge(2, 3, value: 3),
        isEdge(2, 6, value: 7),
      ]);
    });
    test('avoids cycles with multi-level disjoint sets', () {
      final graph = Graph<int, int>(isDirected: false)
        ..addEdge(1, 2, value: 1)
        ..addEdge(3, 4, value: 2)
        ..addEdge(2, 3, value: 3)
        ..addEdge(1, 4, value: 4);
      final spanning = graph.spanningTree();
      check(spanning.vertices).unorderedEquals([1, 2, 3, 4]);
      check(spanning.edges.unique()).unorderedMatches([
        isEdge(1, 2, value: 1),
        isEdge(3, 4, value: 2),
        isEdge(2, 3, value: 3),
      ]);
    });
    test('disconnected', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('a', 'b', value: 1)
        ..addEdge('x', 'y', value: 1)
        ..addEdge('x', 'z', value: 5)
        ..addEdge('y', 'z', value: 1);
      final spanning = graph.spanningTree();
      check(spanning.vertices).deepEquals(['a', 'b', 'x', 'y', 'z']);
      check(spanning.edges.unique()).unorderedMatches([
        isEdge('a', 'b', value: 1),
        isEdge('x', 'y', value: 1),
        isEdge('y', 'z', value: 1),
      ]);
    });
  });
}
