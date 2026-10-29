import '../errors.dart';
import '../graph.dart';
import '../strategy.dart';

/// Computes the core numbers of all vertices in an undirected [graph] using
/// the Matula–Beck $O(V + E)$ algorithm.
///
/// The core number (or coreness) of a vertex is the highest order $k$ of a
/// $k$-core that contains that vertex.
///
/// Throws [GraphError] if the graph is directed.
Map<V, int> coreNumbers<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final vertices = graph.vertices.toList(growable: false);
  final n = vertices.length;
  final result = vertexStrategy.createMap<int>();
  if (n == 0) return result;

  // Degrees of vertices (excluding self-loops)
  final degrees = vertexStrategy.createMap<int>();
  var maxDeg = 0;
  for (final v in vertices) {
    var deg = 0;
    for (final u in graph.neighboursOf(v)) {
      if (u != v) deg++;
    }
    degrees[v] = deg;
    if (deg > maxDeg) maxDeg = deg;
  }

  // Bucket sort vertices by degree
  final bins = List<Set<V>>.generate(
    maxDeg + 1,
    (_) => vertexStrategy!.createSet(),
  );
  for (final v in vertices) {
    bins[degrees[v]!].add(v);
  }

  // Peeling process
  for (var d = 0; d <= maxDeg; d++) {
    while (bins[d].isNotEmpty) {
      final v = bins[d].first;
      bins[d].remove(v);
      result[v] = d;

      for (final u in graph.neighboursOf(v)) {
        if (u != v && !result.containsKey(u)) {
          final degU = degrees[u]!;
          if (degU > d) {
            bins[degU].remove(u);
            final newDegU = degU - 1;
            degrees[u] = newDegU;
            bins[newDegU].add(u);
          }
        }
      }
    }
  }

  return result;
}

/// Returns the $k$-core subgraph of an undirected [graph], which is the maximal
/// subgraph in which every vertex has degree at least [k].
///
/// Throws [GraphError] if the graph is directed.
Graph<V, E> kCore<V, E>(
  Graph<V, E> graph,
  int k, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final cores = coreNumbers(graph, vertexStrategy: vertexStrategy);
  final sub = Graph<V, E>(isDirected: false, vertexStrategy: vertexStrategy);

  for (final entry in cores.entries) {
    if (entry.value >= k) {
      sub.addVertex(entry.key);
    }
  }

  for (final v in sub.vertices) {
    for (final edge in graph.outgoingEdgesOf(v)) {
      if (sub.containsVertex(edge.target)) {
        sub.addEdge(edge.source, edge.target, value: edge.value);
      }
    }
  }

  return sub;
}
