import 'package:collection/collection.dart';

import '../../../functional.dart';
import '../edge.dart';
import '../path.dart';
import '../search.dart';

extension DijkstraGraphSearchExtension<V, E> on GraphSearch<V, E> {
  DijkstraPath<V, E>? dijkstraTo(V source, V target) =>
      dijkstraAll(source, (vertex) => vertex == target).firstOrNull;

  DijkstraPath<V, E>? dijkstraToAll(V source, V target) =>
      dijkstraAll(source, (vertex) => vertex == target).firstOrNull;

  Iterable<DijkstraPath<V, E>> dijkstraAll(
      V source, Predicate1<V> isTarget) sync* {
    final totalCost = vertexStrategy.createMap<num>()..[source] = 0;
    final edges = vertexStrategy.createMap<Edge<V, E>>();
    final todo = PriorityQueue<V>((a, b) => (totalCost[a] ?? double.infinity)
        .compareTo(totalCost[b] ?? double.infinity));
    while (todo.isNotEmpty) {
      final current = todo.removeFirst();
      if (isTarget(current)) {
        final result = <Edge<V, E>>[];
        for (var edge = edges[current];
            edge != null;
            edge = edges[edge.source]) {
          result.add(edge);
        }
        yield DijkstraPath<V, E>(
          source: source,
          target: current,
          edges: result,
          cost: totalCost[current]!,
        );
      }
      for (final edge in outgoingEdgesOf(current)) {
        final target = edge.target;
        final cost = totalCost[current]! + edgeCost(edge);
        if (cost < (totalCost[target] ?? double.infinity)) {
          totalCost[target] = cost;
          edges[target] = edge;
          todo.add(target);
        }
      }
    }
  }
}

class DijkstraPath<V, E> extends Path<V, E> {
  DijkstraPath({
    required this.source,
    required this.target,
    required this.edges,
    required this.cost,
  });

  @override
  final V source;

  @override
  final V target;

  final num cost;

  @override
  List<Edge<V, E>> edges;

  @override
  // TODO: implement vertices
  Iterable<V> get vertices => throw UnimplementedError();
}
