import '../edge.dart';
import 'forwarding.dart';

/// The view of a graph that is filtered by a vertex predicate.
class WhereVertexGraph<V, E> extends ForwardingGraph<V, E> {
  WhereVertexGraph(super.delegate, this._vertexPredicate);

  final bool Function(V vertex) _vertexPredicate;

  bool _edgePredicate(Edge<V, E> edge) =>
      _vertexPredicate(edge.source) && _vertexPredicate(edge.target);

  @override
  Iterable<V> get vertices => super.vertices.where(_vertexPredicate);

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
  Edge<V, E>? getEdge(V source, V target) =>
      _vertexPredicate(source) && _vertexPredicate(target)
          ? super.getEdge(source, target)
          : null;

  @override
  Iterable<V> neighboursOf(V vertex) => _vertexPredicate(vertex)
      ? super.neighboursOf(vertex).where(_vertexPredicate)
      : const [];

  @override
  Iterable<V> predecessorsOf(V vertex) => _vertexPredicate(vertex)
      ? super.predecessorsOf(vertex).where(_vertexPredicate)
      : const [];

  @override
  Iterable<V> successorsOf(V vertex) => _vertexPredicate(vertex)
      ? super.successorsOf(vertex).where(_vertexPredicate)
      : const [];
}
