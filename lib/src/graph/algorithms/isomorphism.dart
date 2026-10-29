import '../strategy.dart';

/// Finds isomorphisms or subgraph isomorphisms between target and pattern
/// using the VF2 algorithm.
///
/// If [subgraph] is `false`, finds full graph isomorphisms (requiring $|V_1| = |V_2|$
/// and identical edge structure).
/// If [subgraph] is `true`, finds induced subgraph isomorphisms of pattern in target
/// (mappings from pattern vertices to target vertices).
Iterable<Map<VP, VT>> findIsomorphisms<VT, ET, VP, EP>({
  required Iterable<VT> targetVertices,
  required Iterable<VP> patternVertices,
  required Iterable<VT> Function(VT vertex) targetSuccessorsOf,
  required Iterable<VP> Function(VP vertex) patternSuccessorsOf,
  Iterable<VT> Function(VT vertex)? targetPredecessorsOf,
  Iterable<VP> Function(VP vertex)? patternPredecessorsOf,
  int? targetEdgeCount,
  int? patternEdgeCount,
  bool isDirected = false,
  bool subgraph = false,
  bool Function(VT targetVertex, VP patternVertex)? vertexComparator,
  bool Function(ET targetEdgeValue, EP patternEdgeValue)? edgeComparator,
  ET? Function(VT source, VT target)? targetEdgeValue,
  EP? Function(VP source, VP target)? patternEdgeValue,
  StorageStrategy<VT>? targetStrategy,
  StorageStrategy<VP>? patternStrategy,
}) sync* {
  targetStrategy ??= StorageStrategy.defaultStrategy();
  patternStrategy ??= StorageStrategy.defaultStrategy();

  final pVerts = patternVertices.toList(growable: false);
  final tVerts = targetVertices.toList(growable: false);
  final n1 = pVerts.length;
  final n2 = tVerts.length;

  if (!subgraph) {
    if (n1 != n2) return;
    if (patternEdgeCount != null &&
        targetEdgeCount != null &&
        patternEdgeCount != targetEdgeCount) {
      return;
    }
  } else {
    if (n1 > n2) return;
  }

  final patternIndex = patternStrategy.createMap<int>();
  for (var i = 0; i < n1; i++) {
    patternIndex[pVerts[i]] = i;
  }

  final targetIndex = targetStrategy.createMap<int>();
  for (var i = 0; i < n2; i++) {
    targetIndex[tVerts[i]] = i;
  }

  final pPredOf = patternPredecessorsOf ?? patternSuccessorsOf;
  final tPredOf = targetPredecessorsOf ?? targetSuccessorsOf;

  final pSuccessors = List<List<int>>.generate(n1, (i) {
    final v = pVerts[i];
    return patternSuccessorsOf(v)
        .map((w) => patternIndex[w]!)
        .toList(growable: false);
  });
  final pPredecessors = List<List<int>>.generate(n1, (i) {
    final v = pVerts[i];
    return pPredOf(v).map((w) => patternIndex[w]!).toList(growable: false);
  });

  final tSuccessors = List<List<int>>.generate(n2, (i) {
    final v = tVerts[i];
    return targetSuccessorsOf(v)
        .map((w) => targetIndex[w]!)
        .toList(growable: false);
  });
  final tPredecessors = List<List<int>>.generate(n2, (i) {
    final v = tVerts[i];
    return tPredOf(v).map((w) => targetIndex[w]!).toList(growable: false);
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
    final vp = pVerts[u];
    final vt = tVerts[v];
    if (vertexComparator != null && !vertexComparator(vt, vp)) {
      return false;
    }

    // Syntactic feasibility:
    // Check edge consistency with already mapped vertices
    for (final nextU in pSuccessors[u]) {
      if (core1[nextU] != -1) {
        final nextV = core1[nextU];
        if (!tSuccessors[v].contains(nextV)) return false;
        if (edgeComparator != null &&
            patternEdgeValue != null &&
            targetEdgeValue != null) {
          final ep = patternEdgeValue(vp, pVerts[nextU]);
          final et = targetEdgeValue(vt, tVerts[nextV]);
          if (ep != null && et != null && !edgeComparator(et, ep)) return false;
        }
      }
    }
    for (final prevU in pPredecessors[u]) {
      if (core1[prevU] != -1) {
        final prevV = core1[prevU];
        if (!tPredecessors[v].contains(prevV)) return false;
        if (edgeComparator != null &&
            patternEdgeValue != null &&
            targetEdgeValue != null) {
          final ep = patternEdgeValue(pVerts[prevU], vp);
          final et = targetEdgeValue(tVerts[prevV], vt);
          if (ep != null && et != null && !edgeComparator(et, ep)) return false;
        }
      }
    }

    // Induced subgraph consistency from target side
    for (final nextV in tSuccessors[v]) {
      if (core2[nextV] != -1) {
        final nextU = core2[nextV];
        if (!pSuccessors[u].contains(nextU)) return false;
      }
    }
    for (final prevV in tPredecessors[v]) {
      if (core2[prevV] != -1) {
        final prevU = core2[prevV];
        if (!pPredecessors[u].contains(prevU)) return false;
      }
    }

    // Look-ahead checks: 1-look-ahead terminal sets
    var out1Count = 0, out2Count = 0;
    var in1Count = 0, in2Count = 0;
    var other1Count = 0, other2Count = 0;

    for (final nextU in pSuccessors[u]) {
      if (core1[nextU] == -1) {
        if (out1[nextU] > 0) out1Count++;
        if (in1[nextU] > 0) in1Count++;
        if (out1[nextU] == 0 && in1[nextU] == 0) other1Count++;
      }
    }
    for (final prevU in pPredecessors[u]) {
      if (core1[prevU] == -1) {
        if (out1[prevU] > 0) out1Count++;
        if (in1[prevU] > 0) in1Count++;
        if (out1[prevU] == 0 && in1[prevU] == 0) other1Count++;
      }
    }

    for (final nextV in tSuccessors[v]) {
      if (core2[nextV] == -1) {
        if (out2[nextV] > 0) out2Count++;
        if (in2[nextV] > 0) in2Count++;
        if (out2[nextV] == 0 && in2[nextV] == 0) other2Count++;
      }
    }
    for (final prevV in tPredecessors[v]) {
      if (core2[prevV] == -1) {
        if (out2[prevV] > 0) out2Count++;
        if (in2[prevV] > 0) in2Count++;
        if (out2[prevV] == 0 && in2[prevV] == 0) other2Count++;
      }
    }

    if (!subgraph) {
      if (out1Count != out2Count ||
          in1Count != in2Count ||
          other1Count != other2Count) {
        return false;
      }
    } else {
      if (out1Count > out2Count ||
          in1Count > in2Count ||
          other1Count > other2Count) {
        return false;
      }
    }

    return true;
  }

  Iterable<Map<VP, VT>> search(int depth) sync* {
    if (depth == n1) {
      final match = patternStrategy!.createMap<VT>();
      for (var u = 0; u < n1; u++) {
        match[pVerts[u]] = tVerts[core1[u]];
      }
      yield match;
      return;
    }

    var nextU = -1;
    for (var u = 0; u < n1; u++) {
      if (core1[u] == -1 && (out1[u] > 0 || in1[u] > 0)) {
        nextU = u;
        break;
      }
    }
    if (nextU == -1) {
      for (var u = 0; u < n1; u++) {
        if (core1[u] == -1) {
          nextU = u;
          break;
        }
      }
    }

    final candidateV = <int>[];
    if (out1[nextU] > 0) {
      for (var v = 0; v < n2; v++) {
        if (core2[v] == -1 && out2[v] > 0) {
          candidateV.add(v);
        }
      }
    } else if (in1[nextU] > 0) {
      for (var v = 0; v < n2; v++) {
        if (core2[v] == -1 && in2[v] > 0) {
          candidateV.add(v);
        }
      }
    } else {
      for (var v = 0; v < n2; v++) {
        if (core2[v] == -1) {
          candidateV.add(v);
        }
      }
    }

    for (final v in candidateV) {
      if (isFeasible(nextU, v)) {
        core1[nextU] = v;
        core2[v] = nextU;

        final modifiedIn1 = <int>[];
        final modifiedOut1 = <int>[];
        final modifiedIn2 = <int>[];
        final modifiedOut2 = <int>[];

        for (final next in pSuccessors[nextU]) {
          if (out1[next] == 0) {
            out1[next] = depth + 1;
            modifiedOut1.add(next);
          }
        }
        for (final prev in pPredecessors[nextU]) {
          if (in1[prev] == 0) {
            in1[prev] = depth + 1;
            modifiedIn1.add(prev);
          }
        }

        for (final next in tSuccessors[v]) {
          if (out2[next] == 0) {
            out2[next] = depth + 1;
            modifiedOut2.add(next);
          }
        }
        for (final prev in tPredecessors[v]) {
          if (in2[prev] == 0) {
            in2[prev] = depth + 1;
            modifiedIn2.add(prev);
          }
        }

        yield* search(depth + 1);

        for (final node in modifiedOut1) {
          out1[node] = 0;
        }
        for (final node in modifiedIn1) {
          in1[node] = 0;
        }
        for (final node in modifiedOut2) {
          out2[node] = 0;
        }
        for (final node in modifiedIn2) {
          in2[node] = 0;
        }

        core1[nextU] = -1;
        core2[v] = -1;
      }
    }
  }

  yield* search(0);
}
