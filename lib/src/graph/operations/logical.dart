import '../graph.dart';
import '../model/utils.dart';

extension LogicalGraphExtension<V, E> on Graph<V, E> {
  /// Returns the union of this graph and [other]. This is a graph with the
  /// nodes and edges present in either of the two graphs.
  Graph<V, E> union(Graph<V, E> other) {
    final result = copyEmpty<V, E>(this);
    for (final graph in [this, other]) {
      // Create all vertices present in any graph.
      for (final vertex in graph.vertices) {
        result.addVertex(vertex);
      }
      // Create all edges present in any graph, but avoid duplicates.
      for (final vertex in graph.vertices) {
        for (final edge in graph.outgoingEdgesOf(vertex)) {
          if (result
              .getEdges(edge.source, edge.target)
              .where((each) => edge.dataOrNull == each.dataOrNull)
              .isEmpty) {
            result.addEdge(edge.source, edge.target, data: edge.dataOrNull);
          }
        }
      }
    }
    return result;
  }

  /// Returns the intersection of this graph and [other]. This is a graph with
  /// the nodes and edges present in both graphs.
  Graph<V, E> intersection(Graph<V, E> other) {
    final result = copyEmpty<V, E>(this);
    // Create all the vertices present in both graphs.
    for (final vertex in vertices) {
      if (other.vertices.contains(vertex)) {
        result.addVertex(vertex);
      }
    }
    // Create all edges that have vertices present in the result, and edges
    // in both graphs.
    for (final edge in edges) {
      if (result.vertices.contains(edge.source) &&
          result.vertices.contains(edge.target) &&
          other
              .getEdges(edge.source, edge.target)
              .where((each) => edge.dataOrNull == each.dataOrNull)
              .isNotEmpty) {
        result.addEdge(edge.source, edge.target, data: edge.dataOrNull);
      }
    }
    return result;
  }
}
