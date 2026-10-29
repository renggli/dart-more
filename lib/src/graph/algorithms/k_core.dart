import '../strategy.dart';

/// Computes the core numbers of all [vertices] using the Matula–Beck $O(V + E)$ algorithm.
///
/// The core number (or coreness) of a vertex is the highest order $k$ of a
/// $k$-core that contains that vertex.
Map<V, int> coreNumbers<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  final result = vertexStrategy.createMap<int>();
  if (n == 0) return result;

  // Degrees of vertices (excluding self-loops)
  final degrees = vertexStrategy.createMap<int>();
  var maxDeg = 0;
  for (final v in vertexList) {
    var deg = 0;
    for (final u in neighboursOf(v)) {
      if (u != v) deg++;
    }
    degrees[v] = deg;
    if (deg > maxDeg) maxDeg = deg;
  }

  // Bucket sort vertices by degree
  final bins = List<Set<V>>.generate(
    maxDeg + 1,
    (_) => vertexStrategy!.createSet(),
  );
  for (final v in vertexList) {
    bins[degrees[v]!].add(v);
  }

  // Peeling process
  for (var d = 0; d <= maxDeg; d++) {
    while (bins[d].isNotEmpty) {
      final v = bins[d].first;
      bins[d].remove(v);
      result[v] = d;

      for (final u in neighboursOf(v)) {
        if (u != v && !result.containsKey(u)) {
          final degU = degrees[u]!;
          if (degU > d) {
            bins[degU].remove(u);
            final newDegU = degU - 1;
            degrees[u] = newDegU;
            bins[newDegU].add(u);
          }
        }
      }
    }
  }

  return result;
}

/// Computes the set of vertices belonging to the $k$-core of a graph.
Set<V> kCoreVertices<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required int k,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final cores = coreNumbers<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );
  final result = vertexStrategy.createSet();
  for (final entry in cores.entries) {
    if (entry.value >= k) {
      result.add(entry.key);
    }
  }
  return result;
}
