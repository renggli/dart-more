import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

void main() {
  group('tarjanStronglyConnected', () {
    test('empty graph', () {
      final graph = Graph<int, void>(isDirected: true);
      check(graph.stronglyConnected()).isEmpty();
    });
    test('single vertex', () {
      final graph = Graph<int, void>(isDirected: true)..addVertex(1);
      check(graph.stronglyConnected().toSet()).deepEquals({
        {1},
      });
    });
    test('self-connected vertex', () {
      final graph = Graph<int, void>(isDirected: true)..addEdge(1, 1);
      check(graph.stronglyConnected().toSet()).deepEquals({
        {1},
      });
    });
    test('disconnected pair', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addVertex(1)
        ..addVertex(2);
      check(graph.stronglyConnected().toSet()).deepEquals({
        {1},
        {2},
      });
    });
    test('weakly connected pair', () {
      final graph = Graph<int, void>(isDirected: true)..addEdge(2, 1);
      check(graph.stronglyConnected().toSet()).deepEquals({
        {1},
        {2},
      });
    });
    test('strongly connected pair', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(1, 2)
        ..addEdge(2, 1);
      check(graph.stronglyConnected().toSet()).deepEquals({
        {1, 2},
      });
    });
    test('wikipedia', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(1, 5)
        ..addEdge(2, 1)
        ..addEdge(3, 2)
        ..addEdge(3, 4)
        ..addEdge(4, 3)
        ..addEdge(5, 2)
        ..addEdge(6, 2)
        ..addEdge(6, 5)
        ..addEdge(6, 7)
        ..addEdge(7, 3)
        ..addEdge(7, 6)
        ..addEdge(8, 4)
        ..addEdge(8, 7)
        ..addEdge(8, 8);
      check(graph.stronglyConnected().toSet()).deepEquals({
        {1, 2, 5},
        {3, 4},
        {6, 7},
        {8},
      });
    });
    test('undirected graph error', () {
      final graph = Graph<int, void>(isDirected: false);
      check(graph.stronglyConnected).throws<GraphError>();
    });
  });
}
