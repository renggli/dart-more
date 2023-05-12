import '../builder.dart';
import '../graph.dart';
import 'empty.dart';

/// https://mathworld.wolfram.com/StarGraph.html
extension StarGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] that forms a star.
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
