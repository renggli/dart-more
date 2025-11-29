import '../../printer/object/object.dart';
import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

/// Undirected graph implementation using an adjacency map.
class UndirectedGraph<V, E> extends Graph<V, E> {
  /// Constructs a undirected graph.
  factory UndirectedGraph.create({StorageStrategy<V>? vertexStrategy}) =>
      UndirectedGraph(
        vertexStrategy: vertexStrategy ?? StorageStrategy<V>.defaultStrategy(),
      );

  UndirectedGraph({required this.vertexStrategy})
    : adjacency = vertexStrategy.createMap<Map<V, E>>();

  final Map<V, Map<V, E>> adjacency;

  @override
  bool get isDirected => false;

  @override
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterable<V> get vertices => adjacency.keys;

  @override
  Iterable<Edge<V, E>> get edges => adjacency.entries.expand(
    (outer) => outer.value.entries.map(
      (inner) => UndirectedEdge<V, E>(outer.key, inner.key, value: inner.value),
    ),
  );

  @override
  Iterable<Edge<V, E>> edgesOf(V vertex) => outgoingEdgesOf(vertex);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      adjacency[vertex]?.entries.map(
        (entry) => UndirectedEdge<V, E>(entry.key, vertex, value: entry.value),
      ) ??
      const [];

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      adjacency[vertex]?.entries.map(
        (entry) => UndirectedEdge<V, E>(vertex, entry.key, value: entry.value),
      ) ??
      const [];

  @override
  Edge<V, E>? getEdge(V source, V target) {
    if (adjacency[source] case final targetAdjacency?) {
      if (targetAdjacency[target] case final E value) {
        return UndirectedEdge<V, E>(source, target, value: value);
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
    adjacency[source]?.remove(target);
    adjacency[target]?.remove(source);
  }

  Map<V, E> _getVertex(V vertex) =>
      adjacency.putIfAbsent(vertex, () => vertexStrategy.createMap<E>());
}

/// Undirected edge implementation.
class UndirectedEdge<V, E> extends Edge<V, E> {
  const UndirectedEdge(super.source, super.target, {super.value});

  @override
  bool get isDirected => false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UndirectedEdge &&
          ((source == other.source && target == other.target) ||
              (source == other.target && target == other.source)));

  @override
  int get hashCode => source.hashCode ^ target.hashCode;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue('$source — $target')
    ..addValue(value, name: 'value', omitNull: true);
}
