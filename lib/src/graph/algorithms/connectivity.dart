import '../strategy.dart';
import 'dinic_max_flow.dart';

/// Computes the edge connectivity of a graph or between [source] and [target].
///
/// Edge connectivity is the minimum number of edges whose removal disconnects
/// the graph (or disconnects [source] from [target]).
///
/// Uses unit max flow via Dinic's algorithm.
int edgeConnectivity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  bool Function(V source, V target)? containsEdge,
  bool isDirected = false,
  V? source,
  V? target,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n <= 1) return 0;

  containsEdge ??= (u, v) => successorsOf(u).contains(v);

  if (source != null && target != null) {
    if (source == target) return 0;
    final dinic = DinicMaxFlow<V>(
      seedVertices: vertexList,
      successorsOf: successorsOf,
      edgeCapacity: (u, v) => containsEdge!(u, v) ? 1 : 0,
      vertexStrategy: vertexStrategy,
    );
    return dinic(source, target).toInt();
  }

  if (source != null || target != null) {
    throw ArgumentError('Both source and target must be provided, or neither');
  }

  // Global edge connectivity
  if (!isDirected) {
    // In undirected graph, min cut between a fixed vertex s and all other vertices t
    var minCut = n;
    final dinic = DinicMaxFlow<V>(
      seedVertices: vertexList,
      successorsOf: successorsOf,
      edgeCapacity: (u, v) => containsEdge!(u, v) ? 1 : 0,
      vertexStrategy: vertexStrategy,
    );
    final s = vertexList.first;
    for (var i = 1; i < n; i++) {
      final t = vertexList[i];
      final st = dinic(s, t).toInt();
      if (st < minCut) minCut = st;
      if (minCut == 0) return 0;
    }
    return minCut;
  } else {
    // Directed global edge connectivity: min flow over all pairs (s, t)
    var minCut = n;
    final dinic = DinicMaxFlow<V>(
      seedVertices: vertexList,
      successorsOf: successorsOf,
      edgeCapacity: (u, v) => containsEdge!(u, v) ? 1 : 0,
      vertexStrategy: vertexStrategy,
    );
    final s = vertexList.first;
    for (var i = 1; i < n; i++) {
      final t = vertexList[i];
      final st = dinic(s, t).toInt();
      if (st < minCut) minCut = st;
      final ts = dinic(t, s).toInt();
      if (ts < minCut) minCut = ts;
      if (minCut == 0) return 0;
    }
    return minCut;
  }
}

typedef _SplitNode<V> = (V, bool);

/// Computes the vertex connectivity of a graph or between [source] and [target].
///
/// Vertex connectivity is the minimum number of vertices whose removal disconnects
/// the graph (or separates non-adjacent [source] and [target]).
///
/// Uses vertex splitting $v \to (v_{\text{in}}, v_{\text{out}})$ with unit capacity
/// internal edges and Dinic's max flow.
int vertexConnectivity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  bool Function(V source, V target)? containsEdge,
  bool isDirected = false,
  V? source,
  V? target,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n <= 1) return 0;

  containsEdge ??= (u, v) => successorsOf(u).contains(v);

  if (source != null && target != null) {
    if (source == target) return 0;
    // If there is a direct edge between source and target, they cannot be disconnected by vertex removal.
    if (containsEdge(source, target) ||
        (!isDirected && containsEdge(target, source))) {
      return n - 1;
    }

    final splitNodes = <_SplitNode<V>>[];
    for (final v in vertexList) {
      splitNodes.add((v, false)); // in-node
      splitNodes.add((v, true)); // out-node
    }

    Iterable<_SplitNode<V>> splitSuccessorsOf(_SplitNode<V> node) sync* {
      final (v, isOut) = node;
      if (!isOut) {
        // Edge v_in -> v_out
        yield (v, true);
      } else {
        // Edges v_out -> w_in for all successors w of v
        for (final w in successorsOf(v)) {
          if (w != v) {
            yield (w, false);
          }
        }
      }
    }

    num splitEdgeCapacity(_SplitNode<V> u, _SplitNode<V> v) {
      final (uVertex, uIsOut) = u;
      final (vVertex, vIsOut) = v;
      if (!uIsOut && vIsOut && uVertex == vVertex) {
        // v_in -> v_out has unit capacity (except for source and target which have infinity)
        if (uVertex == source || uVertex == target) {
          return double.infinity;
        }
        return 1;
      }
      if (uIsOut && !vIsOut) {
        if (containsEdge!(uVertex, vVertex)) {
          return double.infinity;
        }
      }
      return 0;
    }

    final dinic = DinicMaxFlow<_SplitNode<V>>(
      seedVertices: splitNodes,
      successorsOf: splitSuccessorsOf,
      edgeCapacity: splitEdgeCapacity,
    );

    return dinic((source, true), (target, false)).toInt();
  }

  if (source != null || target != null) {
    throw ArgumentError('Both source and target must be provided, or neither');
  }

  // Global vertex connectivity:
  // For undirected:
  // Check if graph is complete graph K_n
  // Count edges
  var edgeCount = 0;
  for (final v in vertexList) {
    edgeCount += successorsOf(v).length;
  }
  final maxEdges = n * (n - 1);
  if (isDirected ? edgeCount == maxEdges : edgeCount == maxEdges) {
    return n - 1;
  }

  var minConnectivity = n - 1;
  for (var i = 0; i < n; i++) {
    final s = vertexList[i];
    for (var j = i + 1; j < n; j++) {
      final t = vertexList[j];
      final directEdge =
          containsEdge(s, t) || (!isDirected && containsEdge(t, s));
      if (!directEdge) {
        final k = vertexConnectivity<V>(
          vertices: vertexList,
          successorsOf: successorsOf,
          containsEdge: containsEdge,
          isDirected: isDirected,
          source: s,
          target: t,
          vertexStrategy: vertexStrategy,
        );
        if (k < minConnectivity) {
          minConnectivity = k;
        }
        if (minConnectivity == 0) return 0;
      }
    }
  }

  return minConnectivity;
}
