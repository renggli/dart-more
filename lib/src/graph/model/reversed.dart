import '../edge.dart';
import '../graph.dart';
import 'forwarding.dart';

extension ReversedGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph where all edges point in the opposite direction.
  Graph<V, E> get reversed => switch (this) {
        ReversedGraph<V, E>(delegate: final delegate) => delegate,
        Graph<V, E>(isDirected: true) => ReversedGraph<V, E>(this),
        _ => this
      };
}

/// The view of a graph where all edges point in the opposite direction.
class ReversedGraph<V, E> extends ForwardingGraph<V, E> {
  ReversedGraph(super.delegate) : assert(delegate.isDirected);

  @override
  Iterable<Edge<V, E>> get edges => delegate.edges.map(_reverse);

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      delegate.edgesOf(vertex).map(_reverse);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      delegate.outgoingEdgesOf(vertex).map(_reverse);

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      delegate.incomingEdgesOf(vertex).map(_reverse);

  @override
  Edge<V, E>? getEdge(V source, V target) {
    final edge = delegate.getEdge(target, source);
    return edge != null ? _reverse(edge) : null;
  }

  @override
  Iterable<V> predecessorsOf(V vertex) => delegate.successorsOf(vertex);

  @override
  Iterable<V> successorsOf(V vertex) => delegate.predecessorsOf(vertex);

  @override
  void addEdge(V source, V target, {E? value}) =>
      delegate.addEdge(target, source, value: value);

  @override
  void removeEdge(V source, V target) => delegate.removeEdge(target, source);

  Edge<V, E> _reverse(Edge<V, E> edge) =>
      Edge<V, E>.directed(edge.target, edge.source, value: edge.value);
}
