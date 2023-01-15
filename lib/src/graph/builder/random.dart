import '../../../collection.dart';
import '../builder.dart';
import '../graph.dart';
import 'complete.dart';

/// Creates random graphs using different models.
extension RandomGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Generates a graph using the Erdős–Rényi model with [vertexCount] vertices
  /// and a constant [probability] of creating an edge between any pair of
  /// vertices.
  ///
  /// See https://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93R%C3%A9nyi_model.
  Graph<V, E> randomErdosRenyi(
      {required int vertexCount, required double probability}) {
    if (probability <= 0) {
      return empty();
    } else if (probability >= 1) {
      return complete(vertexCount: vertexCount);
    }
    final graph = empty();
    for (var i = 0; i < vertexCount; i++) {
      addVertexIndex(graph, i);
    }
    final edges = isDirected
        ? IntegerRange(vertexCount).permutations(2)
        : IntegerRange(vertexCount).combinations(2);
    for (var edge in edges) {
      if (random.nextDouble() < probability) {
        addEdgeIndex(graph, edge[0], edge[1]);
      }
    }
    return graph;
  }
}