import 'package:collection/collection.dart' show PriorityQueue;

import '../../comparator/modifiers/key_of.dart';
import '../edge.dart';
import '../graph.dart';
import '../operations/copy.dart';
import '../strategy.dart';

/// Prim's algorithm to find the spanning tree in _O(E*log(V))_.
///
/// See https://en.wikipedia.org/wiki/Prim%27s_algorithm.
Graph<V, E> primSpanningTree<V, E>(
  Graph<V, E> graph, {
  required V? startVertex,
  required num Function(V source, V target) edgeWeight,
  required Comparator<num> weightComparator,
  required StorageStrategy<V> vertexStrategy,
}) {
  // Create an empty copy of the graph.
  final result = graph.copy(empty: true);
  // Queue for the shortest remaining edges.
  final queue = PriorityQueue<({Edge<V, E> edge, num cost})>(
    weightComparator.keyOf((state) => state.cost),
  );
  void addOutgoingEdgesToQueue(V vertex) {
    result.addVertex(vertex);
    for (final edge in graph.outgoingEdgesOf(vertex)) {
      if (!result.vertices.contains(edge.target)) {
        queue.add((edge: edge, cost: edgeWeight(edge.source, edge.target)));
      }
    }
  }

  // Prepare the initial outgoing edges.
  addOutgoingEdgesToQueue(startVertex ?? graph.vertices.first);
  // Pick the shortest edge that connects to a not yet connected vertex.
  while (queue.isNotEmpty) {
    final (:edge, :cost) = queue.removeFirst();
    if (!result.vertices.contains(edge.target)) {
      result.addEdge(edge.source, edge.target, value: edge.value);
      addOutgoingEdgesToQueue(edge.target);
    }
  }
  return result;
}
