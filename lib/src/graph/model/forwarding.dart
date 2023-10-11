import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

///
class ForwardingGraph<V, E> extends Graph<V, E> {
  ForwardingGraph(this.delegate);

  final Graph<V, E> delegate;

  @override
  bool get isDirected => delegate.isDirected;

  @override
  bool get isUnmodifiable => delegate.isUnmodifiable;

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
  void addVertex(V vertex) => delegate.addVertex(vertex);

  @override
  void addEdge(V source, V target, {E? value}) =>
      delegate.addEdge(source, target, value: value);

  @override
  void removeVertex(V vertex) => delegate.removeVertex(vertex);

  @override
  void removeEdge(V source, V target) => delegate.removeEdge(source, target);
}
