import '../../edge.dart';
import '../../strategy.dart';
import 'base.dart';

/// Directed graph implementation using adjacency lists.
class DirectedSimpleGraph<V, E> extends DirectedGraph<V, E> {
  factory DirectedSimpleGraph.create({
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => DirectedSimpleGraph<V, E>(
    vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
    edgeStrategy: edgeStrategy ?? StorageStrategy.defaultStrategy(),
  );

  DirectedSimpleGraph({
    required super.vertexStrategy,
    required super.edgeStrategy,
  }) : adjacency = vertexStrategy.createMap<VertexWrapper<V, E>>();

  final Map<V, VertexWrapper<V, E>> adjacency;

  @override
  Iterable<V> get vertices => adjacency.keys;

  @override
  Iterable<Edge<V, E>> get edges => adjacency.entries.expand(
    (outer) => outer.value.outgoing.entries.map(
      (inner) => createEdge(outer.key, inner.key, value: inner.value),
    ),
  );

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      incomingEdgesOf(vertex).followedBy(outgoingEdgesOf(vertex));

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      adjacency[vertex]?.incoming.entries.map(
        (entry) => createEdge(entry.key, vertex, value: entry.value),
      ) ??
      const [];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      adjacency[vertex]?.outgoing.entries.map(
        (entry) => createEdge(vertex, entry.key, value: entry.value),
      ) ??
      const [];

  @override
  Edge<V, E>? getEdge(V source, V target) {
    if (adjacency[source]?.outgoing case final targetAdjacency?) {
      if (targetAdjacency[target] case final E value) {
        return createEdge(source, target, value: value);
      }
    }
    return null;
  }

  @override
  Iterable<V> neighboursOf(V vertex) =>
      predecessorsOf(vertex).followedBy(successorsOf(vertex));

  @override
  Iterable<V> predecessorsOf(V vertex) =>
      adjacency[vertex]?.incoming.keys ?? const [];

  @override
  Iterable<V> successorsOf(V vertex) =>
      adjacency[vertex]?.outgoing.keys ?? const [];

  @override
  void addVertex(V vertex) => _getVertex(vertex);

  @override
  void addEdge(V source, V target, {E? value}) {
    _getVertex(source).outgoing[target] = value as E;
    _getVertex(target).incoming[source] = value;
  }

  @override
  void removeVertex(V vertex) {
    final vertexAdjacency = adjacency[vertex];
    if (vertexAdjacency == null) return;
    for (final target in vertexAdjacency.outgoing.keys) {
      adjacency[target]?.incoming.remove(vertex);
    }
    for (final source in vertexAdjacency.incoming.keys) {
      adjacency[source]?.outgoing.remove(vertex);
    }
    adjacency.remove(vertex);
  }

  @override
  void removeEdge(V source, V target, {E? value}) {
    // TODO: check for value
    adjacency[source]?.outgoing.remove(target);
    adjacency[target]?.incoming.remove(source);
  }

  VertexWrapper<V, E> _getVertex(V vertex) =>
      adjacency.putIfAbsent(vertex, () => _createVertex(vertex));

  VertexWrapper<V, E> _createVertex(V vertex) => (
    incoming: vertexStrategy.createMap<E>(),
    outgoing: vertexStrategy.createMap<E>(),
  );
}

/// Record to keep track of incoming and outgoing edges in adjacency [Map].
typedef VertexWrapper<V, E> = ({Map<V, E> incoming, Map<V, E> outgoing});
