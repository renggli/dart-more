import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('copy', () {
    test('directed', () {
      final graph = GraphFactory<int, void>(isDirected: true)
          .fromSuccessors(cyclicGraphData);
      final copy = graph.copy();
      check(copy.isDirected).isTrue();
      check(copy.vertexStrategy).equals(graph.vertexStrategy);
      check(copy.vertices).unorderedEquals(graph.vertices);
      check(copy.edges).unorderedEquals(graph.edges);
    });
    test('undirected', () {
      final graph = GraphFactory<int, void>(isDirected: false)
          .fromSuccessors(cyclicGraphData);
      final copy = graph.copy();
      check(copy.isDirected).isFalse();
      check(copy.vertexStrategy).equals(graph.vertexStrategy);
      check(copy.vertices).unorderedEquals(graph.vertices);
      check(copy.edges).unorderedEquals(graph.edges);
    });
    test('directed empty', () {
      final graph = GraphFactory<int, void>(isDirected: true)
          .fromSuccessors(cyclicGraphData);
      final copy = graph.copy(empty: true);
      check(copy.isDirected).isTrue();
      check(copy.vertexStrategy).equals(graph.vertexStrategy);
      check(copy.vertices).isEmpty();
      check(copy.edges).isEmpty();
    });
    test('undirected empty', () {
      final graph = GraphFactory<int, void>(isDirected: false)
          .fromSuccessors(cyclicGraphData);
      final copy = graph.copy(empty: true);
      check(copy.isDirected).isFalse();
      check(copy.vertexStrategy).equals(graph.vertexStrategy);
      check(copy.vertices).isEmpty();
      check(copy.edges).isEmpty();
    });
  });
}
