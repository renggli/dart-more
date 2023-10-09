import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

class UndirectedGraph<V, E> extends Graph<V, E> {
  UndirectedGraph({StorageStrategy<V>? vertexStrategy})
      : this._(vertexStrategy ?? StorageStrategy<V>.defaultStrategy());

  UndirectedGraph._(this.vertexStrategy)
      : adjacency = vertexStrategy.createMap<Map<V, E>>();

  final Map<V, Map<V, E>> adjacency;

  @override
  final StorageStrategy<V> vertexStrategy;

  @override
  bool get isDirected => false;

  @override
  Iterable<V> get vertices => adjacency.keys;

  @override
  Iterable<Edge<V, E>> get edges => adjacency.entries.expand((outer) => outer
      .value.entries
      .map((inner) => Edge<V, E>(outer.key, inner.key, value: inner.value)));

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) => outgoingEdgesOf(vertex);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      adjacency[vertex]
          ?.entries
          .map((inner) => Edge<V, E>(inner.key, vertex, value: inner.value)) ??
      const [];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      adjacency[vertex]
          ?.entries
          .map((inner) => Edge<V, E>(vertex, inner.key, value: inner.value)) ??
      const [];

  @override
  Edge<V, E>? getEdge(V source, V target) {
    if (adjacency[source] case final sourceAdjacency?) {
      if (sourceAdjacency[target] case final E value) {
        return Edge<V, E>(source, target, value: value);
      }
    }
    return null;
  }

  @override
  Iterable<V> neighboursOf(V vertex) => adjacency[vertex]?.keys ?? const [];

  @override
  Iterable<V> predecessorsOf(V vertex) => neighboursOf(vertex);

  @override
  Iterable<V> successorsOf(V vertex) => neighboursOf(vertex);

  @override
  void addVertex(V vertex) => _getVertex(vertex);

  @override
  void addEdge(V source, V target, {E? value}) {
    _getVertex(source)[target] = value as E;
    _getVertex(target)[source] = value;
  }

  @override
  void removeVertex(V vertex) {
    final vertexAdjacency = adjacency[vertex];
    if (vertexAdjacency == null) return;
    for (final target in vertexAdjacency.keys) {
      adjacency[target]?.remove(vertex);
    }
    adjacency.remove(vertex);
  }

  @override
  void removeEdge(V source, V target) {
    final sourceAdjacency = adjacency[source];
    if (sourceAdjacency == null) return;
    final targetAdjacency = adjacency[target];
    if (targetAdjacency == null) return;
    sourceAdjacency.remove(target);
    targetAdjacency.remove(source);
  }

  Map<V, E> _getVertex(V vertex) =>
      adjacency.putIfAbsent(vertex, vertexStrategy.createMap<E>);
}
