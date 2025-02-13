import '../graph.dart';
import '../traverse/breadth_first.dart';
import 'copy.dart';

extension ConnectedGraphExtension<V, E> on Graph<V, E> {
  /// Returns an iterable of the connected sub-graphs.
  Iterable<Graph<V, E>> connected() sync* {
    final seen = vertexStrategy.createSet();
    for (final start in vertices) {
      if (seen.add(start)) {
        final graph = copy(empty: true);
        final traversal = BreadthFirstIterable(
          [start],
          successorsOf: neighboursOf,
          vertexStrategy: vertexStrategy,
        );
        for (final vertex in traversal) {
          for (final edge in outgoingEdgesOf(vertex)) {
            graph.addEdge(edge.source, edge.target, value: edge.value);
          }
          seen.add(vertex);
        }
        yield graph;
      }
    }
  }
}
