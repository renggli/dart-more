import 'dart:math' as math;

import '../strategy.dart';

/// Computes the eigenvector centrality of all [vertices] using power iteration.
///
/// In each iteration, vertex scores are updated via the incoming edges:
/// $$x_v^{(t+1)} = \sum_{u \in N_{\text{in}}(v)} w(u, v) \, x_u^{(t)}$$
/// and normalized by the Euclidean norm $\|x^{(t+1)}\|_2$. Consecutive
/// iterations are blended to prevent periodic oscillation on bipartite graphs.
///
/// - [successorsOf] returns the outgoing neighbours of a vertex.
/// - [predecessorsOf] returns the incoming neighbours of a vertex. If omitted,
///   predecessors are automatically derived from [successorsOf].
/// - [edgeWeight] returns the weight of an edge from `source` to `target`.
///   If omitted, a default weight of `1.0` is used.
/// - [maxIterations] is the maximum number of power iterations (default: 100).
/// - [tolerance] is the convergence threshold for $L_1$ delta (default: 1e-6).
Map<V, double> eigenvectorCentrality<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex)? predecessorsOf,
  num Function(V source, V target)? edgeWeight,
  int maxIterations = 100,
  double tolerance = 1e-6,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;

  final x = vertexStrategy.createMap<double>();
  if (n == 0) return x;
  if (n == 1) {
    final single = vertexList.first;
    final selfLoop = successorsOf(single).contains(single);
    x[single] = selfLoop ? 1.0 : 0.0;
    return x;
  }

  final initialScore = 1.0 / n;
  for (final v in vertexList) {
    x[v] = initialScore;
  }

  final predecessorMap = vertexStrategy.createMap<List<V>>();
  if (predecessorsOf != null) {
    for (final v in vertexList) {
      predecessorMap[v] = predecessorsOf(v).toList(growable: false);
    }
  } else {
    for (final v in vertexList) {
      predecessorMap[v] = <V>[];
    }
    for (final v in vertexList) {
      for (final w in successorsOf(v)) {
        predecessorMap[w]?.add(v);
      }
    }
  }

  final nextX = vertexStrategy.createMap<double>();
  for (var iter = 0; iter < maxIterations; iter++) {
    for (final v in vertexList) {
      var sum = 0.0;
      for (final u in predecessorMap[v]!) {
        final w = edgeWeight?.call(u, v).toDouble() ?? 1.0;
        sum += w * x[u]!;
      }
      nextX[v] = sum;
    }

    var sumSquares = 0.0;
    for (final v in vertexList) {
      final val = nextX[v]!;
      sumSquares += val * val;
    }
    final norm = math.sqrt(sumSquares);
    if (norm == 0.0 || norm.isNaN) {
      for (final v in vertexList) {
        x[v] = 0.0;
      }
      break;
    }

    // Blend with previous iteration to eliminate periodic oscillation on bipartite graphs.
    var blendedSumSquares = 0.0;
    for (final v in vertexList) {
      final y = nextX[v]! / norm;
      final blended = 0.5 * (x[v]! + y);
      nextX[v] = blended;
      blendedSumSquares += blended * blended;
    }
    final blendedNorm = math.sqrt(blendedSumSquares);

    var delta = 0.0;
    for (final v in vertexList) {
      final normalized = nextX[v]! / blendedNorm;
      delta += (normalized - x[v]!).abs();
      x[v] = normalized;
    }

    if (delta < tolerance) break;
  }

  return x;
}
