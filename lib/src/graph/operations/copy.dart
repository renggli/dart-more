import '../graph.dart';

extension CopyGraphExtension<V, E> on Graph<V, E> {
  /// Creates a copy of this graph.
  ///
  /// If [empty] is set to true, returns a new graph of the same
  /// type without the vertices and edges.
  Graph<V, E> copy({bool empty = false}) {
    final result = isDirected
        ? Graph<V, E>.directed(vertexStrategy: vertexStrategy)
        : Graph<V, E>.undirected(vertexStrategy: vertexStrategy);
    if (!empty) {
      for (final vertex in vertices) {
        result.addVertex(vertex);
        for (final edge in outgoingEdgesOf(vertex)) {
          result.addEdge(edge.source, edge.target, value: edge.value);
        }
      }
    }
    return result;
  }
}
