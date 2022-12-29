import 'dart:collection';

import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../../../functional.dart';
import '../model/path.dart';
import '../path.dart';
import '../strategy.dart';

/// Generalized Dijkstra's algorithm.
///
/// See https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm.
class DijkstraSearchIterable<V> extends IterableBase<Path<V>> {
  DijkstraSearchIterable({
    required this.startVertices,
    required this.successorsOf,
    bool Function(V vertex)? targetPredicate,
    num Function(V source, V target)? edgeCost,
    StorageStrategy<V>? vertexStrategy,
  })  : targetPredicate = targetPredicate ?? constantFunction1(true),
        edgeCost = edgeCost ?? constantFunction2(1),
        vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> startVertices;
  final bool Function(V vertex) targetPredicate;
  final Iterable<V> Function(V vertex) successorsOf;
  final num Function(V source, V target) edgeCost;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<Path<V>> get iterator => _DijkstraSearchIterator<V>(this);
}

class _DijkstraSearchIterator<V> extends Iterator<Path<V>> {
  _DijkstraSearchIterator(this.iterable)
      : costs = iterable.vertexStrategy
            .createMap<num>()
            .withDefault(double.infinity),
        parents = iterable.vertexStrategy.createMap<V>() {
    todo = PriorityQueue<V>((a, b) => costs[a].compareTo(costs[b]));
    for (final vertex in iterable.startVertices) {
      costs[vertex] = 0;
      todo.add(vertex);
    }
  }

  final DijkstraSearchIterable<V> iterable;
  late final PriorityQueue<V> todo;
  final MapWithDefault<V, num> costs;
  final Map<V, V> parents;

  @override
  late Path<V> current;

  @override
  bool moveNext() {
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final target in iterable.successorsOf(vertex)) {
        final cost = costs[vertex] + iterable.edgeCost(vertex, target);
        if (cost < costs[target]) {
          costs[target] = cost;
          parents[target] = vertex;
          todo.remove(target);
          todo.add(target);
        }
      }
      if (iterable.targetPredicate(vertex)) {
        final vertices = QueueList<V>();
        for (V? parent = vertex; parent != null; parent = parents[parent]) {
          vertices.addFirst(parent);
        }
        current = DefaultPath<V>(vertices, costs[vertex]);
        return true;
      }
    }
    return false;
  }
}
