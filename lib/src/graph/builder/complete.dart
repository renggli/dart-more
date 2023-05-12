import '../builder.dart';
import '../graph.dart';
import 'empty.dart';

/// https://mathworld.wolfram.com/CompleteGraph.html
extension CompleteGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a complete [Graph] where all vertices are connected with each
  /// other.
  Graph<V, E> complete({required int vertexCount}) {
    final graph = empty();
    for (var i = 0; i < vertexCount; i++) {
      addVertexIndex(graph, i);
    }
    for (var i = 0; i < vertexCount; i++) {
      for (var j = 0; j < vertexCount; j++) {
        if (i != j) {
          addEdgeIndex(graph, i, j);
        }
      }
    }
    return graph;
  }
}
