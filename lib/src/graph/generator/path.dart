import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/PathGraph.html
extension PathGraphBuilder<V, E> on GraphBuilder<V, E> {
  Graph<V, E> path({required int vertexCount}) {
    final graph = empty();
    if (vertexCount <= 0) {
      return graph;
    }
    addVertexIndex(graph, 0);
    for (var i = 1; i < vertexCount; i++) {
      addEdgeIndex(graph, i - 1, i);
    }
    return graph;
  }
}
