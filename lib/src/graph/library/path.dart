import '../graph.dart';
import '../library.dart';

/// https://mathworld.wolfram.com/PathGraph.html
extension PathGraphLibraryExtension<V, E> on GraphLibrary<V, E> {
  /// Creates a [Graph] that forms a linear path.
  Graph<V, E> path({required int vertexCount}) {
    final builder = newBuilder();
    if (vertexCount <= 0) {
      return builder.build();
    }
    builder.addVertexIndex(0);
    for (var i = 1; i < vertexCount; i++) {
      builder.addEdgeIndex(i - 1, i);
    }
    return builder.build();
  }
}
