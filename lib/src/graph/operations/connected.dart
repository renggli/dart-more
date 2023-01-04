import '../graph.dart';
import '../model/utils.dart';
import '../traverse/breadth_first.dart';

extension ConnectedGraphExtension<V, E> on Graph<V, E> {
  /// Returns an iterable of the connected sub-graphs.
  Iterable<Graph<V, E>> connected() sync* {
    final seen = vertexStrategy.createSet();
    for (var start in vertices) {
      if (seen.add(start)) {
        final graph = copyEmpty(this);
        final traversal = BreadthFirstIterable([start],
            successorsOf: neighboursOf, vertexStrategy: vertexStrategy);
        for (final vertex in traversal) {
          for (final edge in outgoingEdgesOf(vertex)) {
            graph.addEdge(edge.source, edge.target, data: edge.data);
          }
          seen.add(vertex);
        }
        yield graph;
      }
    }
  }
}
