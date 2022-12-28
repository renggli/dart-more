import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../../../functional.dart';
import '../model/path.dart';
import '../path.dart';
import '../search.dart';

extension DijkstraGraphSearchExtension<V, E> on GraphSearch<V, E> {
  Path<V>? dijkstra(V source, V target) =>
      dijkstraAll(source, (vertex) => vertex == target).firstOrNull;

  /// Returns an [Iterable] over all Dijkstra paths that start in `source` and
  /// end in a vertex that satisfies the `target` predicate.
  Iterable<Path<V>> dijkstraAll(V source, Predicate1<V> target) sync* {
    final cost = vertexStrategy.createMap<num>().withDefault(double.infinity)
      ..[source] = 0;
    final todo = PriorityQueue<V>((a, b) => cost[a].compareTo(cost[b]))
      ..add(source);
    final parents = vertexStrategy.createMap<V>();
    while (todo.isNotEmpty) {
      final current = todo.removeFirst();
      if (target(current)) {
        final vertices = QueueList<V>();
        for (V? parent = current; parent != null; parent = parents[parent]) {
          vertices.addFirst(parent);
        }
        yield DefaultPath<V>(vertices, cost[current]);
      }
      for (final edge in outgoingEdgesOf(current)) {
        final target = edge.target;
        final targetCost = cost[current] + edgeCost(edge);
        if (targetCost < cost[target]) {
          cost[target] = targetCost;
          parents[target] = current;
          todo.remove(target);
          todo.add(target);
        }
      }
    }
  }
}
