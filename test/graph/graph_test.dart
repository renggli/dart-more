import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('graph toString', () {
    test('empty', () {
      final graph = Graph<int, void>(isDirected: true);
      check(graph.toString()).contains('vertices: ∅');
      check(graph.toString()).contains('edges: ∅');
    });
    test('more than 3 vertices and edges', () {
      final graph = Graph<int, void>(isDirected: true);
      graph.addEdge(1, 2);
      graph.addEdge(2, 3);
      graph.addEdge(3, 4);
      graph.addEdge(4, 5);
      check(graph.toString()).contains('5 total');
      check(graph.toString()).contains('4 total');
    });
  });
}
