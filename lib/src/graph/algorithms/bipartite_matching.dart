import 'dart:collection';

import '../strategy.dart';

/// Internal helper to 2-color an undirected bipartite graph.
/// Returns a map of vertex to boolean partition, or throws [ArgumentError] if not bipartite.
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
/// using the Hopcroft–Karp algorithm ($O(E \sqrt{V})$).
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
Set<V> minimumVertexCover<V>({
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

/// Computes the maximum independent set of an undirected bipartite graph.
///
/// In any graph, the complement of a minimum vertex cover is a maximum independent set.
///
/// Throws [ArgumentError] if the graph is not bipartite.
Set<V> maximumIndependentSet<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final cover = minimumVertexCover<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );
  final independentSet = vertexStrategy.createSet();
  for (final v in vertices) {
    if (!cover.contains(v)) {
      independentSet.add(v);
    }
  }
  return independentSet;
}
