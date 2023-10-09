import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

class DirectedGraph<V, E> extends Graph<V, E> {
  DirectedGraph({StorageStrategy<V>? vertexStrategy})
      : this._(vertexStrategy ?? StorageStrategy<V>.defaultStrategy());

  DirectedGraph._(this.vertexStrategy)
      : adjacency = vertexStrategy.createMap<VertexWrapper<V, E>>();

  final Map<V, VertexWrapper<V, E>> adjacency;

  @override
  final StorageStrategy<V> vertexStrategy;

  @override
  bool get isDirected => true;

  @override
  Iterable<V> get vertices => adjacency.keys;

  @override
  Iterable<Edge<V, E>> get edges => adjacency.entries.expand((outer) => outer
      .value.outgoing.entries
      .map((inner) => Edge<V, E>(outer.key, inner.key, value: inner.value)));

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      incomingEdgesOf(vertex).followedBy(outgoingEdgesOf(vertex));

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      adjacency[vertex]
          ?.incoming
          .entries
          .map((entry) => Edge<V, E>(entry.key, vertex, value: entry.value)) ??
      const [];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      adjacency[vertex]
          ?.outgoing
          .entries
          .map((entry) => Edge<V, E>(vertex, entry.key, value: entry.value)) ??
      const [];

  @override
  Edge<V, E>? getEdge(V source, V target) {
    if (adjacency[source]?.outgoing case final targetAdjacency?) {
      if (targetAdjacency[target] case final E value) {
        return Edge<V, E>(source, target, value: value);
      }
    }
    return null;
  }

  @override
  Iterable<V> neighboursOf(V vertex) => {
        ...predecessorsOf(vertex),
        ...successorsOf(vertex),
      };

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
  void removeEdge(V source, V target) {
    adjacency[source]?.outgoing.remove(target);
    adjacency[target]?.incoming.remove(source);
  }

  VertexWrapper<V, E> _getVertex(V vertex) => adjacency.putIfAbsent(
      vertex,
      () => VertexWrapper<V, E>(
          vertexStrategy.createMap<E>(), vertexStrategy.createMap<E>()));
}

class VertexWrapper<V, E> {
  VertexWrapper(this.incoming, this.outgoing);

  final Map<V, E> incoming;

  final Map<V, E> outgoing;
}
