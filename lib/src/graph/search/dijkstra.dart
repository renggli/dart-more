import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../../../functional.dart';
import '../path.dart';
import '../search.dart';

extension DijkstraGraphSearchExtension<V, E> on GraphSearch<V, E> {
  DijkstraPath<V>? dijkstra(V source, V target) =>
      dijkstraAll(source, (vertex) => vertex == target).firstOrNull;

  /// Returns an [Iterable] over all Dijkstra paths that start in `source` and
  /// end in a vertex that satisfies the `target` predicate.
  Iterable<DijkstraPath<V>> dijkstraAll(V source, Predicate1<V> target) sync* {
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
        yield DijkstraPath<V>(
          vertices: vertices,
          cost: cost[current],
        );
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

class DijkstraPath<V> extends Path<V> {
  DijkstraPath({
    required this.vertices,
    required this.cost,
  });

  @override
  V get source => vertices.first;

  @override
  V get target => vertices.last;

  @override
  final List<V> vertices;

  @override
  final num cost;
}
