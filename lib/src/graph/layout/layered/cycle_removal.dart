/// Removes cycles by temporarily reversing back-edges via DFS to guarantee a strict DAG.
(Map<V, List<V>> dagSuccessors, Set<(V, V)> reversedEdges) removeCycles<V>(
  Iterable<V> allVertices,
  Iterable<V> Function(V vertex) successorsOf,
) {
  final verticesSet = allVertices.toSet();
  final dag = <V, List<V>>{for (final v in verticesSet) v: []};
  final reversed = <(V, V)>{};
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

  return (dag, reversed);
}
