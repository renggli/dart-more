import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';
import 'reversed_edge.dart';

extension ReversedGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph where all edges point in the opposite direction.
  Graph<V, E> get reversed => switch (this) {
        ReversedGraph<V, E>(delegate: final delegate) => delegate,
        Graph<V, E>(isDirected: true) => ReversedGraph<V, E>(this),
        _ => this
      };
}

class ReversedGraph<V, E> extends Graph<V, E> {
  ReversedGraph(this.delegate);

  final Graph<V, E> delegate;

  @override
  StorageStrategy<V> get vertexStrategy => delegate.vertexStrategy;

  @override
  bool get isDirected => delegate.isDirected;

  @override
  Iterable<V> get vertices => delegate.vertices;

  @override
  Iterable<Edge<V, E>> get edges => delegate.edges.map((edge) => edge.reversed);

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      delegate.edgesOf(vertex).map((edge) => edge.reversed);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      delegate.outgoingEdgesOf(vertex).map((edge) => edge.reversed);

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      delegate.incomingEdgesOf(vertex).map((edge) => edge.reversed);

  @override
  Iterable<Edge<V, E>> getEdges(V source, V target) =>
      delegate.getEdges(source, target).map((edge) => edge.reversed);

  @override
  Iterable<V> neighboursOf(V vertex) => delegate.neighboursOf(vertex);

  @override
  Iterable<V> predecessorsOf(V vertex) => delegate.successorsOf(vertex);

  @override
  Iterable<V> successorsOf(V vertex) => delegate.predecessorsOf(vertex);

  @override
  void addVertex(V vertex) => delegate.addVertex(vertex);

  @override
  void addEdge(V source, V target, {E? data}) =>
      delegate.addEdge(target, source, data: data);

  @override
  void removeVertex(V vertex) => delegate.removeVertex(vertex);

  @override
  void removeEdge(V source, V target, {E? data}) =>
      delegate.removeEdge(target, source, data: data);
}
