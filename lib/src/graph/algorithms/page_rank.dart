import '../strategy.dart';

/// Computes the PageRank of [vertices] using power iteration.
///
/// - [damping] is the probability of following an edge rather than teleporting (default: 0.85).
/// - [tolerance] is the convergence threshold for $L_1$ norm (default: 1e-6).
/// - [maxIterations] is the maximum number of iterations (default: 100).
Map<V, double> pageRank<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex)? predecessorsOf,
  double damping = 0.85,
  double tolerance = 1e-6,
  int maxIterations = 100,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;

  final rank = vertexStrategy.createMap<double>();
  if (n == 0) return rank;
  if (n == 1) {
    rank[vertexList.first] = 1.0;
    return rank;
  }

  final initialScore = 1.0 / n;
  for (final v in vertexList) {
    rank[v] = initialScore;
  }

  // Precompute out-degrees and predecessors
  final outDegrees = vertexStrategy.createMap<int>();
  final predecessorMap = vertexStrategy.createMap<List<V>>();

  if (predecessorsOf != null) {
    for (final v in vertexList) {
      final succ = successorsOf(v);
      outDegrees[v] = succ is List ? succ.length : succ.toList().length;
      predecessorMap[v] = predecessorsOf(v).toList(growable: false);
    }
  } else {
    for (final v in vertexList) {
      predecessorMap[v] = <V>[];
    }
    for (final v in vertexList) {
      final succ = successorsOf(v).toList(growable: false);
      outDegrees[v] = succ.length;
      for (final w in succ) {
        if (predecessorMap.containsKey(w)) {
          predecessorMap[w]!.add(v);
        }
      }
    }
  }

  final base = (1.0 - damping) / n;

  for (var iter = 0; iter < maxIterations; iter++) {
    // Collect dangling node score sum
    var danglingSum = 0.0;
    for (final v in vertexList) {
      if (outDegrees[v] == 0) {
        danglingSum += rank[v]!;
      }
    }

    final danglingContribution = damping * danglingSum / n;
    final nextRank = vertexStrategy.createMap<double>();
    var change = 0.0;

    for (final v in vertexList) {
      var incomingSum = 0.0;
      for (final u in predecessorMap[v]!) {
        incomingSum += rank[u]! / outDegrees[u]!;
      }
      final newScore = base + danglingContribution + damping * incomingSum;
      nextRank[v] = newScore;
      change += (newScore - rank[v]!).abs();
    }

    for (final v in vertexList) {
      rank[v] = nextRank[v]!;
    }

    if (change < tolerance) break;
  }

  return rank;
}
