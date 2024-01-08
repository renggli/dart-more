import '../edge.dart';
import '../graph.dart';
import 'where_edge.dart';
import 'where_vertex.dart';

extension WhereGraphExtension<V, E> on Graph<V, E> {
  /// Returns a new lazy [Graph] with all vertices that satisfy the
  /// [vertexPredicate] and all edges that satisfy the [edgePredicate].
  Graph<V, E> where({
    bool Function(V vertex)? vertexPredicate,
    bool Function(Edge<V, E> edge)? edgePredicate,
  }) {
    var graph = this;
    if (vertexPredicate != null) {
      graph = WhereVertexGraph<V, E>(graph, vertexPredicate);
    }
    if (edgePredicate != null) {
      graph = WhereEdgeGraph<V, E>(graph, edgePredicate);
    }
    return graph;
  }
}
