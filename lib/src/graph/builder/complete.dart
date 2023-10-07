import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/CompleteGraph.html
extension CompleteGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a complete [Graph] where all vertices are connected with each
  /// other.
  Graph<V, E> complete({required int vertexCount}) {
    final factory = newFactory();
    for (var i = 0; i < vertexCount; i++) {
      factory.addVertexIndex(i);
    }
    for (var i = 0; i < vertexCount; i++) {
      for (var j = 0; j < vertexCount; j++) {
        if (i != j) {
          factory.addEdgeIndex(i, j);
        }
      }
    }
    return factory.build();
  }
}
