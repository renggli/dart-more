import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('stoerWagnerMinCut', () {
    test('example 1', () {
      final graph = Graph<int, int>(isDirected: false)
        ..addEdge(1, 2, value: 2)
        ..addEdge(1, 5, value: 3)
        ..addEdge(2, 1, value: 2)
        ..addEdge(2, 3, value: 3)
        ..addEdge(2, 5, value: 2)
        ..addEdge(2, 6, value: 2)
        ..addEdge(3, 2, value: 3)
        ..addEdge(3, 4, value: 4)
        ..addEdge(3, 7, value: 2)
        ..addEdge(4, 3, value: 4)
        ..addEdge(4, 7, value: 2)
        ..addEdge(4, 8, value: 2)
        ..addEdge(5, 1, value: 3)
        ..addEdge(5, 6, value: 3)
        ..addEdge(5, 2, value: 2)
        ..addEdge(6, 2, value: 2)
        ..addEdge(6, 5, value: 3)
        ..addEdge(6, 7, value: 1)
        ..addEdge(7, 6, value: 1)
        ..addEdge(7, 3, value: 2)
        ..addEdge(7, 4, value: 2)
        ..addEdge(7, 8, value: 3)
        ..addEdge(8, 4, value: 2)
        ..addEdge(8, 7, value: 3);
      final minCut = graph.minCut();
      check(minCut.graphs).length.equals(2);
      check(minCut.graphs.first.vertices).deepEquals([3, 4, 7, 8]);
      check(minCut.graphs.last.vertices).deepEquals([1, 2, 5, 6]);
      check(minCut.edges).unorderedMatches([
        isEdge(2, 3, value: 3),
        isEdge(3, 2, value: 3),
        isEdge(6, 7, value: 1),
        isEdge(7, 6, value: 1),
      ]);
      check(minCut.weight).equals(4);
    });
    test('example 2', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(0, 3)
        ..addEdge(3, 2)
        ..addEdge(2, 1)
        ..addEdge(1, 0)
        ..addEdge(0, 2)
        ..addEdge(2, 4)
        ..addEdge(4, 1);
      final minCut = graph.minCut();
      check(minCut.graphs).length.equals(2);
      check(minCut.graphs.first.vertices).unorderedEquals([3]);
      check(minCut.graphs.last.vertices).unorderedEquals([0, 1, 2, 4]);
      check(minCut.edges).unorderedMatches([
        isEdge(0, 3),
        isEdge(3, 0),
        isEdge(2, 3),
        isEdge(3, 2),
      ]);
      check(minCut.weight).equals(2);
    });
    test('example 3', () {
      final graph = Graph<int, int>(isDirected: false)
        ..addEdge(0, 1, value: 2)
        ..addEdge(0, 4, value: 3)
        ..addEdge(1, 2, value: 3)
        ..addEdge(1, 4, value: 2)
        ..addEdge(1, 5, value: 2)
        ..addEdge(2, 3, value: 4)
        ..addEdge(2, 6, value: 2)
        ..addEdge(3, 6, value: 2)
        ..addEdge(3, 7, value: 2)
        ..addEdge(4, 5, value: 3)
        ..addEdge(5, 6, value: 1)
        ..addEdge(6, 7, value: 3);
      final minCut = graph.minCut();
      check(minCut.graphs).length.equals(2);
      check(minCut.graphs.first.vertices).unorderedEquals([2, 3, 6, 7]);
      check(minCut.graphs.last.vertices).unorderedEquals([0, 1, 4, 5]);
      check(minCut.edges).unorderedMatches([
        isEdge(1, 2, value: 3),
        isEdge(2, 1, value: 3),
        isEdge(5, 6, value: 1),
        isEdge(6, 5, value: 1),
      ]);
      check(minCut.weight).equals(4);
    });
    test('example 4', () {
      final graph = Graph<String, int>(isDirected: false)
        ..addEdge('x', 'a', value: 3)
        ..addEdge('x', 'b', value: 1)
        ..addEdge('a', 'c', value: 3)
        ..addEdge('b', 'c', value: 5)
        ..addEdge('b', 'd', value: 4)
        ..addEdge('d', 'e', value: 2)
        ..addEdge('c', 'y', value: 2)
        ..addEdge('e', 'y', value: 3);
      final minCut = graph.minCut();
      check(minCut.graphs).length.equals(2);
      check(minCut.graphs.first.vertices).unorderedEquals(['e', 'y']);
      check(minCut.graphs.last.vertices)
          .unorderedEquals(['x', 'a', 'b', 'c', 'd']);
      check(minCut.edges).unorderedMatches([
        isEdge('c', 'y', value: 2),
        isEdge('y', 'c', value: 2),
        isEdge('d', 'e', value: 2),
        isEdge('e', 'd', value: 2),
      ]);
      check(minCut.weight).equals(4);
    });
    test('empty graph error', () {
      final graph = Graph<String, void>(isDirected: false);
      check(graph.minCut).throws<ArgumentError>();
    });
    test('directed graph error', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2);
      check(graph.minCut).throws<ArgumentError>();
    });
  });
}
