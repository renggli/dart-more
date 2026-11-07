import 'dart:typed_data';

import '../strategy.dart';

/// Checks if a graph has a Hamiltonian circuit (a closed cycle visiting every vertex exactly once).
bool hasHamiltonianCircuit<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) =>
    findHamiltonianPath<V>(
      vertices: vertices,
      successorsOf: successorsOf,
      isDirected: isDirected,
      circuit: true,
      vertexStrategy: vertexStrategy,
    ) !=
    null;

/// Checks if a graph has a Hamiltonian path (a path visiting every vertex exactly once).
bool hasHamiltonianPath<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) =>
    findHamiltonianPath<V>(
      vertices: vertices,
      successorsOf: successorsOf,
      isDirected: isDirected,
      circuit: false,
      vertexStrategy: vertexStrategy,
    ) !=
    null;

/// Finds a Hamiltonian path or circuit in a graph.
///
/// Returns a [List<V>] in traversal order (for a circuit, the start vertex is repeated
/// at the end), or `null` if no such path or circuit exists.
List<V>? findHamiltonianPath<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  bool circuit = false,
  StorageStrategy<V>? vertexStrategy,
}) {
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n == 0) return null;

  if (n == 1) {
    final v = vertexList.first;
    if (!circuit) return [v];
    final hasSelfLoop = successorsOf(v).contains(v);
    return hasSelfLoop ? [v, v] : null;
  }

  if (n == 2) {
    final u = vertexList[0];
    final w = vertexList[1];
    final uToW = successorsOf(u).contains(w);
    final wToU = successorsOf(w).contains(u);
    if (!circuit) {
      if (uToW) return [u, w];
      if (wToU) return [w, u];
      return null;
    }
    if (isDirected) {
      if (uToW && wToU) return [u, w, u];
      return null;
    }
    // In an undirected simple graph, a cycle requires at least 3 vertices.
    return null;
  }

  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexIndex = vertexStrategy.createMap<int>();
  for (var i = 0; i < n; i++) {
    vertexIndex[vertexList[i]] = i;
  }

  final adj = List<List<int>>.generate(n, (_) => <int>[]);
  final inDegree = List<int>.filled(n, 0);
  for (var i = 0; i < n; i++) {
    for (final target in successorsOf(vertexList[i])) {
      final j = vertexIndex[target];
      if (j != null && j != i) {
        adj[i].add(j);
        inDegree[j]++;
      }
    }
  }

  // Preconditions & degree pruning
  if (circuit) {
    for (var i = 0; i < n; i++) {
      if (adj[i].isEmpty || inDegree[i] == 0) return null;
      if (!isDirected && adj[i].length < 2) return null;
    }
  } else {
    var zeroOut = 0;
    var zeroIn = 0;
    for (var i = 0; i < n; i++) {
      if (adj[i].isEmpty) zeroOut++;
      if (inDegree[i] == 0) zeroIn++;
    }
    if (zeroOut > 1 || zeroIn > 1) return null;
    if (!isDirected) {
      var degreeOne = 0;
      for (var i = 0; i < n; i++) {
        if (adj[i].isEmpty) return null;
        if (adj[i].length == 1) degreeOne++;
      }
      if (degreeOne > 2) return null;
    }
  }

  // Use bitmask DP for n <= 20
  if (n <= 20) {
    return _heldKarpBitmask(vertexList, adj, isDirected, circuit);
  }

  // Use backtracking DFS with Warnsdorff's heuristic for n > 20
  return _backtrackingDfs(vertexList, adj, inDegree, isDirected, circuit);
}

List<V>? _heldKarpBitmask<V>(
  List<V> vertexList,
  List<List<int>> adj,
  bool isDirected,
  bool circuit,
) {
  final n = vertexList.length;
  final totalStates = 1 << n;
  final dp = Int32List(totalStates);

  // If circuit, without loss of generality fix start vertex to 0
  if (circuit) {
    dp[1 << 0] = 1 << 0;
  } else {
    for (var v = 0; v < n; v++) {
      dp[1 << v] = 1 << v;
    }
  }

  for (var mask = 1; mask < totalStates; mask++) {
    final ends = dp[mask];
    if (ends == 0) continue;
    for (var u = 0; u < n; u++) {
      if ((ends & (1 << u)) == 0) continue;
      for (final v in adj[u]) {
        if ((mask & (1 << v)) == 0) {
          dp[mask | (1 << v)] |= 1 << v;
        }
      }
    }
  }

  final fullMask = totalStates - 1;
  final finalEnds = dp[fullMask];
  if (finalEnds == 0) return null;

  int? chosenEnd;
  if (circuit) {
    for (var u = 0; u < n; u++) {
      if ((finalEnds & (1 << u)) != 0 && adj[u].contains(0)) {
        chosenEnd = u;
        break;
      }
    }
    if (chosenEnd == null) return null;
  } else {
    for (var u = 0; u < n; u++) {
      if ((finalEnds & (1 << u)) != 0) {
        chosenEnd = u;
        break;
      }
    }
  }

  if (chosenEnd == null) return null;

  // Reconstruct path
  final pathIndices = List<int>.filled(n, 0);
  var currentEnd = chosenEnd;
  var currentMask = fullMask;

  for (var step = n - 1; step >= 0; step--) {
    pathIndices[step] = currentEnd;
    final prevMask = currentMask ^ (1 << currentEnd);
    if (step == 0) break;
    var found = false;
    for (var u = 0; u < n; u++) {
      if ((dp[prevMask] & (1 << u)) != 0 && adj[u].contains(currentEnd)) {
        currentEnd = u;
        currentMask = prevMask;
        found = true;
        break;
      }
    }
    if (!found) return null;
  }

  final result = pathIndices.map((i) => vertexList[i]).toList();
  if (circuit) {
    result.add(result.first);
  }
  return result;
}

List<V>? _backtrackingDfs<V>(
  List<V> vertexList,
  List<List<int>> adj,
  List<int> inDegree,
  bool isDirected,
  bool circuit,
) {
  final n = vertexList.length;
  final visited = List<bool>.filled(n, false);
  final path = List<int>.filled(n, 0);

  // Warnsdorff's heuristic: order neighbours by unvisited degree
  int unvisitedSuccessorsCount(int u) {
    var count = 0;
    for (final v in adj[u]) {
      if (!visited[v]) count++;
    }
    return count;
  }

  bool dfs(int u, int step, int startVertex) {
    path[step] = u;
    if (step == n - 1) {
      if (!circuit) return true;
      return adj[u].contains(startVertex);
    }

    final candidates = <int>[];
    for (final v in adj[u]) {
      if (!visited[v]) candidates.add(v);
    }
    candidates.sort(
      (a, b) =>
          unvisitedSuccessorsCount(a).compareTo(unvisitedSuccessorsCount(b)),
    );

    for (final v in candidates) {
      visited[v] = true;
      if (dfs(v, step + 1, startVertex)) return true;
      visited[v] = false;
    }
    return false;
  }

  final startCandidates = circuit ? [0] : List<int>.generate(n, (i) => i);
  for (final start in startCandidates) {
    visited[start] = true;
    if (dfs(start, 0, start)) {
      final result = path.map((i) => vertexList[i]).toList();
      if (circuit) result.add(result.first);
      return result;
    }
    visited[start] = false;
  }

  return null;
}
