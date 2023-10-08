import '../graph.dart';
import '../library.dart';

/// https://mathworld.wolfram.com/CompleteGraph.html
extension CompleteGraphLibraryExtension<V, E> on GraphLibrary<V, E> {
  /// Creates a complete [Graph] where all vertices are connected with each
  /// other.
  Graph<V, E> complete({required int vertexCount}) {
    final builder = newBuilder();
    for (var i = 0; i < vertexCount; i++) {
      builder.addVertexIndex(i);
    }
    for (var i = 0; i < vertexCount; i++) {
      for (var j = 0; j < vertexCount; j++) {
        if (i != j) {
          builder.addEdgeIndex(i, j);
        }
      }
    }
    return builder.build();
  }
}
