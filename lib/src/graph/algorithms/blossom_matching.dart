import 'dart:collection';

import '../strategy.dart';

/// Computes a maximum cardinality matching in an undirected graph using
/// Edmonds' Blossom algorithm (O(|V|^3)).
///
/// Unlike bipartite matching, this algorithm works on arbitrary general
/// undirected graphs containing odd cycles.
///
/// Returns a map representing matched pairs (each matched edge appears as
/// `u -> v` and `v -> u`).
Map<V, V> maximumMatching<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;

  if (n <= 1) {
    return vertexStrategy.createMap<V>();
  }

  final vertexIndex = vertexStrategy.createMap<int>();
  for (var i = 0; i < n; i++) {
    vertexIndex[vertexList[i]] = i;
  }

  final adj = List<List<int>>.generate(n, (_) => <int>[]);
  for (var i = 0; i < n; i++) {
    for (final neighbor in neighboursOf(vertexList[i])) {
      final j = vertexIndex[neighbor];
      if (j != null && j != i) {
        adj[i].add(j);
      }
    }
  }

  final match = List<int>.filled(n, -1);
  final parent = List<int>.filled(n, -1);
  final base = List<int>.filled(n, 0);
  final type = List<int>.filled(n, -1); // 0: even, 1: odd, -1: unvisited

  int lca(int u, int v) {
    final visited = List<bool>.filled(n, false);
    var currU = u;
    while (true) {
      currU = base[currU];
      visited[currU] = true;
      if (match[currU] == -1) break;
      currU = parent[match[currU]];
    }
    var currV = v;
    while (true) {
      currV = base[currV];
      if (visited[currV]) return currV;
      if (match[currV] == -1) break;
      currV = parent[match[currV]];
    }
    return -1;
  }

  void markBlossom(int lcaNode, int u, List<bool> inBlossom) {
    var curr = u;
    while (base[curr] != lcaNode) {
      inBlossom[base[curr]] = true;
      inBlossom[base[match[curr]]] = true;
      curr = parent[match[curr]];
    }
  }

  void contract(int u, int v, int lcaNode, Queue<int> queue) {
    final inBlossom = List<bool>.filled(n, false);
    markBlossom(lcaNode, u, inBlossom);
    markBlossom(lcaNode, v, inBlossom);

    void trace(int from, int to) {
      var curr = from;
      var prev = to;
      while (base[curr] != lcaNode) {
        parent[curr] = prev;
        prev = match[curr];
        if (type[prev] == 1) {
          type[prev] = 0;
          queue.add(prev);
        }
        curr = parent[prev];
      }
    }

    trace(u, v);
    trace(v, u);

    for (var i = 0; i < n; i++) {
      if (inBlossom[base[i]]) {
        base[i] = lcaNode;
      }
    }
  }

  bool findAugmentingPath(int root) {
    parent.fillRange(0, n, -1);
    type.fillRange(0, n, -1);
    for (var i = 0; i < n; i++) {
      base[i] = i;
    }

    final queue = Queue<int>();
    type[root] = 0;
    queue.add(root);

    while (queue.isNotEmpty) {
      final u = queue.removeFirst();
      for (final v in adj[u]) {
        if (base[u] == base[v] || match[u] == v) continue;

        if (type[v] == -1) {
          if (match[v] == -1) {
            // Unmatched vertex found! Augment along alternating path.
            var currV = v;
            var currU = u;
            while (currU != -1) {
              final nextV = match[currU];
              match[currU] = currV;
              match[currV] = currU;
              currV = nextV;
              currU = currV != -1 ? parent[currV] : -1;
            }
            return true;
          } else {
            final w = match[v];
            parent[v] = u;
            type[v] = 1;
            parent[w] = v;
            type[w] = 0;
            queue.add(w);
          }
        } else if (type[v] == 0) {
          final lcaNode = lca(u, v);
          if (lcaNode != -1) {
            contract(u, v, lcaNode, queue);
          }
        }
      }
    }
    return false;
  }

  for (var i = 0; i < n; i++) {
    if (match[i] == -1) {
      findAugmentingPath(i);
    }
  }

  final result = vertexStrategy.createMap<V>();
  for (var i = 0; i < n; i++) {
    if (match[i] != -1) {
      result[vertexList[i]] = vertexList[match[i]];
    }
  }
  return result;
}
