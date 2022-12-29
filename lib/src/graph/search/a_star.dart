import 'dart:collection';

import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../../../functional.dart';
import '../model/path.dart';
import '../path.dart';
import '../strategy.dart';

/// Generalized A-Star search algorithm.
///
/// See https://en.wikipedia.org/wiki/A*_search_algorithm.
class AStarSearchIterable<V> extends IterableBase<Path<V>> {
  AStarSearchIterable({
    required this.startVertices,
    required this.successorsOf,
    required this.costEstimate,
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
  final num Function(V vertex) costEstimate;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<Path<V>> get iterator => _AStarSearchIterator<V>(this);
}

class _AStarSearchIterator<V> extends Iterator<Path<V>> {
  _AStarSearchIterator(this.iterable)
      : fScore = iterable.vertexStrategy
            .createMap<num>()
            .withDefault(double.infinity),
        gScore = iterable.vertexStrategy
            .createMap<num>()
            .withDefault(double.infinity),
        parents = iterable.vertexStrategy.createMap<V>() {
    todo = PriorityQueue<V>((a, b) => fScore[a].compareTo(fScore[b]));
    for (final vertex in iterable.startVertices) {
      fScore[vertex] = iterable.costEstimate(vertex);
      gScore[vertex] = 0;
      todo.add(vertex);
    }
  }

  final AStarSearchIterable<V> iterable;
  late final PriorityQueue<V> todo;
  final MapWithDefault<V, num> fScore;
  final MapWithDefault<V, num> gScore;
  final Map<V, V> parents;

  @override
  late Path<V> current;

  @override
  bool moveNext() {
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final target in iterable.successorsOf(vertex)) {
        final cost = gScore[vertex] + iterable.edgeCost(vertex, target);
        if (cost < gScore[target]) {
          gScore[target] = cost;
          fScore[target] = cost + iterable.costEstimate(target);
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
        current = DefaultPath<V>(vertices, gScore[vertex]);
        return true;
      }
    }
    return false;
  }
}
