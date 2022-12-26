import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';
import 'directed.dart';

class UndirectedGraph<V, E> extends Graph<V, E> {
  UndirectedGraph({StorageStrategy<V>? vertexStrategy})
      : delegate = DirectedGraph<V, E>(vertexStrategy: vertexStrategy);

  final DirectedGraph<V, E> delegate;

  @override
  StorageStrategy<V> get vertexStrategy => delegate.vertexStrategy;

  @override
  bool get isDirected => false;

  @override
  Iterable<V> get vertices => delegate.vertices;

  @override
  Iterable<Edge<V, E>> get edges => delegate.edges;

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) => delegate.outgoingEdgesOf(vertex);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      delegate.incomingEdgesOf(vertex);

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      delegate.outgoingEdgesOf(vertex);

  @override
  Iterable<V> neighboursOf(V vertex) => delegate.successorsOf(vertex);

  @override
  Iterable<V> predecessorsOf(V vertex) => delegate.predecessorsOf(vertex);

  @override
  Iterable<V> successorsOf(V vertex) => delegate.successorsOf(vertex);

  @override
  void addVertex(V vertex) => delegate.addVertex(vertex);

  @override
  void addEdge(V source, V target, {E? data}) => delegate
    ..addEdge(source, target, data: data)
    ..addEdge(target, source, data: data);

  @override
  void removeVertex(V vertex) => delegate.removeVertex(vertex);

  @override
  void removeEdge(V source, V target, {E? data}) => delegate
    ..removeEdge(source, target, data: data)
    ..removeEdge(target, source, data: data);
}
