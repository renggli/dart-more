import '../factory.dart';
import '../graph.dart';
import '../model/unmodifiable.dart';

class GraphBuilder<V, E> {
  GraphBuilder(this.library) : graph = create<V, E>(library);

  final GraphFactory<V, E> library;
  final Graph<V, E> graph;

  /// Adds a [vertex] to this graph.
  void addVertex(V vertex) => graph.addVertex(vertex);

  void addVertexIndex(int index) =>
      addVertex(library.vertexProvider?.call(index) ?? (index as V));

  /// Adds an edge between [source] and [target] vertex. Optionally
  /// associates the provided [data] with the edge.
  void addEdge(V source, V target, {E? data}) => graph.addEdge(source, target,
      data: data ?? library.edgeProvider?.call(source, target));

  void addEdgeIndex(int source, int target, {E? data}) => addEdge(
      library.vertexProvider?.call(source) ?? (source as V),
      library.vertexProvider?.call(target) ?? (target as V),
      data: data);

  static Graph<V, E> create<V, E>(GraphFactory<V, E> builder) =>
      builder.isDirected
          ? Graph<V, E>.directed(vertexStrategy: builder.vertexStrategy)
          : Graph<V, E>.undirected(vertexStrategy: builder.vertexStrategy);

  Graph<V, E> build() => library.isUnmodifiable ? graph.unmodifiable : graph;
}
