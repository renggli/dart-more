import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/PathGraph.html
extension PathGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] that forms a linear path.
  Graph<V, E> path({required int vertexCount}) {
    final factory = newFactory();
    if (vertexCount <= 0) {
      return factory.build();
    }
    factory.addVertexIndex(0);
    for (var i = 1; i < vertexCount; i++) {
      factory.addEdgeIndex(i - 1, i);
    }
    return factory.build();
  }
}
