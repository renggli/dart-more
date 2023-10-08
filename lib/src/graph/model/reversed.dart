import '../edge.dart';
import '../graph.dart';
import 'forwarding.dart';
import 'reversed_edge.dart';

extension ReversedGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph where all edges point in the opposite direction.
  Graph<V, E> get reversed => switch (this) {
        ReversedGraph<V, E>(delegate: final delegate) => delegate,
        Graph<V, E>(isDirected: true) => ReversedGraph<V, E>(this),
        _ => this
      };
}

class ReversedGraph<V, E> extends ForwardingGraph<V, E> {
  ReversedGraph(super.delegate);

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
  Edge<V, E>? getEdge(V source, V target) =>
      delegate.getEdge(target, source)?.reversed;

  @override
  Iterable<V> predecessorsOf(V vertex) => delegate.successorsOf(vertex);

  @override
  Iterable<V> successorsOf(V vertex) => delegate.predecessorsOf(vertex);

  @override
  void addEdge(V source, V target, {E? data}) =>
      delegate.addEdge(target, source, data: data);

  @override
  void removeEdge(V source, V target, {E? data}) =>
      delegate.removeEdge(target, source, data: data);
}
