import 'dart:math';

import '../strategy.dart';

/// Tests whether an undirected graph is planar using the Left–Right planarity
/// test.
///
/// A graph is planar if and only if it can be drawn in the plane without any
/// edge crossings. Operates on undirected graphs; self-loops and parallel edges
/// are ignored.
bool isPlanar<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n <= 4) return true;

  final vertexToIndex = vertexStrategy.createMap<int>();
  for (var i = 0; i < n; i++) {
    vertexToIndex[vertexList[i]] = i;
  }

  // Build simple undirected adjacency list (deduplicating parallel edges and ignoring self-loops)
  final adj = List<Set<int>>.generate(n, (_) => <int>{});
  for (var u = 0; u < n; u++) {
    final uVertex = vertexList[u];
    for (final vVertex in neighboursOf(uVertex)) {
      final v = vertexToIndex[vVertex];
      if (v != null && u != v) {
        adj[u].add(v);
        adj[v].add(u);
      }
    }
  }

  // Decompose into connected components
  final visited = List<bool>.filled(n, false);
  for (var i = 0; i < n; i++) {
    if (visited[i]) continue;

    // Collect component vertices
    final component = <int>[];
    final queue = <int>[i];
    visited[i] = true;
    while (queue.isNotEmpty) {
      final curr = queue.removeLast();
      component.add(curr);
      for (final neighbor in adj[curr]) {
        if (!visited[neighbor]) {
          visited[neighbor] = true;
          queue.add(neighbor);
        }
      }
    }

    final compSize = component.length;
    if (compSize <= 4) continue;

    // Euler's formula fast reject: |E_c| <= 3|V_c| - 6
    var edgeCount2 = 0;
    for (final u in component) {
      edgeCount2 += adj[u].length;
    }
    final compEdges = edgeCount2 ~/ 2;
    if (compEdges > 3 * compSize - 6) {
      return false;
    }

    // Run Left-Right Planarity test on this component
    if (!_isComponentPlanar(component, adj)) {
      return false;
    }
  }

  return true;
}

bool _isComponentPlanar(List<int> component, List<Set<int>> adj) {
  final root = component.first;

  // DFS orientation state
  final parentEdge = <int, _Edge?>{};
  final orientedAdj = <int, List<int>>{};
  final orientedEdges = <_Edge>{};
  final height = <int, int?>{};
  final lowpt = <_Edge, int>{};
  final lowpt2 = <_Edge, int>{};
  final nestingDepth = <_Edge, int>{};

  height[root] = 0;
  _dfsOrientation(
    root,
    parentEdge,
    adj,
    orientedAdj,
    orientedEdges,
    height,
    lowpt,
    lowpt2,
    nestingDepth,
  );

  // Sort oriented adjacency lists by ascending nesting depth
  final orderedAdj = <int, List<int>>{};
  for (final entry in orientedAdj.entries) {
    final v = entry.key;
    final list = entry.value;
    list.sort(
      (a, b) =>
          nestingDepth[_Edge(v, a)]!.compareTo(nestingDepth[_Edge(v, b)]!),
    );
    orderedAdj[v] = list;
  }

  // DFS testing state
  final s = <_ConflictPair>[];
  final stackBottom = <_Edge, _ConflictPair?>{};
  final lowptEdge = <_Edge, _Edge?>{};
  final ref = <_Edge, _Edge?>{};

  return _dfsTesting(
    root,
    parentEdge,
    orderedAdj,
    s,
    stackBottom,
    lowpt,
    height,
    lowptEdge,
    ref,
  );
}

void _dfsOrientation(
  int root,
  Map<int, _Edge?> parentEdge,
  List<Set<int>> adj,
  Map<int, List<int>> orientedAdj,
  Set<_Edge> orientedEdges,
  Map<int, int?> height,
  Map<_Edge, int> lowpt,
  Map<_Edge, int> lowpt2,
  Map<_Edge, int> nestingDepth,
) {
  final stack = <({int v, Iterator<int> iter, _Edge? activeEdge})>[
    (v: root, iter: adj[root].iterator, activeEdge: null),
  ];

  void finishEdge(int v, _Edge vw) {
    final e = parentEdge[v];
    nestingDepth[vw] = 2 * lowpt[vw]!;
    if (lowpt2[vw]! < height[v]!) {
      nestingDepth[vw] = nestingDepth[vw]! + 1;
    }
    if (e != null) {
      if (lowpt[vw]! < lowpt[e]!) {
        lowpt2[e] = min(lowpt[e]!, lowpt2[vw]!);
        lowpt[e] = lowpt[vw]!;
      } else if (lowpt[vw]! > lowpt[e]!) {
        lowpt2[e] = min(lowpt2[e]!, lowpt[vw]!);
      } else {
        lowpt2[e] = min(lowpt2[e]!, lowpt2[vw]!);
      }
    }
  }

  while (stack.isNotEmpty) {
    final frame = stack.last;
    final v = frame.v;
    if (frame.activeEdge case final vw?) {
      finishEdge(v, vw);
      stack[stack.length - 1] = (v: v, iter: frame.iter, activeEdge: null);
    }
    if (frame.iter.moveNext()) {
      final w = frame.iter.current;
      final vw = _Edge(v, w);
      final wv = _Edge(w, v);
      if (orientedEdges.contains(vw) || orientedEdges.contains(wv)) {
        continue;
      }
      orientedEdges.add(vw);
      orientedAdj.putIfAbsent(v, () => <int>[]).add(w);

      lowpt[vw] = height[v]!;
      lowpt2[vw] = height[v]!;

      if (height[w] == null) {
        // Tree edge
        parentEdge[w] = vw;
        height[w] = height[v]! + 1;
        stack[stack.length - 1] = (v: v, iter: frame.iter, activeEdge: vw);
        stack.add((v: w, iter: adj[w].iterator, activeEdge: null));
      } else {
        // Back edge
        lowpt[vw] = height[w]!;
        finishEdge(v, vw);
      }
    } else {
      stack.removeLast();
    }
  }
}

bool _dfsTesting(
  int root,
  Map<int, _Edge?> parentEdge,
  Map<int, List<int>> orderedAdj,
  List<_ConflictPair> s,
  Map<_Edge, _ConflictPair?> stackBottom,
  Map<_Edge, int> lowpt,
  Map<int, int?> height,
  Map<_Edge, _Edge?> lowptEdge,
  Map<_Edge, _Edge?> ref,
) {
  final stack =
      <
        ({
          int v,
          List<int> adjs,
          Iterator<int> iter,
          int? activeW,
          _Edge? activeEdge,
        })
      >[];

  void push(int v) {
    final adjs = orderedAdj[v] ?? const [];
    stack.add((
      v: v,
      adjs: adjs,
      iter: adjs.iterator,
      activeW: null,
      activeEdge: null,
    ));
  }

  bool integrateReturnEdges(int v, List<int> adjs, int w, _Edge ei, _Edge? e) {
    if (lowpt[ei]! < height[v]!) {
      if (w == adjs.first) {
        if (e != null) {
          lowptEdge[e] = lowptEdge[ei];
        }
      } else {
        if (!_addConstraints(ei, e, s, stackBottom, lowpt, lowptEdge, ref)) {
          return false;
        }
      }
    }
    return true;
  }

  push(root);
  while (stack.isNotEmpty) {
    final frame = stack.last;
    final v = frame.v;
    final e = parentEdge[v];
    if (frame.activeEdge case final ei?) {
      if (!integrateReturnEdges(v, frame.adjs, frame.activeW!, ei, e)) {
        return false;
      }
      stack[stack.length - 1] = (
        v: v,
        adjs: frame.adjs,
        iter: frame.iter,
        activeW: null,
        activeEdge: null,
      );
    }
    if (frame.iter.moveNext()) {
      final w = frame.iter.current;
      final ei = _Edge(v, w);
      stackBottom[ei] = s.isEmpty ? null : s.last;
      if (ei == parentEdge[w]) {
        // Tree edge
        stack[stack.length - 1] = (
          v: v,
          adjs: frame.adjs,
          iter: frame.iter,
          activeW: w,
          activeEdge: ei,
        );
        push(w);
      } else {
        // Back edge
        lowptEdge[ei] = ei;
        s.add(_ConflictPair(right: _Interval(ei, ei)));
        if (!integrateReturnEdges(v, frame.adjs, w, ei, e)) {
          return false;
        }
      }
    } else {
      stack.removeLast();
      // Remove back edges returning to parent
      if (e != null) {
        _removeBackEdges(e, s, height, lowpt, ref);
      }
    }
  }
  return true;
}

bool _addConstraints(
  _Edge ei,
  _Edge? e,
  List<_ConflictPair> s,
  Map<_Edge, _ConflictPair?> stackBottom,
  Map<_Edge, int> lowpt,
  Map<_Edge, _Edge?> lowptEdge,
  Map<_Edge, _Edge?> ref,
) {
  final p = _ConflictPair();
  // Merge return edges of ei into p.right
  while (true) {
    if (s.isEmpty) break;
    final q = s.removeLast();
    if (!q.left.isEmpty) {
      q.swap();
    }
    if (!q.left.isEmpty) {
      return false;
    }
    if (e != null && lowpt[q.right.low!]! > lowpt[e]!) {
      if (p.right.isEmpty) {
        p.right = q.right.copy();
      } else {
        ref[p.right.low!] = q.right.high;
      }
      p.right.low = q.right.low;
    } else {
      if (e != null) {
        ref[q.right.low!] = lowptEdge[e];
      }
    }
    final top = s.isEmpty ? null : s.last;
    if (top == stackBottom[ei]) {
      break;
    }
  }

  // Merge conflicting return edges of e_1, ..., e_i-1 into p.left
  while (s.isNotEmpty &&
      (s.last.left.conflicting(ei, lowpt) ||
          s.last.right.conflicting(ei, lowpt))) {
    final q = s.removeLast();
    if (q.right.conflicting(ei, lowpt)) {
      q.swap();
    }
    if (q.right.conflicting(ei, lowpt)) {
      return false;
    }
    // Merge interval below lowpt(ei) into p.right
    if (p.right.low != null) {
      ref[p.right.low!] = q.right.high;
    }
    if (q.right.low != null) {
      p.right.low = q.right.low;
    }
    if (p.left.isEmpty) {
      p.left = q.left.copy();
    } else {
      if (p.left.low != null) {
        ref[p.left.low!] = q.left.high;
      }
    }
    p.left.low = q.left.low;
  }

  if (!p.left.isEmpty || !p.right.isEmpty) {
    s.add(p);
  }
  return true;
}

void _removeBackEdges(
  _Edge e,
  List<_ConflictPair> s,
  Map<int, int?> height,
  Map<_Edge, int> lowpt,
  Map<_Edge, _Edge?> ref,
) {
  final u = e.source;
  while (s.isNotEmpty && s.last.lowest(lowpt) == height[u]) {
    s.removeLast();
  }
  if (s.isNotEmpty) {
    final p = s.removeLast();
    while (p.left.high != null && p.left.high!.target == u) {
      p.left.high = ref[p.left.high!];
    }
    if (p.left.high == null && p.left.low != null) {
      ref[p.left.low!] = p.right.low;
      p.left.low = null;
    }
    while (p.right.high != null && p.right.high!.target == u) {
      p.right.high = ref[p.right.high!];
    }
    if (p.right.high == null && p.right.low != null) {
      ref[p.right.low!] = p.left.low;
      p.right.low = null;
    }
    s.add(p);
  }

  if (lowpt[e]! < height[u]!) {
    if (s.isNotEmpty) {
      final hl = s.last.left.high;
      final hr = s.last.right.high;
      if (hl != null && (hr == null || lowpt[hl]! > lowpt[hr]!)) {
        ref[e] = hl;
      } else {
        ref[e] = hr;
      }
    }
  }
}

class _Edge {
  final int source;
  final int target;
  const new(this.source, this.target);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Edge && source == other.source && target == other.target;

  @override
  int get hashCode => Object.hash(source, target);

  @override
  String toString() => '($source, $target)';
}

class _Interval {
  _Edge? low;
  _Edge? high;

  new([this.low, this.high]);

  bool get isEmpty => low == null && high == null;

  _Interval copy() => _Interval(low, high);

  bool conflicting(_Edge b, Map<_Edge, int> lowpt) =>
      !isEmpty && lowpt[high!]! > lowpt[b]!;
}

class _ConflictPair {
  _Interval left;
  _Interval right;

  new({_Interval? left, _Interval? right})
    : left = left ?? _Interval(),
      right = right ?? _Interval();

  void swap() {
    final temp = left;
    left = right;
    right = temp;
  }

  int lowest(Map<_Edge, int> lowpt) {
    if (left.isEmpty) return lowpt[right.low!]!;
    if (right.isEmpty) return lowpt[left.low!]!;
    return min(lowpt[left.low!]!, lowpt[right.low!]!);
  }
}
