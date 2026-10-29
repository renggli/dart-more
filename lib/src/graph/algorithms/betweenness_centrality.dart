import 'dart:collection';

import '../strategy.dart';

/// Computes betweenness centrality for all [vertices] using Brandes's algorithm
/// ($O(V \cdot E)$ for unweighted graphs).
///
/// If [normalized] is `true`, betweenness values are scaled by
/// $\frac{2}{(n - 1)(n - 2)}$ for undirected graphs and
/// $\frac{1}{(n - 1)(n - 2)}$ for directed graphs (where $n = |V|$).
Map<V, double> betweennessCentrality<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  bool isDirected = true,
  bool normalized = true,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;

  final centrality = vertexStrategy.createMap<double>();
  for (final v in vertexList) {
    centrality[v] = 0.0;
  }
  if (n <= 2) return centrality;

  for (final s in vertexList) {
    final stack = <V>[];
    final predecessors = vertexStrategy.createMap<List<V>>();
    for (final v in vertexList) {
      predecessors[v] = <V>[];
    }

    final sigma = vertexStrategy.createMap<double>();
    final distance = vertexStrategy.createMap<int>();
    for (final v in vertexList) {
      sigma[v] = 0.0;
      distance[v] = -1;
    }
    sigma[s] = 1.0;
    distance[s] = 0;

    final queue = Queue<V>()..add(s);
    while (queue.isNotEmpty) {
      final v = queue.removeFirst();
      stack.add(v);

      for (final w in successorsOf(v)) {
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
    for (final v in vertexList) {
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
  final factor = isDirected ? 1.0 : 0.5;
  final scale = normalized && n > 2
      ? (isDirected ? 1.0 / ((n - 1) * (n - 2)) : 2.0 / ((n - 1) * (n - 2)))
      : 1.0;

  for (final v in vertexList) {
    centrality[v] = centrality[v]! * factor * scale;
  }

  return centrality;
}
