import 'dart:math';
import 'dart:typed_data';

import '../strategy.dart';

/// Computes the Newman–Girvan modularity of a given partition of [communities] in a graph.
///
/// Modularity measures the density of edges inside communities compared to links between communities.
/// For directed graphs, it uses Leicht and Newman's directed modularity formula:
///
/// $$Q = \sum_{c} \left[ \frac{W_c}{m} - \left(\frac{K_c^{\text{out}}}{m}\right)\left(\frac{K_c^{\text{in}}}{m}\right) \right]$$
///
/// For undirected graphs:
///
/// $$Q = \sum_{c} \left[ \frac{W_c}{2m} - \left(\frac{K_c}{2m}\right)^2 \right]$$
///
/// where $m$ is the total edge weight, $W_c$ is the total weight of edges internal to community $c$,
/// and $K_c^{\text{out}}$ / $K_c^{\text{in}}$ are the sum of out- and in-degrees of vertices in community $c$.
///
/// Returns `0.0` if the graph has no edges ($m = 0$).
double modularity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required Iterable<Set<V>> communities,
  num Function(V source, V target)? edgeWeight,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final communityOf = vertexStrategy.createMap<int>();
  var numCommunities = 0;
  for (final community in communities) {
    for (final v in community) {
      communityOf[v] = numCommunities;
    }
    numCommunities++;
  }

  if (numCommunities == 0) return 0.0;

  final internalWeights = Float64List(numCommunities);
  final outDegrees = Float64List(numCommunities);
  final inDegrees = Float64List(numCommunities);
  var totalWeight = 0.0;

  for (final u in vertices) {
    final cu = communityOf[u];
    for (final v in successorsOf(u)) {
      final w = (edgeWeight?.call(u, v) ?? 1).toDouble();
      totalWeight += w;
      final cv = communityOf[v];
      if (cu != null) {
        outDegrees[cu] += w;
      }
      if (cv != null) {
        inDegrees[cv] += w;
      }
      if (cu != null && cv != null && cu == cv) {
        internalWeights[cu] += w;
      }
    }
  }

  if (totalWeight == 0.0) return 0.0;

  var q = 0.0;
  for (var c = 0; c < numCommunities; c++) {
    final wInternal = internalWeights[c];
    final kOut = outDegrees[c];
    final kIn = inDegrees[c];
    q += (wInternal / totalWeight) - (kOut / totalWeight) * (kIn / totalWeight);
  }

  return q;
}

/// Detects communities in an undirected graph using the asynchronous label propagation algorithm (LPA).
///
/// Each vertex starts with a unique label. In each iteration, vertices update their label to the
/// most frequent label among their neighbours (weighted by edge weight).
///
/// If [random] is provided, vertex update order is randomized in each iteration, and ties
/// are broken randomly; otherwise, deterministic vertex ordering and smallest-label tie breaking are used.
Iterable<Set<V>> labelPropagationCommunities<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  num Function(V source, V target)? edgeWeight,
  int maxIterations = 100,
  Random? random,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n == 0) return const [];
  if (n == 1) return [vertexStrategy.createSet()..add(vertexList.first)];

  final vertexToIndex = vertexStrategy.createMap<int>();
  for (var i = 0; i < n; i++) {
    vertexToIndex[vertexList[i]] = i;
  }

  final labels = Int32List(n);
  for (var i = 0; i < n; i++) {
    labels[i] = i;
  }

  final order = List<int>.generate(n, (i) => i);

  for (var iter = 0; iter < maxIterations; iter++) {
    if (random != null) {
      order.shuffle(random);
    }
    var changed = false;

    for (final uIdx in order) {
      final u = vertexList[uIdx];
      final labelWeights = <int, double>{};

      for (final v in neighboursOf(u)) {
        if (v == u) continue;
        final vIdx = vertexToIndex[v];
        if (vIdx == null) continue;
        final w = (edgeWeight?.call(u, v) ?? 1).toDouble();
        final lbl = labels[vIdx];
        labelWeights[lbl] = (labelWeights[lbl] ?? 0.0) + w;
      }

      if (labelWeights.isEmpty) continue;

      var maxWeight = -1.0;
      final bestLabels = <int>[];
      for (final entry in labelWeights.entries) {
        if (entry.value > maxWeight + 1e-9) {
          maxWeight = entry.value;
          bestLabels.clear();
          bestLabels.add(entry.key);
        } else if ((entry.value - maxWeight).abs() <= 1e-9) {
          bestLabels.add(entry.key);
        }
      }

      if (bestLabels.contains(labels[uIdx])) {
        continue;
      }

      final int chosenLabel;
      if (random != null) {
        chosenLabel = bestLabels[random.nextInt(bestLabels.length)];
      } else {
        chosenLabel = bestLabels.reduce(min);
      }

      if (chosenLabel != labels[uIdx]) {
        labels[uIdx] = chosenLabel;
        changed = true;
      }
    }

    if (!changed) break;
  }

  final communityMap = <int, Set<V>>{};
  for (var i = 0; i < n; i++) {
    final lbl = labels[i];
    final set = communityMap.putIfAbsent(lbl, vertexStrategy.createSet);
    set.add(vertexList[i]);
  }

  return communityMap.values.toList(growable: false);
}

/// Detects communities in an undirected graph by maximizing modularity using the Louvain algorithm.
///
/// [resolution] is the modularity resolution parameter $\gamma$ (defaults to `1.0`).
/// Values $> 1.0$ yield smaller communities, while values $< 1.0$ yield larger communities.
Iterable<Set<V>> louvainCommunities<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  num Function(V source, V target)? edgeWeight,
  double resolution = 1.0,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n == 0) return const [];
  if (n == 1) return [vertexStrategy.createSet()..add(vertexList.first)];

  final vertexToIndex = vertexStrategy.createMap<int>();
  for (var i = 0; i < n; i++) {
    vertexToIndex[vertexList[i]] = i;
  }

  // Build initial graph representation with indexed super-vertices.
  var numNodes = n;
  var nodeMembers = List<List<int>>.generate(n, (i) => [i]);
  var adjList = List<Map<int, double>>.generate(n, (_) => <int, double>{});
  var selfLoops = Float64List(n);
  var totalDegree = Float64List(n);
  var twoM = 0.0;

  for (var u = 0; u < n; u++) {
    final uVertex = vertexList[u];
    for (final vVertex in neighboursOf(uVertex)) {
      final v = vertexToIndex[vVertex];
      if (v == null) continue;
      final w = (edgeWeight?.call(uVertex, vVertex) ?? 1).toDouble();
      if (u == v) {
        selfLoops[u] += w;
        totalDegree[u] += w;
        twoM += w;
      } else {
        final existing = adjList[u][v] ?? 0.0;
        adjList[u][v] = existing + w;
        totalDegree[u] += w;
        twoM += w;
      }
    }
  }

  if (twoM <= 0.0) {
    return vertexList
        .map((v) => vertexStrategy!.createSet()..add(v))
        .toList(growable: false);
  }

  // Multilevel refinement
  while (true) {
    // Phase 1: Local modularity optimization
    final community = Int32List(numNodes);
    for (var i = 0; i < numNodes; i++) {
      community[i] = i;
    }
    final totDegree = Float64List.fromList(totalDegree);

    var phase1Improved = false;
    for (var pass = 0; pass < 50; pass++) {
      var passMoved = false;
      for (var i = 0; i < numNodes; i++) {
        final ki = totalDegree[i];
        if (ki == 0.0) continue;

        final currComm = community[i];
        final neighbors = adjList[i];

        // Edge weights to communities
        final commWeights = <int, double>{};
        for (final entry in neighbors.entries) {
          final c = community[entry.key];
          commWeights[c] = (commWeights[c] ?? 0.0) + entry.value;
        }

        // Temporarily remove i from currComm
        final kiCurr = commWeights[currComm] ?? 0.0;
        totDegree[currComm] -= ki;

        var bestComm = currComm;
        var bestGain = kiCurr - resolution * (totDegree[currComm] * ki) / twoM;

        for (final entry in commWeights.entries) {
          final c = entry.key;
          if (c == currComm) continue;
          final kiC = entry.value;
          final gain = kiC - resolution * (totDegree[c] * ki) / twoM;
          if (gain > bestGain + 1e-12) {
            bestGain = gain;
            bestComm = c;
          }
        }

        community[i] = bestComm;
        totDegree[bestComm] += ki;

        if (bestComm != currComm) {
          passMoved = true;
          phase1Improved = true;
        }
      }

      if (!passMoved) break;
    }

    if (!phase1Improved) break;

    // Phase 2: Community aggregation (graph contraction)
    final commMapping = <int, int>{};
    var nextCommId = 0;
    for (var i = 0; i < numNodes; i++) {
      final c = community[i];
      if (!commMapping.containsKey(c)) {
        commMapping[c] = nextCommId++;
      }
    }

    final newNumNodes = nextCommId;
    if (newNumNodes == numNodes) break; // No communities were merged

    final newNodeMembers = List<List<int>>.generate(newNumNodes, (_) => []);
    for (var i = 0; i < numNodes; i++) {
      final newC = commMapping[community[i]]!;
      newNodeMembers[newC].addAll(nodeMembers[i]);
    }

    final newAdjList = List<Map<int, double>>.generate(
      newNumNodes,
      (_) => <int, double>{},
    );
    final newSelfLoops = Float64List(newNumNodes);
    final newTotalDegree = Float64List(newNumNodes);

    for (var u = 0; u < numNodes; u++) {
      final newU = commMapping[community[u]]!;
      newSelfLoops[newU] += selfLoops[u];
      newTotalDegree[newU] += selfLoops[u];

      for (final entry in adjList[u].entries) {
        final v = entry.key;
        final w = entry.value;
        final newV = commMapping[community[v]]!;
        if (newU == newV) {
          newSelfLoops[newU] += w;
          newTotalDegree[newU] += w;
        } else {
          final existing = newAdjList[newU][newV] ?? 0.0;
          newAdjList[newU][newV] = existing + w;
          newTotalDegree[newU] += w;
        }
      }
    }

    numNodes = newNumNodes;
    nodeMembers = newNodeMembers;
    adjList = newAdjList;
    selfLoops = newSelfLoops;
    totalDegree = newTotalDegree;
  }

  // Construct result communities from nodeMembers
  final result = <Set<V>>[];
  for (final members in nodeMembers) {
    final set = vertexStrategy.createSet();
    for (final idx in members) {
      set.add(vertexList[idx]);
    }
    result.add(set);
  }

  return result;
}
