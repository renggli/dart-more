import 'dart:collection';

import '../strategy.dart';

/// Internal helper to 2-color an undirected bipartite graph.
/// Returns a map of vertex to boolean partition, or throws [ArgumentError] if
/// not bipartite.
Map<V, bool> _twoColor<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required StorageStrategy<V> vertexStrategy,
}) {
  final colors = vertexStrategy.createMap<bool>();
  final queueColor = <V>[];
  for (final vertex in vertices) {
    if (colors.containsKey(vertex)) continue;
    colors[vertex] = true;
    queueColor.add(vertex);
    while (queueColor.isNotEmpty) {
      final u = queueColor.removeLast();
      final colorU = colors[u]!;
      for (final v in neighboursOf(u)) {
        if (colors.containsKey(v)) {
          if (colors[v] == colorU) {
            throw ArgumentError('Graph is not bipartite');
          }
        } else {
          colors[v] = !colorU;
          queueColor.add(v);
        }
      }
    }
  }
  return colors;
}

/// Computes the maximum bipartite matching of an undirected bipartite graph
/// using the Hopcroft–Karp algorithm (O(E * sqrt(V))).
///
/// Throws [ArgumentError] if the graph is not bipartite.
///
/// Returns a map representing matched pairs (each matched edge appears as
/// `u -> v` and `v -> u`).
Map<V, V> bipartiteMatching<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final colors = _twoColor<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );

  final partU = <V>[];
  for (final v in vertices) {
    if (colors[v] == true) partU.add(v);
  }

  final pairU = vertexStrategy.createMap<V?>();
  final pairV = vertexStrategy.createMap<V?>();
  final dist = vertexStrategy.createMap<int>();

  for (final v in vertices) {
    if (colors[v] == true) {
      pairU[v] = null;
    } else {
      pairV[v] = null;
    }
  }

  bool bfs() {
    final queue = Queue<V>();
    for (final u in partU) {
      if (pairU[u] == null) {
        dist[u] = 0;
        queue.add(u);
      } else {
        dist[u] = -1;
      }
    }

    var foundAugmenting = false;
    while (queue.isNotEmpty) {
      final u = queue.removeFirst();
      for (final v in neighboursOf(u)) {
        final nextU = pairV[v];
        if (nextU == null) {
          foundAugmenting = true;
        } else if (dist[nextU]! < 0) {
          dist[nextU] = dist[u]! + 1;
          queue.add(nextU);
        }
      }
    }
    return foundAugmenting;
  }

  bool dfs(V u) {
    for (final v in neighboursOf(u)) {
      final nextU = pairV[v];
      if (nextU == null || (dist[nextU] == dist[u]! + 1 && dfs(nextU))) {
        pairU[u] = v;
        pairV[v] = u;
        return true;
      }
    }
    dist[u] = -1;
    return false;
  }

  while (bfs()) {
    for (final u in partU) {
      if (pairU[u] == null) {
        dfs(u);
      }
    }
  }

  final result = vertexStrategy.createMap<V>();
  for (final entry in pairU.entries) {
    final v = entry.value;
    if (v != null) {
      result[entry.key] = v;
    }
  }
  for (final entry in pairV.entries) {
    final u = entry.value;
    if (u != null) {
      result[entry.key] = u;
    }
  }

  return result;
}

/// Computes the minimum vertex cover of an undirected bipartite graph using
/// Kőnig's theorem.
///
/// Throws [ArgumentError] if the graph is not bipartite.
Set<V> bipartiteMinimumVertexCover<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required StorageStrategy<V> vertexStrategy,
}) {
  final colors = _twoColor<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );
  final matching = bipartiteMatching<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );

  final visited = vertexStrategy.createSet();
  final queue = Queue<V>();

  for (final v in vertices) {
    if (colors[v] == true && !matching.containsKey(v)) {
      visited.add(v);
      queue.add(v);
    }
  }

  while (queue.isNotEmpty) {
    final u = queue.removeFirst();
    if (colors[u] == true) {
      for (final v in neighboursOf(u)) {
        if (!visited.contains(v) && matching[u] != v) {
          visited.add(v);
          queue.add(v);
        }
      }
    } else {
      final matchedU = matching[u];
      if (matchedU != null && !visited.contains(matchedU)) {
        visited.add(matchedU);
        queue.add(matchedU);
      }
    }
  }

  final cover = vertexStrategy.createSet();
  for (final v in vertices) {
    if (colors[v] == true && !visited.contains(v)) {
      cover.add(v);
    } else if (colors[v] == false && visited.contains(v)) {
      cover.add(v);
    }
  }

  return cover;
}

/// Computes the maximum weight bipartite matching of an undirected bipartite
/// graph.
///
/// If [maximumWeight] is `true`, finds a matching that maximizes total weight
/// (only edges that contribute positive gain are matched).
/// If [maximumWeight] is `false`, finds a matching that minimizes total weight
/// among maximum cardinality matchings.
///
/// Throws [ArgumentError] if the graph is not bipartite.
///
/// Returns a map representing matched pairs (each matched edge appears as
/// `u -> v` and `v -> u`).
Map<V, V> weightedBipartiteMatching<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required num Function(V source, V target) edgeWeight,
  bool maximumWeight = true,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final colors = _twoColor<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );

  var partU = <V>[];
  var partW = <V>[];
  for (final v in vertices) {
    if (colors[v] == true) {
      partU.add(v);
    } else {
      partW.add(v);
    }
  }

  if (partU.isEmpty || partW.isEmpty) {
    return vertexStrategy.createMap<V>();
  }

  if (partU.length > partW.length) {
    final temp = partU;
    partU = partW;
    partW = temp;
  }

  final nU = partU.length;
  final nW = partW.length;

  final indexW = vertexStrategy.createMap<int>();
  for (var j = 0; j < nW; j++) {
    indexW[partW[j]] = j;
  }

  final sign = maximumWeight ? 1.0 : -1.0;
  final adj = List<List<(int, double)>>.generate(nU, (_) => <(int, double)>[]);
  for (var i = 0; i < nU; i++) {
    final u = partU[i];
    for (final w in neighboursOf(u)) {
      final j = indexW[w];
      if (j != null) {
        adj[i].add((j, sign * edgeWeight(u, w).toDouble()));
      }
    }
  }

  final pU = List<double>.filled(nU, 0.0);
  final pW = List<double>.filled(nW, 0.0);
  for (var i = 0; i < nU; i++) {
    var maxW = double.negativeInfinity;
    for (final (_, w) in adj[i]) {
      if (w > maxW) maxW = w;
    }
    pU[i] = maxW.isFinite ? maxW : 0.0;
  }

  final matchU = List<int>.filled(nU, -1);
  final matchW = List<int>.filled(nW, -1);

  for (var startU = 0; startU < nU; startU++) {
    final dist = List<double>.filled(nW, double.infinity);
    final parent = List<int>.filled(nW, -1);
    final visitedW = List<bool>.filled(nW, false);
    final visitedU = List<bool>.filled(nU, false);
    final distU = List<double>.filled(nU, 0.0);

    var currU = startU;
    visitedU[currU] = true;
    distU[currU] = 0.0;

    int? finalW;
    while (true) {
      final currentDistU = distU[currU];
      for (final (j, weight) in adj[currU]) {
        if (!visitedW[j]) {
          final slack = pU[currU] + pW[j] - weight;
          final newDist = currentDistU + (slack < 0.0 ? 0.0 : slack);
          if (newDist < dist[j]) {
            dist[j] = newDist;
            parent[j] = currU;
          }
        }
      }

      var bestJ = -1;
      var bestDist = double.infinity;
      for (var j = 0; j < nW; j++) {
        if (!visitedW[j] && dist[j] < bestDist) {
          bestDist = dist[j];
          bestJ = j;
        }
      }

      if (bestJ == -1 || bestDist.isInfinite) {
        break;
      }

      visitedW[bestJ] = true;

      if (maximumWeight) {
        var gain = 0.0;
        var traceW = bestJ;
        while (traceW != -1) {
          final u = parent[traceW];
          double? forwardWeight;
          for (final (neighbor, w) in adj[u]) {
            if (neighbor == traceW) {
              forwardWeight = w;
              break;
            }
          }
          gain += forwardWeight ?? 0.0;
          final prevW = matchU[u];
          if (prevW != -1) {
            double? prevWeight;
            for (final (neighbor, w) in adj[u]) {
              if (neighbor == prevW) {
                prevWeight = w;
                break;
              }
            }
            gain -= prevWeight ?? 0.0;
          }
          traceW = prevW;
        }

        if (gain <= 0.0) {
          break;
        }
      }

      if (matchW[bestJ] == -1) {
        finalW = bestJ;
        break;
      }

      final nextU = matchW[bestJ];
      visitedU[nextU] = true;
      distU[nextU] = bestDist;
      currU = nextU;
    }

    if (finalW != null) {
      final d = dist[finalW];
      for (var i = 0; i < nU; i++) {
        if (visitedU[i]) {
          pU[i] -= d - distU[i];
        }
      }
      for (var j = 0; j < nW; j++) {
        if (visitedW[j]) {
          pW[j] += d - dist[j];
        }
      }

      var currW = finalW;
      while (currW != -1) {
        final u = parent[currW];
        final nextW = matchU[u];
        matchU[u] = currW;
        matchW[currW] = u;
        currW = nextW;
      }
    }
  }

  final result = vertexStrategy.createMap<V>();
  for (var i = 0; i < nU; i++) {
    final j = matchU[i];
    if (j != -1) {
      final u = partU[i];
      final w = partW[j];
      result[u] = w;
      result[w] = u;
    }
  }
  return result;
}
