import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('constructors', () {
    test('directed', () {
      // ignore: deprecated_member_use_from_same_package
      final graph = Graph<int, void>.directed();
      check(graph.isDirected).isTrue();
    });
    test('undirected', () {
      // ignore: deprecated_member_use_from_same_package
      final graph = Graph<int, void>.undirected();
      check(graph.isDirected).isFalse();
    });
  });
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
  group('default implementations', () {
    test('directed graph defaults', () {
      final base = Graph<int, void>(isDirected: true)
        ..addEdge(1, 2)
        ..addEdge(2, 3);
      final custom = _MinimalGraph<int, void>(base);

      check(custom.containsVertex(1)).isTrue();
      check(custom.containsVertex(4)).isFalse();
      check(custom.containsEdge(1, 2)).isTrue();
      check(custom.containsEdge(2, 1)).isFalse();
      check(custom.inDegreeOf(2)).equals(1);
      check(custom.outDegreeOf(2)).equals(1);
      check(custom.degreeOf(2)).equals(2);
    });

    test('undirected graph defaults', () {
      final base = Graph<int, void>(isDirected: false)..addEdge(1, 2);
      final custom = _MinimalGraph<int, void>(base);

      check(custom.degreeOf(1)).equals(1);
    });
  });
}

class _MinimalGraph<V, E> extends Graph<V, E> {
  new(this.delegate) : super.generative();

  final Graph<V, E> delegate;

  @override
  bool get isDirected => delegate.isDirected;

  @override
  StorageStrategy<V> get vertexStrategy => delegate.vertexStrategy;

  @override
  Iterable<V> get vertices => delegate.vertices;

  @override
  Iterable<Edge<V, E>> get edges => delegate.edges;

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) => delegate.edgesOf(vertex);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      delegate.incomingEdgesOf(vertex);

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      delegate.outgoingEdgesOf(vertex);

  @override
  Edge<V, E>? getEdge(V source, V target) => delegate.getEdge(source, target);

  @override
  Iterable<V> neighboursOf(V vertex) => delegate.neighboursOf(vertex);

  @override
  Iterable<V> predecessorsOf(V vertex) => delegate.predecessorsOf(vertex);

  @override
  Iterable<V> successorsOf(V vertex) => delegate.successorsOf(vertex);

  @override
  void addEdge(V source, V target, {E? value}) =>
      delegate.addEdge(source, target, value: value);

  @override
  void addVertex(V vertex) => delegate.addVertex(vertex);

  @override
  void removeEdge(V source, V target) => delegate.removeEdge(source, target);

  @override
  void removeVertex(V vertex) => delegate.removeVertex(vertex);
}
