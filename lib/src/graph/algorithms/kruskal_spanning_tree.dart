import 'package:collection/collection.dart';

import '../../collection/disjointset.dart';
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
  // Disjoint set for cycle detection.
  final disjointSet = DisjointSet<V>(
    graph.vertices,
    nodes: vertexStrategy.createMap<DisjointSetNode<V>>(),
  );
  // Process all the edges.
  for (final edge in edges) {
    if (disjointSet.union(edge.source, edge.target)) {
      result.addEdge(edge.source, edge.target, value: edge.value);
    }
  }
  return result;
}
