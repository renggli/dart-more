import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('isBipartite', () {
    test('empty graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: true);
      check(graph.isBipartite()).isTrue();
    });
    test('single vertex graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: true)..addVertex(1);
      check(graph.isBipartite()).isTrue();
    });
    test('path graph is bipartite', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 5);
      check(graph.isBipartite()).isTrue();
    });
    test('cycle graph (even length) is bipartite', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 4);
      check(graph.isBipartite()).isTrue();
    });
    test('cycle graph (odd length) is not bipartite', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 3);
      check(graph.isBipartite()).isFalse();
    });
    test('complete bipartite graph is bipartite', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [2, 3]);
      check(graph.isBipartite()).isTrue();
    });
    test('complete graph is bipartite only if n <= 2', () {
      check(GraphFactory<int, void>().complete(vertexCount: 1).isBipartite())
          .isTrue();
      check(GraphFactory<int, void>().complete(vertexCount: 2).isBipartite())
          .isTrue();
      check(GraphFactory<int, void>().complete(vertexCount: 3).isBipartite())
          .isFalse();
      check(GraphFactory<int, void>().complete(vertexCount: 4).isBipartite())
          .isFalse();
    });
    test('disconnected bipartite graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(3, 4)
        ..addEdge(5, 6);
      check(graph.isBipartite()).isTrue();
    });
    test('disconnected graph with non-bipartite part is not bipartite', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 1)
        ..addEdge(4, 5);
      check(graph.isBipartite()).isFalse();
    });
    test('directed acyclic graph is bipartite', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(0, 3);
      check(graph.isBipartite()).isTrue();
    });
    test('directed graph with odd cycle is not bipartite', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 0);
      check(graph.isBipartite()).isFalse();
    });
    test('directed graph with even cycle is bipartite', () {
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2)
        ..addEdge(2, 3)
        ..addEdge(3, 0);
      check(graph.isBipartite()).isTrue();
    });
    test('graph with self-loop is not bipartite', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addVertex(0)
        ..addEdge(0, 0);
      check(graph.isBipartite()).isFalse();
    });
  });
}
