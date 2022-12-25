import '../edge.dart';
import '../graph.dart';

extension MapGraphExtension<V, E> on Graph<V, E> {
  /// Creates a new graph by mapping vertices and edges to new values.
  ///
  /// The optional `vertex` function maps an edge
  Graph<VR, ER> map<VR, ER>({
    VR Function(V vertex)? vertex,
    ER Function(Edge<V, E> edge)? edge,
  }) {
    final graph =
        isDirected ? Graph<VR, ER>.directed() : Graph<VR, ER>.undirected();
    final vertexMap = <V, VR>{};
    for (final oldVertex in vertices) {
      final newVertex = vertex != null ? vertex(oldVertex) : oldVertex as VR;
      vertexMap[oldVertex] = newVertex;
      graph.addVertex(newVertex);
    }
    for (final oldVertex in vertices) {
      for (final oldEdge in outgoingEdgesOf(oldVertex)) {
        final newEdge = edge != null
            ? edge(oldEdge)
            : oldEdge.dataOrNull is ER
                ? oldEdge.dataOrNull as ER
                : null;
        graph.addEdge(
          vertexMap[oldEdge.source] as VR,
          vertexMap[oldEdge.target] as VR,
          data: newEdge,
        );
      }
    }
    return graph;
  }
}
