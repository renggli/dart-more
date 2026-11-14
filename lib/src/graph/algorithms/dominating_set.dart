import '../strategy.dart';

/// Computes a dominating set using a greedy approximation heuristic.
///
/// A dominating set for a graph is a set of vertices `D` such that every vertex
/// not in `D` is adjacent to at least one vertex in `D`.
///
/// See https://en.wikipedia.org/wiki/Dominating_set.
Set<V> dominatingSet<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final uncovered = vertexStrategy.createSet()..addAll(vertices);
  final dominating = vertexStrategy.createSet();

  final closedNeighbors = vertexStrategy.createMap<Set<V>>();
  for (final v in vertices) {
    final cn = vertexStrategy.createSet()..add(v);
    cn.addAll(neighboursOf(v));
    closedNeighbors[v] = cn;
  }

  while (uncovered.isNotEmpty) {
    V? bestVertex;
    var maxCoverage = -1;

    for (final v in vertices) {
      final cn = closedNeighbors[v]!;
      var coverage = 0;
      for (final u in cn) {
        if (uncovered.contains(u)) coverage++;
      }
      if (coverage > maxCoverage) {
        maxCoverage = coverage;
        bestVertex = v;
      }
    }

    if (bestVertex == null || maxCoverage <= 0) {
      dominating.addAll(uncovered);
      break;
    }

    dominating.add(bestVertex);
    uncovered.removeAll(closedNeighbors[bestVertex]!);
  }

  return dominating;
}
