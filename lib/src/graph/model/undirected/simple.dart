import '../../edge.dart';
import '../../strategy.dart';
import 'base.dart';

/// Undirected graph implementation using adjacency lists.
class UndirectedSimpleGraph<V, E> extends UndirectedGraph<V, E> {
  factory UndirectedSimpleGraph.create({
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => UndirectedSimpleGraph<V, E>(
    vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
    edgeStrategy: edgeStrategy ?? StorageStrategy.defaultStrategy(),
  );

  UndirectedSimpleGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  }) : adjacency = vertexStrategy.createMap<Map<V, E>>();

  final Map<V, Map<V, E>> adjacency;

  @override
  Iterable<V> get vertices => adjacency.keys;

  @override
  Iterable<Edge<V, E>> get edges => adjacency.entries.expand(
    (outer) => outer.value.entries.map(
      (inner) => createEdge(outer.key, inner.key, value: inner.value),
    ),
  );

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) => outgoingEdgesOf(vertex);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      adjacency[vertex]?.entries.map(
        (entry) => createEdge(entry.key, vertex, value: entry.value),
      ) ??
      const [];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      adjacency[vertex]?.entries.map(
        (entry) => createEdge(vertex, entry.key, value: entry.value),
      ) ??
      const [];

  @override
  Edge<V, E>? getEdge(V source, V target) {
    if (adjacency[source] case final targetAdjacency?) {
      if (targetAdjacency[target] case final E value) {
        return createEdge(source, target, value: value);
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
  void removeEdge(V source, V target, {E? value}) {
    // TODO: check for value
    adjacency[source]?.remove(target);
    adjacency[target]?.remove(source);
  }

  Map<V, E> _getVertex(V vertex) =>
      adjacency.putIfAbsent(vertex, () => vertexStrategy.createMap<E>());
}
