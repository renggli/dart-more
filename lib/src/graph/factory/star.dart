import '../factory.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/StarGraph.html
extension StarGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates a [Graph] that forms a star.
  Graph<V, E> star({required int vertexCount}) {
    final builder = newBuilder();
    if (vertexCount <= 0) {
      return builder.build();
    }
    builder.addVertexIndex(0);
    for (var i = 1; i < vertexCount; i++) {
      builder.addEdgeIndex(0, i);
    }
    return builder.build();
  }
}
