import '../graph.dart';
import '../strategy.dart';

/// Computes the PageRank of vertices in [graph] using power iteration.
///
/// - [damping] is the probability of following an edge rather than teleporting (default: 0.85).
/// - [tolerance] is the convergence threshold for $L_1$ norm (default: 1e-6).
/// - [maxIterations] is the maximum number of iterations (default: 100).
Map<V, double> pageRank<V, E>(
  Graph<V, E> graph, {
  double damping = 0.85,
  double tolerance = 1e-6,
  int maxIterations = 100,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= graph.vertexStrategy;
  final vertices = graph.vertices.toList(growable: false);
  final n = vertices.length;

  final rank = vertexStrategy.createMap<double>();
  if (n == 0) return rank;
  if (n == 1) {
    rank[vertices.first] = 1.0;
    return rank;
  }

  final initialScore = 1.0 / n;
  for (final v in vertices) {
    rank[v] = initialScore;
  }

  // Precompute out-degrees and predecessors
  final outDegrees = vertexStrategy.createMap<int>();
  final predecessors = vertexStrategy.createMap<List<V>>();
  for (final v in vertices) {
    outDegrees[v] = graph.outDegreeOf(v);
    predecessors[v] = graph.predecessorsOf(v).toList(growable: false);
  }

  final base = (1.0 - damping) / n;

  for (var iter = 0; iter < maxIterations; iter++) {
    // Collect dangling node score sum
    var danglingSum = 0.0;
    for (final v in vertices) {
      if (outDegrees[v] == 0) {
        danglingSum += rank[v]!;
      }
    }

    final danglingContribution = damping * danglingSum / n;
    final nextRank = vertexStrategy.createMap<double>();
    var change = 0.0;

    for (final v in vertices) {
      var incomingSum = 0.0;
      for (final u in predecessors[v]!) {
        incomingSum += rank[u]! / outDegrees[u]!;
      }
      final newScore = base + danglingContribution + damping * incomingSum;
      nextRank[v] = newScore;
      change += (newScore - rank[v]!).abs();
    }

    for (final v in vertices) {
      rank[v] = nextRank[v]!;
    }

    if (change < tolerance) break;
  }

  return rank;
}
