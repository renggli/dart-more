import 'dart:collection';

import 'package:collection/collection.dart';

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
      : states = iterable.vertexStrategy.createMap<_State<V>>() {
    for (final vertex in iterable.startVertices) {
      final state = _State<V>(
        vertex: vertex,
        cost: 0,
        estimate: iterable.costEstimate(vertex),
      );
      states[vertex] = state;
      todo.add(state);
    }
  }

  final AStarSearchIterable<V> iterable;
  final Map<V, _State<V>> states;
  final PriorityQueue<_State<V>> todo = PriorityQueue();

  @override
  late Path<V> current;

  @override
  bool moveNext() {
    while (todo.isNotEmpty) {
      final sourceState = todo.removeFirst();
      for (final target in iterable.successorsOf(sourceState.vertex)) {
        final cost =
            sourceState.cost + iterable.edgeCost(sourceState.vertex, target);
        final targetState =
            states.putIfAbsent(target, () => _State<V>(vertex: target));
        if (cost < targetState.cost) {
          targetState.cost = cost;
          targetState.estimate = cost + iterable.costEstimate(target);
          targetState.parent = sourceState;
          todo.remove(targetState);
          todo.add(targetState);
        }
      }
      if (iterable.targetPredicate(sourceState.vertex)) {
        final vertices = QueueList<V>();
        for (_State<V>? state = sourceState;
            state != null;
            state = state.parent) {
          vertices.addFirst(state.vertex);
        }
        current = DefaultPath<V>(vertices, sourceState.cost);
        return true;
      }
    }
    return false;
  }
}

class _State<V> implements Comparable<_State<V>> {
  _State({
    required this.vertex,
    this.parent,
    this.estimate = double.infinity,
    this.cost = double.infinity,
  });

  final V vertex;
  _State<V>? parent;
  num cost;
  num estimate;

  @override
  int compareTo(_State<V> other) => estimate.compareTo(other.estimate);
}
