import 'package:meta/meta.dart';

import '../../graph.dart';

typedef VertexProvider<V> = V Function(int index);
typedef EdgeProvider<V, E> = E Function(V source, V target);

class GraphBuilder<V, E> {
  GraphBuilder({
    this.isDirected = true,
    this.vertexProvider,
    this.edgeProvider,
  });

  final bool isDirected;
  final VertexProvider<V>? vertexProvider;
  final EdgeProvider<V, E>? edgeProvider;

  Graph<V, E> empty() =>
      isDirected ? Graph<V, E>.directed() : Graph<V, E>.undirected();

  @internal
  void addVertex(Graph<V, E> graph, V vertex) => graph.addVertex(vertex);

  @internal
  void addVertexIndex(Graph<V, E> graph, int index) => addVertex(
        graph,
        vertexProvider?.call(index) ?? (index as V),
      );

  @internal
  void addEdge(Graph<V, E> graph, V source, V target, {E? data}) =>
      graph.addEdge(
        source,
        target,
        data: data ?? edgeProvider?.call(source, target),
      );

  @internal
  void addEdgeIndex(Graph<V, E> graph, int source, int target, {E? data}) =>
      addEdge(
        graph,
        vertexProvider?.call(source) ?? (source as V),
        vertexProvider?.call(target) ?? (target as V),
        data: data,
      );
}
