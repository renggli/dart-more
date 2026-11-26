import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';

/// Extension on [Graph] to map vertices and edges to new values.
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
    final graph = Graph<VR, ER>(
      isDirected: isDirected,
      vertexStrategy:
          vertexStrategy ??
          (vertex == null && this.vertexStrategy is StorageStrategy<VR>
              ? this.vertexStrategy as StorageStrategy<VR>
              : null),
    );
    final vertexMap = this.vertexStrategy.createMap<VR>();
    final vertexMapper = vertex ?? (vertex) => vertex as VR;
    for (final oldVertex in vertices) {
      final newVertex = vertexMapper(oldVertex);
      vertexMap[oldVertex] = newVertex;
      graph.addVertex(newVertex);
    }
    final edgeMapper = edge ?? (edge) => edge.value as ER;
    final seen = !isDirected ? this.vertexStrategy.createMap<Set<V>>() : null;
    for (final oldVertex in vertices) {
      for (final oldEdge in outgoingEdgesOf(oldVertex)) {
        if (seen != null) {
          if (seen[oldEdge.source]?.contains(oldEdge.target) ?? false) {
            continue;
          }
          seen
              .putIfAbsent(oldEdge.target, this.vertexStrategy.createSet)
              .add(oldEdge.source);
        }
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
