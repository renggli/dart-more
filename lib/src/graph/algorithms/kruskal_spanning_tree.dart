import 'package:collection/collection.dart';

import '../graph.dart';
import '../operations/copy.dart';
import '../strategy.dart';

/// Kruskal's algorithm to find the spanning tree in _O(E*log(E))_.
///
/// See https://en.wikipedia.org/wiki/Kruskal%27s_algorithm.
Graph<V, E> kruskalSpanningTree<V, E>(
  Graph<V, E> graph, {
  required num Function(V source, V target) edgeWeight,
  required Comparator<num> weightComparator,
  required StorageStrategy<V> vertexStrategy,
}) {
  // Create an empty copy of the graph.
  final result = graph.copy(empty: true);
  result.addVertices(graph.vertices);

  // Fetch and sort the edges, if any.
  final edges = graph.edges.toList(growable: false);
  if (edges.isEmpty) return result;
  edges.sortByCompare(
    (value) => edgeWeight(value.source, value.target),
    weightComparator,
  );

  // State for each vertex.
  final states = vertexStrategy.createMap<_State<V>>();
  _State<V> getState(V vertex) =>
      states.putIfAbsent(vertex, () => _State(vertex));

  // Process all the edges.
  for (final edge in edges) {
    final source = getState(edge.source);
    final target = getState(edge.target);
    if (source.vertex != target.vertex) {
      if (source.rank < target.rank) {
        states[source.vertex] = target;
      } else if (target.rank < source.rank) {
        states[target.vertex] = source;
      } else {
        states[target.vertex] = source;
        source.rank++;
      }
      result.addEdge(edge.source, edge.target, value: edge.value);
    }
  }

  return result;
}

final class _State<V> {
  _State(this.vertex);

  final V vertex;
  int rank = 0;
}
