import '../../collection/iterable/combinations.dart';
import '../../collection/iterable/permutations.dart';
import '../../collection/range/integer.dart';
import '../factory.dart';
import '../graph.dart';
import 'complete.dart';

/// Creates random graphs using different models.
extension RandomGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Generates a graph using the Erdős–Rényi model with [vertexCount] vertices
  /// and a constant [probability] of creating an edge between any pair of
  /// vertices.
  ///
  /// See https://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93R%C3%A9nyi_model.
  Graph<V, E> randomErdosRenyi({
    required int vertexCount,
    required double probability,
  }) {
    if (probability >= 1) {
      return complete(vertexCount: vertexCount);
    }
    final builder = newBuilder();
    for (var i = 0; i < vertexCount; i++) {
      builder.addVertexIndex(i);
    }
    if (probability > 0) {
      final edges = isDirected
          ? IntegerRange.length(vertexCount).permutations(2)
          : IntegerRange.length(vertexCount).combinations(2);
      for (final edge in edges) {
        if (random.nextDouble() < probability) {
          builder.addEdgeIndex(edge[0], edge[1]);
        }
      }
    }
    return builder.build();
  }
}
