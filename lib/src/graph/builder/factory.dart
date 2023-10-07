import '../builder.dart';
import '../graph.dart';
import '../model/unmodifiable.dart';

class GraphFactory<V, E> {
  GraphFactory(this.builder) : graph = create<V, E>(builder);

  final GraphBuilder<V, E> builder;
  final Graph<V, E> graph;

  /// Adds a [vertex] to this graph.
  void addVertex(V vertex) => graph.addVertex(vertex);

  void addVertexIndex(int index) =>
      addVertex(builder.vertexProvider?.call(index) ?? (index as V));

  /// Adds an edge between [source] and [target] vertex. Optionally
  /// associates the provided [data] with the edge.
  void addEdge(V source, V target, {E? data}) => graph.addEdge(source, target,
      data: data ?? builder.edgeProvider?.call(source, target));

  void addEdgeIndex(int source, int target, {E? data}) => addEdge(
      builder.vertexProvider?.call(source) ?? (source as V),
      builder.vertexProvider?.call(target) ?? (target as V),
      data: data);

  static Graph<V, E> create<V, E>(GraphBuilder<V, E> builder) =>
      builder.isDirected
          ? Graph<V, E>.directed(vertexStrategy: builder.vertexStrategy)
          : Graph<V, E>.undirected(vertexStrategy: builder.vertexStrategy);

  Graph<V, E> build() => builder.isUnmodifiable ? graph.unmodifiable : graph;
}
