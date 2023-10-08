import '../graph.dart';
import '../library.dart';

extension RingGraphLibraryExtension<V, E> on GraphLibrary<V, E> {
  /// Creates a [Graph] that forms a closed ring.
  Graph<V, E> ring({required int vertexCount}) {
    final builder = newBuilder();
    if (vertexCount <= 0) {
      return builder.build();
    }
    builder.addVertexIndex(0);
    for (var i = 1; i < vertexCount; i++) {
      builder.addEdgeIndex(i - 1, i);
    }
    if (vertexCount != 1) {
      builder.addEdgeIndex(vertexCount - 1, 0);
    }
    return builder.build();
  }
}
