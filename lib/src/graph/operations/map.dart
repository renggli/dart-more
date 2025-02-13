import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

extension MapGraphExtension<V, E> on Graph<V, E> {
  /// Creates a new graph by mapping vertices and edges to new values.
  ///
  /// The optional [vertex] function maps vertices of type [V] to type [VR].
  /// The optional [edge] function maps edges of type [E] to type [ER].
  ///
  /// If no [vertex] and [edge] function is provided a copy of the current graph
  /// is returned.
  Graph<VR, ER> map<VR, ER>({
    VR Function(V vertex)? vertex,
    ER? Function(Edge<V, E> edge)? edge,
    StorageStrategy<VR>? vertexStrategy,
  }) {
    final graph =
        isDirected
            ? Graph<VR, ER>.directed(vertexStrategy: vertexStrategy)
            : Graph<VR, ER>.undirected(vertexStrategy: vertexStrategy);
    final vertexMap = <V, VR>{};
    final vertexMapper = vertex ?? (vertex) => vertex as VR;
    for (final oldVertex in vertices) {
      final newVertex = vertexMapper(oldVertex);
      vertexMap[oldVertex] = newVertex;
      graph.addVertex(newVertex);
    }
    final edgeMapper = edge ?? (edge) => edge.value as ER;
    for (final oldVertex in vertices) {
      for (final oldEdge in outgoingEdgesOf(oldVertex)) {
        graph.addEdge(
          vertexMap[oldEdge.source] as VR,
          vertexMap[oldEdge.target] as VR,
          value: edgeMapper(oldEdge),
        );
      }
    }
    return graph;
  }
}
