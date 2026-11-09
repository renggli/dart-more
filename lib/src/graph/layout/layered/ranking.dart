import 'dart:math' as math;

import '../../traverse/topological.dart';

/// Algorithm used for layer/rank assignment.
enum RankingAlgorithm {
  /// Longest-path ranking (default, fast).
  longestPath,

  /// Longest-path ranking followed by a heuristic pass that moves vertices
  /// towards their successors to shorten edges (not a full network simplex).
  tightened,
}

/// Assigns integer ranks to all vertices in [vertices] such that $\text{rank}(v) \ge \text{rank}(u) + 1$ for all edges $(u, v)$.
Map<V, int> assignRanks<V>(
  Iterable<V> vertices,
  Map<V, List<V>> dagSuccessors, {
  RankingAlgorithm algorithm = RankingAlgorithm.longestPath,
}) {
  final allVertices = vertices.toList();
  if (allVertices.isEmpty) return const {};

  final inDegree = <V, int>{for (final v in allVertices) v: 0};
  final predecessors = <V, List<V>>{for (final v in allVertices) v: []};

  for (final u in allVertices) {
    final succs = dagSuccessors[u];
    if (succs != null) {
      for (final v in succs) {
        inDegree[v] = (inDegree[v] ?? 0) + 1;
        predecessors[v]!.add(u);
      }
    }
  }

  final rank = <V, int>{for (final v in allVertices) v: 0};
  final order = TopologicalIterable<V>(
    allVertices,
    predecessorsOf: (v) => predecessors[v] ?? const [],
    successorsOf: (v) => dagSuccessors[v] ?? const [],
  );
  for (final u in order) {
    final next = rank[u]! + 1;
    for (final v in dagSuccessors[u] ?? <V>[]) {
      if (next > rank[v]!) rank[v] = next;
    }
  }

  if (algorithm == RankingAlgorithm.tightened && allVertices.length > 2) {
    _optimizeNetworkSimplex(allVertices, dagSuccessors, predecessors, rank);
  }

  // Normalize ranks to start at 0
  final minRank = rank.values.reduce(math.min);
  if (minRank != 0) {
    for (final v in allVertices) {
      rank[v] = rank[v]! - minRank;
    }
  }

  return rank;
}

void _optimizeNetworkSimplex<V>(
  List<V> vertices,
  Map<V, List<V>> successors,
  Map<V, List<V>> predecessors,
  Map<V, int> rank,
) {
  // Push vertices downward towards their successors if that reduces total slack
  var improved = true;
  var iterations = 0;
  while (improved && iterations < 10) {
    improved = false;
    iterations++;

    for (final u in vertices) {
      final succs = successors[u];
      if (succs == null || succs.isEmpty) continue;

      var minSuccRank = 0x7fffffff;
      for (final v in succs) {
        final r = rank[v]!;
        if (r < minSuccRank) minSuccRank = r;
      }

      final maxAllowedRank = minSuccRank - 1;
      if (maxAllowedRank > rank[u]!) {
        // Check if pushing u down reduces sum of slacks
        final preds = predecessors[u] ?? const [];
        if (preds.length <= succs.length) {
          rank[u] = maxAllowedRank;
          improved = true;
        }
      }
    }
  }
}
