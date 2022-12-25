import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/StarGraph.html
extension AdjacencyGraphBuilder<V, E> on GraphBuilder<V, E> {
  Graph<V, E> adjacency(Map<V, Iterable<V>> input) {
    final graph = Graph<V, E>.directed();
    for (var vertex in input.keys) {
      graph.addVertex(vertex);
    }
    for (var entry in input.entries) {
      for (var target in entry.value) {
        addEdge(graph, entry.key, target);
      }
    }
    return graph;
  }
}
