import 'dart:math' as math;

import '../strategy.dart';

/// Computes the degree centrality of all [vertices].
///
/// Degree centrality of a vertex `v` is `deg(v) / (|V| - 1)`.
/// Returns `0.0` for all vertices if `|V| <= 1`.
Map<V, double> degreeCentrality<V>({
  required Iterable<V> vertices,
  required int Function(V vertex) degreeOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final result = vertexStrategy.createMap<double>();
  final n = vertices.length;
  final denom = n > 1 ? n - 1.0 : 0.0;
  for (final v in vertices) {
    result[v] = denom > 0.0 ? degreeOf(v) / denom : 0.0;
  }
  return result;
}

/// Computes the density of a graph.
///
/// For a directed graph with `|V|` vertices and `|E|` non-self edges, density
/// is `|E| / (|V| * (|V| - 1))`.
/// For an undirected graph with `|E_u|` non-self edges, density is
/// `2 * |E_u| / (|V| * (|V| - 1))`.
///
/// Returns `0.0` if `|V| < 2`.
double graphDensity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n < 2) return 0.0;
  final maxEdges = n * (n - 1);
  var count = 0;
  for (final v in vertexList) {
    for (final w in successorsOf(v)) {
      if (!vertexStrategy.equals(w, v)) count++;
    }
  }
  return count / maxEdges;
}

/// Returns the local clustering coefficient of [vertex].
///
/// For undirected graphs, this is `2 * e / (k * (k - 1))` where `k` is the
/// number of distinct neighbours and `e` is the number of undirected edges
/// between them. For directed graphs, this is `e / (k * (k - 1))` where `e` is
/// the number of directed edges between distinct neighbours.
///
/// Returns `0.0` if [vertex] has fewer than 2 neighbours.
double localClusteringCoefficient<V>(
  V vertex, {
  required Iterable<V> Function(V vertex) neighboursOf,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final neighbours = vertexStrategy.createSet()..addAll(neighboursOf(vertex));
  neighbours.remove(vertex);
  final k = neighbours.length;
  if (k < 2) return 0.0;

  var links = 0;
  if (isDirected) {
    for (final u in neighbours) {
      for (final w in successorsOf(u)) {
        if (!vertexStrategy.equals(u, w) && neighbours.contains(w)) {
          links++;
        }
      }
    }
  } else {
    for (final u in neighbours) {
      for (final w in neighboursOf(u)) {
        if (!vertexStrategy.equals(u, w) && neighbours.contains(w)) {
          links++;
        }
      }
    }
  }
  return links / (k * (k - 1));
}

/// Returns the average clustering coefficient across all [vertices] in the
/// graph.
///
/// Returns `0.0` if [vertices] is empty.
double averageClusteringCoefficient<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  var sum = 0.0;
  var count = 0;
  for (final v in vertices) {
    sum += localClusteringCoefficient(
      v,
      neighboursOf: neighboursOf,
      successorsOf: successorsOf,
      isDirected: isDirected,
      vertexStrategy: vertexStrategy,
    );
    count++;
  }
  return count == 0 ? 0.0 : sum / count;
}

/// Returns the transitivity (global clustering coefficient) of an undirected
/// graph.
///
/// Transitivity is defined as `3 * triangles / connected_triplets`.
/// Returns `0.0` if there are no connected triplets.
double graphTransitivity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  var triangles = 0;
  var triplets = 0;
  for (final v in vertices) {
    final neighbours = vertexStrategy.createSet()..addAll(neighboursOf(v));
    neighbours.remove(v);
    final k = neighbours.length;
    if (k < 2) continue;
    triplets += k * (k - 1);
    for (final u in neighbours) {
      final uNeighbours = vertexStrategy.createSet()..addAll(neighboursOf(u));
      for (final w in uNeighbours) {
        if (!vertexStrategy.equals(u, w) && neighbours.contains(w)) {
          triangles++;
        }
      }
    }
  }
  return triplets == 0 ? 0.0 : triangles / triplets;
}

/// Computes the degree assortativity coefficient of a graph.
///
/// Assortativity measures the tendency of vertices to connect to other vertices
/// with similar degrees (Pearson correlation coefficient of degrees across
/// edges).
///
/// - Returns a value in `[-1.0, 1.0]`.
/// - Positive values indicate assortative mixing (high degree connects to high
///   degree).
/// - Negative values indicate disassortative mixing (high degree connects to
///   low degree).
/// - Returns [double.nan] if the graph has no edges or if degree variance is
///   zero (e.g., in regular graphs where all vertices have the exact same
///   degree).
double degreeAssortativity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  Iterable<V> Function(V vertex)? predecessorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final outDegrees = vertexStrategy.createMap<int>();
  final inDegrees = vertexStrategy.createMap<int>();
  for (final v in vertexList) {
    outDegrees[v] = 0;
    inDegrees[v] = 0;
  }

  if (isDirected) {
    for (final u in vertexList) {
      for (final v in successorsOf(u)) {
        outDegrees[u] = (outDegrees[u] ?? 0) + 1;
        inDegrees[v] = (inDegrees[v] ?? 0) + 1;
      }
    }
  } else {
    for (final v in vertexList) {
      final count = successorsOf(v).length;
      outDegrees[v] = count;
      inDegrees[v] = count;
    }
  }

  final pairs = <(double, double)>[];
  var sumJ = 0.0;
  var sumK = 0.0;

  for (final u in vertexList) {
    final j = outDegrees[u]!.toDouble();
    for (final v in successorsOf(u)) {
      final k = inDegrees[v]!.toDouble();
      pairs.add((j, k));
      sumJ += j;
      sumK += k;
    }
  }

  final edgeCount = pairs.length;
  if (edgeCount == 0) return double.nan;

  final meanJ = sumJ / edgeCount;
  final meanK = sumK / edgeCount;
  var varJ = 0.0;
  var varK = 0.0;
  var cov = 0.0;
  for (final (j, k) in pairs) {
    final dj = j - meanJ;
    final dk = k - meanK;
    varJ += dj * dj;
    varK += dk * dk;
    cov += dj * dk;
  }

  if (varJ <= 0.0 || varK <= 0.0) return double.nan;

  final r = cov / math.sqrt(varJ * varK);
  return r.clamp(-1.0, 1.0);
}
