import 'dart:collection';

import '../graph.dart';
import '../strategy.dart';

/// Computes betweenness centrality for all vertices in [graph] using
/// Brandes's algorithm ($O(V \cdot E)$ for unweighted graphs).
///
/// If [normalized] is `true`, betweenness values are scaled by
/// $\frac{2}{(n - 1)(n - 2)}$ for undirected graphs and
/// $\frac{1}{(n - 1)(n - 2)}$ for directed graphs (where $n = |V|$).
Map<V, double> betweennessCentrality<V, E>(
  Graph<V, E> graph, {
  bool normalized = true,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= graph.vertexStrategy;
  final vertices = graph.vertices.toList(growable: false);
  final n = vertices.length;

  final centrality = vertexStrategy.createMap<double>();
  for (final v in vertices) {
    centrality[v] = 0.0;
  }
  if (n <= 2) return centrality;

  for (final s in vertices) {
    final stack = <V>[];
    final predecessors = vertexStrategy.createMap<List<V>>();
    for (final v in vertices) {
      predecessors[v] = <V>[];
    }

    final sigma = vertexStrategy.createMap<double>();
    final distance = vertexStrategy.createMap<int>();
    for (final v in vertices) {
      sigma[v] = 0.0;
      distance[v] = -1;
    }
    sigma[s] = 1.0;
    distance[s] = 0;

    final queue = Queue<V>()..add(s);
    while (queue.isNotEmpty) {
      final v = queue.removeFirst();
      stack.add(v);

      for (final w in graph.successorsOf(v)) {
        // Path discovery
        if (distance[w]! < 0) {
          queue.add(w);
          distance[w] = distance[v]! + 1;
        }
        // Path counting
        if (distance[w] == distance[v]! + 1) {
          sigma[w] = sigma[w]! + sigma[v]!;
          predecessors[w]!.add(v);
        }
      }
    }

    final delta = vertexStrategy.createMap<double>();
    for (final v in vertices) {
      delta[v] = 0.0;
    }

    // Accumulation: pop stack in reverse order of discovery
    while (stack.isNotEmpty) {
      final w = stack.removeLast();
      final coeff = (1.0 + delta[w]!) / sigma[w]!;
      for (final v in predecessors[w]!) {
        delta[v] = delta[v]! + sigma[v]! * coeff;
      }
      if (w != s) {
        centrality[w] = centrality[w]! + delta[w]!;
      }
    }
  }

  // Brandes's algorithm counts each pair twice in undirected graphs.
  final factor = graph.isDirected ? 1.0 : 0.5;
  final scale = normalized && n > 2
      ? (graph.isDirected
            ? 1.0 / ((n - 1) * (n - 2))
            : 2.0 / ((n - 1) * (n - 2)))
      : 1.0;

  for (final v in vertices) {
    centrality[v] = centrality[v]! * factor * scale;
  }

  return centrality;
}
