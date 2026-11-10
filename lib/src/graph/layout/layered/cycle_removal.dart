/// Removes cycles by temporarily reversing back-edges via DFS to guarantee a strict DAG.
(Map<V, List<V>> dagSuccessors, Set<(V, V)> reversedEdges) removeCycles<V>(
  Iterable<V> allVertices,
  Iterable<V> Function(V vertex) successorsOf, {
  bool isDirected = true,
}) {
  final verticesSet = allVertices.toSet();
  final dag = <V, Set<V>>{for (final v in verticesSet) v: <V>{}};
  final reversed = <(V, V)>{};

  if (!isDirected) {
    // Level-based orientation for undirected graphs to avoid degenerate tall DFS trees
    final visited = <V>{};
    final levels = <V, int>{};
    final indexMap = <V, int>{};
    var idx = 0;
    for (final v in allVertices) {
      indexMap[v] = idx++;
    }

    for (final root in allVertices) {
      if (visited.contains(root)) continue;
      final queue = <V>[root];
      visited.add(root);
      levels[root] = 0;
      var qHead = 0;
      while (qHead < queue.length) {
        final u = queue[qHead++];
        final uLevel = levels[u]!;
        for (final v in successorsOf(u)) {
          if (!verticesSet.contains(v) || u == v) continue;
          if (visited.add(v)) {
            levels[v] = uLevel + 1;
            queue.add(v);
          }
        }
      }
    }

    final processed = <(V, V)>{};
    for (final u in allVertices) {
      for (final v in successorsOf(u)) {
        if (!verticesSet.contains(v) || u == v) continue;
        if (processed.contains((u, v)) || processed.contains((v, u))) continue;
        processed.add((u, v));

        final lu = levels[u] ?? 0;
        final lv = levels[v] ?? 0;
        if (lu < lv || (lu == lv && indexMap[u]! < indexMap[v]!)) {
          dag[u]!.add(v);
        } else {
          dag[v]!.add(u);
        }
      }
    }
    return (dag.map((k, v) => MapEntry(k, v.toList())), reversed);
  }

  final visited = <V>{};
  final onStack = <V>{};

  void dfs(V u) {
    visited.add(u);
    onStack.add(u);
    for (final v in successorsOf(u)) {
      if (!verticesSet.contains(v) || u == v) continue;
      if (onStack.contains(v)) {
        dag[v]!.add(u);
        reversed.add((u, v));
      } else {
        dag[u]!.add(v);
        if (!visited.contains(v)) {
          dfs(v);
        }
      }
    }
    onStack.remove(u);
  }

  for (final v in verticesSet) {
    if (!visited.contains(v)) {
      dfs(v);
    }
  }

  return (dag.map((k, v) => MapEntry(k, v.toList())), reversed);
}
