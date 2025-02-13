import '../edge.dart';
import 'forwarding.dart';

/// The view of a graph that is filtered by a edge predicate.
class WhereEdgeGraph<V, E> extends ForwardingGraph<V, E> {
  WhereEdgeGraph(super.delegate, this._edgePredicate);

  final bool Function(Edge<V, E> edge) _edgePredicate;

  @override
  Iterable<Edge<V, E>> get edges => super.edges.where(_edgePredicate);

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      super.edgesOf(vertex).where(_edgePredicate);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      super.incomingEdgesOf(vertex).where(_edgePredicate);

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      super.outgoingEdgesOf(vertex).where(_edgePredicate);

  @override
  Edge<V, E>? getEdge(V source, V target) {
    final edge = super.getEdge(source, target);
    return edge != null && _edgePredicate(edge) ? edge : null;
  }

  @override
  Iterable<V> neighboursOf(V vertex) => super
      .neighboursOf(vertex)
      .where(
        (target) =>
            getEdge(vertex, target) != null || getEdge(target, vertex) != null,
      );

  @override
  Iterable<V> predecessorsOf(V vertex) => super
      .predecessorsOf(vertex)
      .where((target) => getEdge(vertex, target) != null);

  @override
  Iterable<V> successorsOf(V vertex) => super
      .successorsOf(vertex)
      .where((target) => getEdge(target, vertex) != null);
}
