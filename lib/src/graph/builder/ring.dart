import '../builder.dart';
import '../graph.dart';
import 'empty.dart';

extension RingGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] that forms a closed ring.
  Graph<V, E> ring({required int vertexCount}) {
    final graph = empty();
    if (vertexCount <= 0) {
      return graph;
    }
    addVertexIndex(graph, 0);
    for (var i = 1; i < vertexCount; i++) {
      addEdgeIndex(graph, i - 1, i);
    }
    if (vertexCount != 1) {
      addEdgeIndex(graph, vertexCount - 1, 0);
    }
    return graph;
  }
}
