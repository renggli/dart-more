import '../edge.dart';
import '../graph.dart';

extension MapGraphExtension<V, E> on Graph<V, E> {
  /// Creates a new graph by mapping vertices and edges to new values.
  ///
  /// The optional `vertex` function maps vertices of type [V] to type [VE].
  /// The optional `edge` function maps edges of type [E] to type [ER].
  Graph<VR, ER> map<VR, ER>({
    VR Function(V vertex)? vertex,
    ER? Function(Edge<V, E> edge)? edge,
  }) {
    final graph =
        isDirected ? Graph<VR, ER>.directed() : Graph<VR, ER>.undirected();
    final vertexMap = <V, VR>{};
    final vertexMapper = vertex ?? (vertex) => vertex as VR;
    for (final oldVertex in vertices) {
      final newVertex = vertexMapper(oldVertex);
      vertexMap[oldVertex] = newVertex;
      graph.addVertex(newVertex);
    }
    final edgeMapper = edge ?? (edge) => edge.data as ER;
    for (final oldVertex in vertices) {
      for (final oldEdge in outgoingEdgesOf(oldVertex)) {
        graph.addEdge(
          vertexMap[oldEdge.source] as VR,
          vertexMap[oldEdge.target] as VR,
          data: edgeMapper(oldEdge),
        );
      }
    }
    return graph;
  }
}
