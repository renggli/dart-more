import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/StarGraph.html
extension StarGraphBuilder<V, E> on GraphBuilder<V, E> {
  Graph<V, E> star({required int vertexCount}) {
    final graph = empty();
    if (vertexCount <= 0) {
      return graph;
    }
    addVertexIndex(graph, 0);
    for (var i = 1; i < vertexCount; i++) {
      addEdgeIndex(graph, 0, i);
    }
    return graph;
  }
}
