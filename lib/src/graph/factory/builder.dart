import '../factory.dart';
import '../graph.dart';
import '../model/unmodifiable.dart';

/// Internal builder of graphs based on the configuration from [GraphFactory].
class GraphBuilder<V, E> {
  /// Constructs a graph builder.
  GraphBuilder(this.factory)
    : graph = Graph<V, E>(
        isDirected: factory.isDirected,
        vertexStrategy: factory.vertexStrategy,
      );

  /// The underlying factory with the shared configuration.
  final GraphFactory<V, E> factory;

  /// The graph being built.
  final Graph<V, E> graph;

  /// Adds a [vertex] to this graph.
  void addVertex(V vertex) => graph.addVertex(vertex);

  /// Adds a vertex with a generated [index] to this graph.
  void addVertexIndex(int index) =>
      addVertex(factory.vertexProvider?.call(index) ?? (index as V));

  /// Adds an edge between [source] and [target] vertex. Optionally associates
  /// the provided [value] with the edge.
  void addEdge(V source, V target, {E? value}) => graph.addEdge(
    source,
    target,
    value: value ?? factory.edgeProvider?.call(source, target),
  );

  /// Adds an edge between [source] and [target] index.  Optionally associates
  /// the provided [value] with the edge.
  void addEdgeIndex(int source, int target, {E? value}) => addEdge(
    factory.vertexProvider?.call(source) ?? (source as V),
    factory.vertexProvider?.call(target) ?? (target as V),
    value: value,
  );

  /// Completes the final configured graph object.
  Graph<V, E> build() => factory.isUnmodifiable ? graph.unmodifiable : graph;
}
