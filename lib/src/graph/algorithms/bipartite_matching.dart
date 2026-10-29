import 'dart:collection';

import '../errors.dart';
import '../graph.dart';
import '../strategy.dart';

/// Computes the maximum bipartite matching of an undirected bipartite [graph]
/// using the Hopcroft–Karp algorithm ($O(E \sqrt{V})$).
///
/// Throws [GraphError] if the graph is directed or not bipartite.
///
/// Returns a map representing matched pairs (each matched edge appears as
/// `u -> v` and `v -> u`).
Map<V, V> bipartiteMatching<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  // 1. Two-color vertices to partition into U and V
  final colors = vertexStrategy.createMap<bool>();
  final queueColor = <V>[];
  for (final vertex in graph.vertices) {
    if (colors.containsKey(vertex)) continue;
    colors[vertex] = true;
    queueColor.add(vertex);
    while (queueColor.isNotEmpty) {
      final u = queueColor.removeLast();
      final colorU = colors[u]!;
      for (final v in graph.neighboursOf(u)) {
        if (colors.containsKey(v)) {
          if (colors[v] == colorU) {
            throw GraphError(graph, 'graph', 'Graph is not bipartite');
          }
        } else {
          colors[v] = !colorU;
          queueColor.add(v);
        }
      }
    }
  }

  final partU = <V>[];
  for (final v in graph.vertices) {
    if (colors[v] == true) partU.add(v);
  }

  // 2. Hopcroft-Karp algorithm
  final pairU = vertexStrategy.createMap<V?>();
  final pairV = vertexStrategy.createMap<V?>();
  final dist = vertexStrategy.createMap<int>();

  for (final v in graph.vertices) {
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
      for (final v in graph.neighboursOf(u)) {
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
    for (final v in graph.neighboursOf(u)) {
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

  final matching = vertexStrategy.createMap<V>();
  for (final u in partU) {
    if (pairU[u] case final v?) {
      matching[u] = v;
      matching[v] = u;
    }
  }

  return matching;
}

/// Computes the minimum vertex cover of an undirected bipartite [graph]
/// using König's theorem.
///
/// Throws [GraphError] if the graph is directed or not bipartite.
Set<V> minimumVertexCover<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final matching = bipartiteMatching(graph, vertexStrategy: vertexStrategy);

  // Partition into U and V
  final colors = vertexStrategy.createMap<bool>();
  final queueColor = <V>[];
  for (final vertex in graph.vertices) {
    if (colors.containsKey(vertex)) continue;
    colors[vertex] = true;
    queueColor.add(vertex);
    while (queueColor.isNotEmpty) {
      final u = queueColor.removeLast();
      final colorU = colors[u]!;
      for (final v in graph.neighboursOf(u)) {
        if (!colors.containsKey(v)) {
          colors[v] = !colorU;
          queueColor.add(v);
        }
      }
    }
  }

  final partU = vertexStrategy.createSet();
  final partV = vertexStrategy.createSet();
  for (final v in graph.vertices) {
    if (colors[v] == true) {
      partU.add(v);
    } else {
      partV.add(v);
    }
  }

  // Reachable vertices via alternating paths starting from unmatched vertices in U
  final visited = vertexStrategy.createSet();
  final queue = Queue<V>();

  for (final u in partU) {
    if (!matching.containsKey(u)) {
      visited.add(u);
      queue.add(u);
    }
  }

  while (queue.isNotEmpty) {
    final curr = queue.removeFirst();
    if (partU.contains(curr)) {
      // From U to V via non-matching edges
      final matchedV = matching[curr];
      for (final v in graph.neighboursOf(curr)) {
        if (v != matchedV && visited.add(v)) {
          queue.add(v);
        }
      }
    } else {
      // From V to U via matching edge
      final matchedU = matching[curr];
      if (matchedU != null && visited.add(matchedU)) {
        queue.add(matchedU);
      }
    }
  }

  // König's theorem: Vertex cover = (U \ visited) U (V intersect visited)
  final cover = vertexStrategy.createSet();
  for (final u in partU) {
    if (!visited.contains(u)) cover.add(u);
  }
  for (final v in partV) {
    if (visited.contains(v)) cover.add(v);
  }

  return cover;
}

/// Computes the maximum independent set of an undirected bipartite [graph].
///
/// An independent set is a set of vertices no two of which are adjacent.
/// In bipartite graphs, this is the complement of the minimum vertex cover.
Set<V> maximumIndependentSet<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final cover = minimumVertexCover(graph, vertexStrategy: vertexStrategy);
  final independentSet = vertexStrategy.createSet();
  for (final v in graph.vertices) {
    if (!cover.contains(v)) {
      independentSet.add(v);
    }
  }
  return independentSet;
}
