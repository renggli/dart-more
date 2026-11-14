import 'dart:math' as math;

import '../strategy.dart';

/// Computes Katz centrality for all vertices.
///
/// Katz centrality calculates the relative influence of a node within a network
/// by measuring the number of immediate neighbors (first-degree nodes) and also
/// all other nodes in the network that connect to the node through these
/// immediate neighbors (walks), penalized by an attenuation factor [alpha].
///
/// See https://en.wikipedia.org/wiki/Katz_centrality.
Map<V, double> katzCentrality<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) predecessorsOf,
  double alpha = 0.1,
  double beta = 1.0,
  int maxIterations = 1000,
  double tolerance = 1e-6,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertList = vertices.toList();
  final n = vertList.length;
  if (n == 0) return vertexStrategy.createMap<double>();

  var scores = vertexStrategy.createMap<double>();
  for (final v in vertList) {
    scores[v] = beta;
  }

  for (var iter = 0; iter < maxIterations; iter++) {
    final nextScores = vertexStrategy.createMap<double>();
    var normSq = 0.0;

    for (final v in vertList) {
      var sum = 0.0;
      for (final u in predecessorsOf(v)) {
        sum += scores[u] ?? 0.0;
      }
      final val = alpha * sum + beta;
      nextScores[v] = val;
      normSq += val * val;
    }

    final norm = math.sqrt(normSq);
    if (norm > 0) {
      for (final v in vertList) {
        nextScores[v] = nextScores[v]! / norm;
      }
    }

    var diff = 0.0;
    for (final v in vertList) {
      diff += (nextScores[v]! - (scores[v] ?? 0.0)).abs();
    }

    scores = nextScores;
    if (diff < tolerance) break;
  }

  return scores;
}
