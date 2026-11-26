import 'package:collection/collection.dart';

import '../../collection/disjointset.dart';
import '../../comparator/constructors/natural.dart';
import '../../functional/types/constant.dart';
import '../edge.dart';
import '../strategy.dart';

/// Kruskal's algorithm to find a minimum spanning forest in _O(E*log(E))_.
///
/// See https://en.wikipedia.org/wiki/Kruskal%27s_algorithm.
List<Edge<V, E>> kruskalSpanningTree<V, E>({
  required Iterable<V> vertices,
  required Iterable<Edge<V, E>> edges,
  num Function(V source, V target)? edgeWeight,
  Comparator<num>? weightComparator,
  StorageStrategy<V>? vertexStrategy,
}) {
  final weightOf = edgeWeight ?? constantFunction2(1);
  final comparator = weightComparator ?? naturalComparable<num>;
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final sortedEdges = edges.toList(growable: false);
  if (sortedEdges.isEmpty) return <Edge<V, E>>[];
  sortedEdges.sortByCompare(
    (edge) => weightOf(edge.source, edge.target),
    comparator,
  );
  final disjointSet = DisjointSet<V>(
    vertices,
    nodes: vertexStrategy.createMap<DisjointSetNode<V>>(),
  );
  final result = <Edge<V, E>>[];
  for (final edge in sortedEdges) {
    if (disjointSet.union(edge.source, edge.target)) {
      result.add(edge);
    }
  }
  return result;
}
