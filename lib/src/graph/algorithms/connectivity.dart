import '../graph.dart';
import '../strategy.dart';
import 'dinic_max_flow.dart';
import 'stoer_wagner_min_cut.dart';

/// Computes the edge connectivity of [graph] or between [source] and [target].
///
/// Edge connectivity is the minimum number of edges whose removal disconnects
/// the graph (or disconnects [source] from [target]).
///
/// For an undirected graph with no specific source/target, uses Stoer–Wagner min-cut.
/// For directed graphs or pair-specific queries, uses unit max flow via Dinic's algorithm.
int edgeConnectivity<V, E>(
  Graph<V, E> graph, {
  V? source,
  V? target,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= graph.vertexStrategy;
  final vertices = graph.vertices.toList(growable: false);
  final n = vertices.length;
  if (n <= 1) return 0;

  if (source != null && target != null) {
    if (source == target) return 0;
    if (graph.isDirected) {
      final dinic = DinicMaxFlow<V>(
        seedVertices: graph.vertices,
        successorsOf: graph.successorsOf,
        edgeCapacity: (u, v) => graph.containsEdge(u, v) ? 1 : 0,
        vertexStrategy: vertexStrategy,
      );
      return dinic(source, target).toInt();
    } else {
      // In undirected graph, each undirected edge allows unit flow in both directions
      final dinic = DinicMaxFlow<V>(
        seedVertices: graph.vertices,
        successorsOf: graph.neighboursOf,
        edgeCapacity: (u, v) => graph.containsEdge(u, v) ? 1 : 0,
        vertexStrategy: vertexStrategy,
      );
      return dinic(source, target).toInt();
    }
  }

  if (source != null || target != null) {
    throw ArgumentError('Both source and target must be provided, or neither');
  }

  // Global edge connectivity
  if (!graph.isDirected) {
    if (n < 2) return 0;
    // Check if graph is already disconnected
    var minDeg = n;
    for (final v in vertices) {
      final d = graph.degreeOf(v);
      if (d < minDeg) minDeg = d;
      if (d == 0) return 0;
    }
    final stoerWagner = StoerWagnerMinCut<V, E>(
      graph: graph,
      edgeWeight: (_, _) => 1,
      vertexStrategy: vertexStrategy,
    );
    return stoerWagner.weight.toInt();
  } else {
    // Directed global edge connectivity: min flow over all pairs (s, t)
    // By picking one vertex s and checking all (s, v) and (v, s), min over all v gives global connectivity
    var minCut = n;
    final dinic = DinicMaxFlow<V>(
      seedVertices: graph.vertices,
      successorsOf: graph.successorsOf,
      edgeCapacity: (u, v) => graph.containsEdge(u, v) ? 1 : 0,
      vertexStrategy: vertexStrategy,
    );
    final s = vertices.first;
    for (var i = 1; i < n; i++) {
      final t = vertices[i];
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

/// Computes the vertex connectivity of [graph] or between [source] and [target].
///
/// Vertex connectivity is the minimum number of vertices whose removal disconnects
/// the graph (or separates non-adjacent [source] and [target]).
///
/// Uses vertex splitting $v \to (v_{\text{in}}, v_{\text{out}})$ with unit capacity
/// internal edges and Dinic's max flow.
int vertexConnectivity<V, E>(
  Graph<V, E> graph, {
  V? source,
  V? target,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= graph.vertexStrategy;
  final vertices = graph.vertices.toList(growable: false);
  final n = vertices.length;
  if (n <= 1) return 0;

  // Vertex-splitting representation: (V vertex, bool isOut)
  Iterable<_SplitNode<V>> successorsOfSplit(_SplitNode<V> node) {
    final (v, isOut) = node;
    if (!isOut) {
      // In-node has single outgoing edge to its out-node
      return [(v, true)];
    } else {
      // Out-node connects to in-nodes of successors/neighbours
      final nextVertices = graph.isDirected
          ? graph.successorsOf(v)
          : graph.neighboursOf(v);
      return nextVertices.where((u) => u != v).map((u) => (u, false));
    }
  }

  num capacityOfSplit(_SplitNode<V> u, _SplitNode<V> v) {
    final (uNode, uIsOut) = u;
    final (vNode, vIsOut) = v;
    if (uNode == vNode && !uIsOut && vIsOut) {
      // Internal edge has capacity 1 (only 1 unit of flow through node)
      return 1;
    }
    if (uIsOut && !vIsOut) {
      // External edge between vertices has infinite capacity
      return double.infinity;
    }
    return 0;
  }

  final splitStrategy = StorageStrategy<_SplitNode<V>>.defaultStrategy();

  if (source != null && target != null) {
    if (source == target) return 0;
    if (graph.containsEdge(source, target) ||
        (!graph.isDirected && graph.containsEdge(target, source))) {
      // By Menger's theorem, vertex connectivity is defined for non-adjacent pairs.
      // If adjacent, return n - 1 or throw. For adjacent pairs, removing vertices cannot separate them.
      return n - 1;
    }
    final seedVertices = <_SplitNode<V>>[];
    for (final v in vertices) {
      seedVertices.add((v, false));
      seedVertices.add((v, true));
    }
    final dinic = DinicMaxFlow<_SplitNode<V>>(
      seedVertices: seedVertices,
      successorsOf: successorsOfSplit,
      edgeCapacity: capacityOfSplit,
      vertexStrategy: splitStrategy,
    );
    return dinic((source, true), (target, false)).toInt();
  }

  if (source != null || target != null) {
    throw ArgumentError('Both source and target must be provided, or neither');
  }

  // Global vertex connectivity:
  // For complete graphs Kn, vertex connectivity is n - 1.
  var isComplete = true;
  for (final u in vertices) {
    final expectedDeg = n - 1;
    final actualDeg = graph.isDirected
        ? graph.outDegreeOf(u)
        : graph.degreeOf(u);
    if (actualDeg < expectedDeg) {
      isComplete = false;
      break;
    }
  }
  if (isComplete) return n - 1;

  final seedVertices = <_SplitNode<V>>[];
  for (final v in vertices) {
    seedVertices.add((v, false));
    seedVertices.add((v, true));
  }
  final dinic = DinicMaxFlow<_SplitNode<V>>(
    seedVertices: seedVertices,
    successorsOf: successorsOfSplit,
    edgeCapacity: capacityOfSplit,
    vertexStrategy: splitStrategy,
  );

  var minCut = n - 1;
  for (var i = 0; i < n; i++) {
    final s = vertices[i];
    for (var j = i + 1; j < n; j++) {
      final t = vertices[j];
      if (graph.containsEdge(s, t) ||
          (!graph.isDirected && graph.containsEdge(t, s))) {
        continue;
      }
      final flow = dinic((s, true), (t, false)).toInt();
      if (flow < minCut) minCut = flow;
      if (graph.isDirected) {
        final flowRev = dinic((t, true), (s, false)).toInt();
        if (flowRev < minCut) minCut = flowRev;
      }
      if (minCut == 0) return 0;
    }
  }

  return minCut;
}
