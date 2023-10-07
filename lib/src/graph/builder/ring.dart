import '../builder.dart';
import '../graph.dart';

extension RingGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] that forms a closed ring.
  Graph<V, E> ring({required int vertexCount}) {
    final factory = newFactory();
    if (vertexCount <= 0) {
      return factory.build();
    }
    factory.addVertexIndex(0);
    for (var i = 1; i < vertexCount; i++) {
      factory.addEdgeIndex(i - 1, i);
    }
    if (vertexCount != 1) {
      factory.addEdgeIndex(vertexCount - 1, 0);
    }
    return factory.build();
  }
}
