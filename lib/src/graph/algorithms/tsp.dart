import '../edge.dart';
import '../path.dart';
import '../strategy.dart';

/// Computes a Traveling Salesperson Tour heuristic using Nearest Neighbor followed
/// by 2-opt local search.
///
/// See https://en.wikipedia.org/wiki/2-opt.
Path<V, num>? tspHeuristic<V>({
  required Iterable<V> vertices,
  required num Function(V source, V target) edgeCost,
  V? startVertex,
  StorageStrategy<V>? vertexStrategy,
}) {
  final vertList = vertices.toList();
  final n = vertList.length;
  if (n < 2) return null;

  final start = startVertex ?? vertList.first;
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final unvisited = vertexStrategy.createSet()..addAll(vertList);
  unvisited.remove(start);

  // 1. Nearest Neighbour Tour
  final tour = <V>[start];
  var current = start;
  while (unvisited.isNotEmpty) {
    V? next;
    var bestCost = double.infinity;
    for (final cand in unvisited) {
      final cost = edgeCost(current, cand);
      if (cost < bestCost) {
        bestCost = cost.toDouble();
        next = cand;
      }
    }
    final nextVertex = (bestCost.isFinite && next != null)
        ? next
        : unvisited.first;
    tour.add(nextVertex);
    unvisited.remove(nextVertex);
    current = nextVertex;
  }
  tour.add(start);

  // 2. 2-opt local search
  var improved = true;
  var passes = 0;
  while (improved && passes < 100) {
    improved = false;
    passes++;
    for (var i = 1; i < n - 1; i++) {
      for (var k = i + 1; k < n; k++) {
        final a = tour[i - 1];
        final b = tour[i];
        final c = tour[k];
        final d = tour[k + 1];

        final currentDist = edgeCost(a, b) + edgeCost(c, d);
        final newDist = edgeCost(a, c) + edgeCost(b, d);

        if (newDist < currentDist) {
          tour.replaceRange(i, k + 1, tour.sublist(i, k + 1).reversed);
          improved = true;
        }
      }
    }
  }

  final edges = <Edge<V, num>>[];
  for (var i = 0; i < tour.length - 1; i++) {
    final u = tour[i];
    final v = tour[i + 1];
    edges.add(Edge.directed(u, v, value: edgeCost(u, v)));
  }
  return Path.fromEdges(edges);
}
