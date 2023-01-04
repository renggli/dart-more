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
      .map((inner) => DirectedEdge<V, E>(outer.key, inner.key, inner.value)));

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      incomingEdgesOf(vertex).followedBy(outgoingEdgesOf(vertex));

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      adjacency[vertex]
          ?.incoming
          .entries
          .map((entry) => DirectedEdge<V, E>(entry.key, vertex, entry.value)) ??
      <Edge<V, E>>[];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      adjacency[vertex]
          ?.outgoing
          .entries
          .map((entry) => DirectedEdge<V, E>(vertex, entry.key, entry.value)) ??
      <Edge<V, E>>[];

  @override
  Iterable<Edge<V, E>> getEdges(V source, V target) {
    final targetAdjacency = adjacency[source]?.outgoing;
    return targetAdjacency != null && targetAdjacency.containsKey(target)
        ? [DirectedEdge<V, E>(source, target, targetAdjacency[target] as E)]
        : [];
  }

  @override
  Iterable<V> neighboursOf(V vertex) => {
        ...predecessorsOf(vertex),
        ...successorsOf(vertex),
      };

  @override
  Iterable<V> predecessorsOf(V vertex) =>
      adjacency[vertex]?.incoming.keys ?? <V>[];

  @override
  Iterable<V> successorsOf(V vertex) =>
      adjacency[vertex]?.outgoing.keys ?? <V>[];

  @override
  void addVertex(V vertex) => _getVertex(vertex);

  @override
  void addEdge(V source, V target, {E? data}) {
    _getVertex(source).outgoing[target] = data as E;
    _getVertex(target).incoming[source] = data;
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
  void removeEdge(V source, V target, {E? data}) {
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

class DirectedEdge<V, E> extends Edge<V, E> {
  DirectedEdge(this.source, this.target, this.data);

  @override
  final V source;

  @override
  final V target;

  @override
  final E data;
}
