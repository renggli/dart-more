import 'package:collection/collection.dart' show PriorityQueue;

import '../../comparator/constructors/natural.dart';
import '../../comparator/modifiers/key_of.dart';
import '../../functional/types/constant.dart';
import '../edge.dart';
import '../strategy.dart';

/// Prim's algorithm to find the spanning tree starting at [startVertex] in
/// _O(E*log(V))_.
///
/// See https://en.wikipedia.org/wiki/Prim%27s_algorithm.
List<Edge<V, E>> primSpanningTree<V, E>({
  required V startVertex,
  required Iterable<Edge<V, E>> Function(V vertex) outgoingEdgesOf,
  num Function(V source, V target)? edgeWeight,
  Comparator<num>? weightComparator,
  StorageStrategy<V>? vertexStrategy,
}) {
  final weightOf = edgeWeight ?? constantFunction2(1);
  final comparator = weightComparator ?? naturalComparable<num>;
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final visited = vertexStrategy.createSet();
  final result = <Edge<V, E>>[];
  final queue = PriorityQueue<({Edge<V, E> edge, num cost})>(
    comparator.keyOf((state) => state.cost),
  );
  void addOutgoingEdgesToQueue(V vertex) {
    visited.add(vertex);
    for (final edge in outgoingEdgesOf(vertex)) {
      if (!visited.contains(edge.target)) {
        queue.add((edge: edge, cost: weightOf(edge.source, edge.target)));
      }
    }
  }

  addOutgoingEdgesToQueue(startVertex);
  while (queue.isNotEmpty) {
    final (:edge, :cost) = queue.removeFirst();
    if (!visited.contains(edge.target)) {
      result.add(edge);
      addOutgoingEdgesToQueue(edge.target);
    }
  }
  return result;
}
