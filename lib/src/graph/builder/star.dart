import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/StarGraph.html
extension StarGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] that forms a star.
  Graph<V, E> star({required int vertexCount}) {
    final factory = newFactory();
    if (vertexCount <= 0) {
      return factory.build();
    }
    factory.addVertexIndex(0);
    for (var i = 1; i < vertexCount; i++) {
      factory.addEdgeIndex(0, i);
    }
    return factory.build();
  }
}
