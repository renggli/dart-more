import '../path.dart';
import '../traversal.dart';
import 'depth_first.dart';

class TopologicalTraversal<V> extends Traversal<V> {
  TopologicalTraversal({
    super.nextEdges,
    super.nextVertices,
    super.vertexStrategy,
  });

  @override
  Iterable<Path<V>> startAll(Iterable<V> vertices) sync* {
    final predecessors = _createPredecessors(vertices);
    while (predecessors.isNotEmpty) {
      final vertices = <V>[];
      for (final entry in predecessors.entries) {
        if (entry.value.isEmpty) {
          vertices.add(entry.key);
        }
      }
      if (vertices.isEmpty) {
        throw StateError("The graph has cycles.");
      }
      for (var vertex in vertices) {
        yield Path<V>(vertex);
        predecessors.remove(vertex);
        for (var edge in nextEdges(vertex)) {
          final result = predecessors[edge.target];
          if (result != null) {
            result.remove(vertex);
          }
        }
      }
    }
  }

  Map<V, Set<V>> _createPredecessors(Iterable<V> vertices) {
    final result = vertexStrategy.createMap<Set<V>>();
    for (final path in DepthFirstTraversal<V>(
            nextEdges: nextEdges, vertexStrategy: vertexStrategy)
        .startAll(vertices)) {
      final vertex = path.tail;
      result.putIfAbsent(vertex, vertexStrategy.createSet);
      for (var edge in nextEdges(vertex)) {
        result.putIfAbsent(edge.target, vertexStrategy.createSet).add(vertex);
      }
    }
    return result;
  }
}
