import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

void main() {
  group('hasCycle', () {
    test('empty graph has no cycle', () {
      final graph = Graph<int, void>(isDirected: true);
      check(graph.hasCycle()).isFalse();
    });
    test('single vertex graph has no cycle', () {
      final graph = Graph<int, void>(isDirected: true)..addVertex(1);
      check(graph.hasCycle()).isFalse();
    });
    test('single vertex with self-loop has a cycle', () {
      final graph = Graph<int, void>(isDirected: true)..addEdge(1, 1);
      check(graph.hasCycle()).isTrue();
    });
    test('path graph has no cycle', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 5);
      check(graph.hasCycle()).isFalse();
    });
    test('ring graph has a cycle', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 5);
      check(graph.hasCycle()).isTrue();
    });
    test('dag has no cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(0, 2)
        ..addEdge(1, 3)
        ..addEdge(2, 3);
      check(graph.hasCycle()).isFalse();
    });
    test('graph with a cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 0);
      check(graph.hasCycle()).isTrue();
    });
    test('graph with a longer cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 0);
      check(graph.hasCycle()).isTrue();
    });
    test('disconnected graph without cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(2, 3);
      check(graph.hasCycle()).isFalse();
    });
    test('disconnected graph with cycle', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(2, 3)
        ..addEdge(3, 4)
        ..addEdge(4, 2);
      check(graph.hasCycle()).isTrue();
    });
    test('undirected graph error', () {
      final graph = Graph<int, void>(isDirected: false);
      check(graph.hasCycle).throws<GraphError>();
    });
  });
}
