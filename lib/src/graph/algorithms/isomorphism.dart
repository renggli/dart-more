import '../graph.dart';
import '../strategy.dart';

/// Finds isomorphisms or subgraph isomorphisms between [target] and [pattern]
/// using the VF2 algorithm.
///
/// If [subgraph] is `false`, finds full graph isomorphisms (requiring $|V_1| = |V_2|$
/// and $|E_1| = |E_2|$).
/// If [subgraph] is `true`, finds induced subgraph isomorphisms of [pattern] in [target]
/// (mappings from [pattern] vertices to [target] vertices).
Iterable<Map<VP, VT>> findIsomorphisms<VT, ET, VP, EP>(
  Graph<VT, ET> target,
  Graph<VP, EP> pattern, {
  bool subgraph = false,
  bool Function(VT targetVertex, VP patternVertex)? vertexComparator,
  bool Function(ET targetEdgeValue, EP patternEdgeValue)? edgeComparator,
  StorageStrategy<VT>? targetStrategy,
  StorageStrategy<VP>? patternStrategy,
}) sync* {
  if (target.isDirected != pattern.isDirected) return;

  final n1 = pattern.vertices.length;
  final n2 = target.vertices.length;

  if (!subgraph) {
    if (n1 != n2) return;
    if (pattern.edges.length != target.edges.length) return;
  } else {
    if (n1 > n2) return;
  }

  targetStrategy ??= target.vertexStrategy;
  patternStrategy ??= pattern.vertexStrategy;

  final patternVertices = pattern.vertices.toList(growable: false);
  final targetVertices = target.vertices.toList(growable: false);

  final patternIndex = patternStrategy.createMap<int>();
  for (var i = 0; i < n1; i++) {
    patternIndex[patternVertices[i]] = i;
  }

  final targetIndex = targetStrategy.createMap<int>();
  for (var i = 0; i < n2; i++) {
    targetIndex[targetVertices[i]] = i;
  }

  // Precompute adjacency matrices or neighbour bitsets
  // For simplicity and small-to-medium graphs, list of neighbour indices:
  final patternSuccessors = List<List<int>>.generate(n1, (i) {
    final v = patternVertices[i];
    final next = pattern.isDirected
        ? pattern.successorsOf(v)
        : pattern.neighboursOf(v);
    return next.map((w) => patternIndex[w]!).toList(growable: false);
  });
  final patternPredecessors = List<List<int>>.generate(n1, (i) {
    final v = patternVertices[i];
    final prev = pattern.isDirected
        ? pattern.predecessorsOf(v)
        : pattern.neighboursOf(v);
    return prev.map((w) => patternIndex[w]!).toList(growable: false);
  });

  final targetSuccessors = List<List<int>>.generate(n2, (i) {
    final v = targetVertices[i];
    final next = target.isDirected
        ? target.successorsOf(v)
        : target.neighboursOf(v);
    return next.map((w) => targetIndex[w]!).toList(growable: false);
  });
  final targetPredecessors = List<List<int>>.generate(n2, (i) {
    final v = targetVertices[i];
    final prev = target.isDirected
        ? target.predecessorsOf(v)
        : target.neighboursOf(v);
    return prev.map((w) => targetIndex[w]!).toList(growable: false);
  });

  // State structures
  final core1 = List<int>.filled(n1, -1); // pattern -> target index
  final core2 = List<int>.filled(n2, -1); // target -> pattern index

  final in1 = List<int>.filled(n1, 0);
  final in2 = List<int>.filled(n2, 0);
  final out1 = List<int>.filled(n1, 0);
  final out2 = List<int>.filled(n2, 0);

  bool isFeasible(int u, int v) {
    // Semantic feasibility
    final vp = patternVertices[u];
    final vt = targetVertices[v];
    if (vertexComparator != null && !vertexComparator(vt, vp)) {
      return false;
    }

    // Syntactic feasibility:
    // Check edge consistency with already mapped vertices
    for (final nextU in patternSuccessors[u]) {
      if (core1[nextU] != -1) {
        final mappedV = core1[nextU];
        if (!target.containsEdge(vt, targetVertices[mappedV])) {
          return false;
        }
        if (edgeComparator != null) {
          final ep = pattern.getEdge(vp, patternVertices[nextU])!.value;
          final et = target.getEdge(vt, targetVertices[mappedV])!.value;
          if (!edgeComparator(et, ep)) return false;
        }
      }
    }

    for (final prevU in patternPredecessors[u]) {
      if (core1[prevU] != -1) {
        final mappedV = core1[prevU];
        if (!target.containsEdge(targetVertices[mappedV], vt)) {
          return false;
        }
        if (edgeComparator != null) {
          final ep = pattern.getEdge(patternVertices[prevU], vp)!.value;
          final et = target.getEdge(targetVertices[mappedV], vt)!.value;
          if (!edgeComparator(et, ep)) return false;
        }
      }
    }

    for (final nextV in targetSuccessors[v]) {
      if (core2[nextV] != -1) {
        final mappedU = core2[nextV];
        if (!pattern.containsEdge(vp, patternVertices[mappedU])) {
          return false;
        }
      }
    }

    for (final prevV in targetPredecessors[v]) {
      if (core2[prevV] != -1) {
        final mappedU = core2[prevV];
        if (!pattern.containsEdge(patternVertices[mappedU], vp)) {
          return false;
        }
      }
    }

    // 1-look-ahead and 2-look-ahead rules
    var out1Count = 0, out2Count = 0;
    var in1Count = 0, in2Count = 0;
    var new1Count = 0, new2Count = 0;

    for (final nextU in patternSuccessors[u]) {
      if (core1[nextU] == -1) {
        if (out1[nextU] > 0) out1Count++;
        if (in1[nextU] > 0) in1Count++;
        if (out1[nextU] == 0 && in1[nextU] == 0) new1Count++;
      }
    }
    for (final prevU in patternPredecessors[u]) {
      if (core1[prevU] == -1) {
        if (out1[prevU] > 0) out1Count++;
        if (in1[prevU] > 0) in1Count++;
        if (out1[prevU] == 0 && in1[prevU] == 0) new1Count++;
      }
    }

    for (final nextV in targetSuccessors[v]) {
      if (core2[nextV] == -1) {
        if (out2[nextV] > 0) out2Count++;
        if (in2[nextV] > 0) in2Count++;
        if (out2[nextV] == 0 && in2[nextV] == 0) new2Count++;
      }
    }
    for (final prevV in targetPredecessors[v]) {
      if (core2[prevV] == -1) {
        if (out2[prevV] > 0) out2Count++;
        if (in2[prevV] > 0) in2Count++;
        if (out2[prevV] == 0 && in2[prevV] == 0) new2Count++;
      }
    }

    if (subgraph) {
      if (out1Count > out2Count ||
          in1Count > in2Count ||
          new1Count > new2Count) {
        return false;
      }
    } else {
      if (out1Count != out2Count ||
          in1Count != in2Count ||
          new1Count != new2Count) {
        return false;
      }
    }

    return true;
  }

  Iterable<Map<VP, VT>> match(int depth) sync* {
    if (depth == n1) {
      final mapping = patternStrategy!.createMap<VT>();
      for (var i = 0; i < n1; i++) {
        mapping[patternVertices[i]] = targetVertices[core1[i]];
      }
      yield mapping;
      return;
    }

    // Determine candidate pair generation
    // P(s) = T_1^out \times {min T_2^out} or similar
    var minU = -1;
    for (var i = 0; i < n1; i++) {
      if (core1[i] == -1 && out1[i] > 0) {
        minU = i;
        break;
      }
    }
    if (minU == -1) {
      for (var i = 0; i < n1; i++) {
        if (core1[i] == -1 && in1[i] > 0) {
          minU = i;
          break;
        }
      }
    }
    if (minU == -1) {
      for (var i = 0; i < n1; i++) {
        if (core1[i] == -1) {
          minU = i;
          break;
        }
      }
    }

    final u = minU;
    if (u == -1) return;

    final candidateV = <int>[];
    if (out1[u] > 0) {
      for (var j = 0; j < n2; j++) {
        if (core2[j] == -1 && out2[j] > 0) {
          candidateV.add(j);
        }
      }
    } else if (in1[u] > 0) {
      for (var j = 0; j < n2; j++) {
        if (core2[j] == -1 && in2[j] > 0) {
          candidateV.add(j);
        }
      }
    } else {
      for (var j = 0; j < n2; j++) {
        if (core2[j] == -1) {
          candidateV.add(j);
        }
      }
    }

    for (final v in candidateV) {
      if (isFeasible(u, v)) {
        // Add pair (u, v) to state
        core1[u] = v;
        core2[v] = u;

        final addedIn1 = <int>[];
        final addedOut1 = <int>[];
        final addedIn2 = <int>[];
        final addedOut2 = <int>[];

        for (final next in patternSuccessors[u]) {
          if (out1[next] == 0) {
            out1[next] = depth + 1;
            addedOut1.add(next);
          }
        }
        for (final prev in patternPredecessors[u]) {
          if (in1[prev] == 0) {
            in1[prev] = depth + 1;
            addedIn1.add(prev);
          }
        }

        for (final next in targetSuccessors[v]) {
          if (out2[next] == 0) {
            out2[next] = depth + 1;
            addedOut2.add(next);
          }
        }
        for (final prev in targetPredecessors[v]) {
          if (in2[prev] == 0) {
            in2[prev] = depth + 1;
            addedIn2.add(prev);
          }
        }

        yield* match(depth + 1);

        // Backtrack
        core1[u] = -1;
        core2[v] = -1;
        for (final k in addedOut1) {
          out1[k] = 0;
        }
        for (final k in addedIn1) {
          in1[k] = 0;
        }
        for (final k in addedOut2) {
          out2[k] = 0;
        }
        for (final k in addedIn2) {
          in2[k] = 0;
        }
      }
    }
  }

  yield* match(0);
}
