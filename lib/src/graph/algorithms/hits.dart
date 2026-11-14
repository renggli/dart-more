import 'dart:math' as math;

import '../strategy.dart';

/// Computes Kleinberg's Hyperlink-Induced Topic Search (HITS) authority and
/// hub centrality scores.
///
/// Returns a record `(Map<V, double> authorities, Map<V, double> hubs)`.
///
/// See https://en.wikipedia.org/wiki/HITS_algorithm.
(Map<V, double> authorities, Map<V, double> hubs) hits<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required Iterable<V> Function(V vertex) predecessorsOf,
  int maxIterations = 100,
  double tolerance = 1e-6,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertList = vertices.toList();
  final n = vertList.length;
  if (n == 0) {
    return (
      vertexStrategy.createMap<double>(),
      vertexStrategy.createMap<double>(),
    );
  }

  var auth = vertexStrategy.createMap<double>();
  var hubs = vertexStrategy.createMap<double>();
  final initVal = 1.0 / math.sqrt(n);
  for (final v in vertList) {
    auth[v] = initVal;
    hubs[v] = initVal;
  }

  for (var iter = 0; iter < maxIterations; iter++) {
    final nextAuth = vertexStrategy.createMap<double>();
    final nextHubs = vertexStrategy.createMap<double>();

    // Update authorities: a(v) = sum_{u -> v} h(u)
    var authNormSq = 0.0;
    for (final v in vertList) {
      var sum = 0.0;
      for (final u in predecessorsOf(v)) {
        sum += hubs[u] ?? 0.0;
      }
      nextAuth[v] = sum;
      authNormSq += sum * sum;
    }
    final authNorm = math.sqrt(authNormSq);
    if (authNorm > 0) {
      for (final v in vertList) {
        nextAuth[v] = nextAuth[v]! / authNorm;
      }
    }

    // Update hubs: h(u) = sum_{u -> v} a(v)
    var hubNormSq = 0.0;
    for (final u in vertList) {
      var sum = 0.0;
      for (final v in successorsOf(u)) {
        sum += nextAuth[v] ?? 0.0;
      }
      nextHubs[u] = sum;
      hubNormSq += sum * sum;
    }
    final hubNorm = math.sqrt(hubNormSq);
    if (hubNorm > 0) {
      for (final u in vertList) {
        nextHubs[u] = nextHubs[u]! / hubNorm;
      }
    }

    var maxDiff = 0.0;
    for (final v in vertList) {
      final da = (nextAuth[v]! - (auth[v] ?? 0.0)).abs();
      final dh = (nextHubs[v]! - (hubs[v] ?? 0.0)).abs();
      if (da > maxDiff) maxDiff = da;
      if (dh > maxDiff) maxDiff = dh;
    }

    auth = nextAuth;
    hubs = nextHubs;
    if (maxDiff < tolerance) break;
  }

  return (auth, hubs);
}
