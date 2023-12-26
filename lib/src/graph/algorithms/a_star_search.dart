import 'dart:collection';

import '../../../functional.dart';
import '../../collection/heap.dart';
import '../path.dart';
import '../strategy.dart';

/// A-Star search algorithm.
///
/// See https://en.wikipedia.org/wiki/A*_search_algorithm.
class AStarSearchIterable<V> extends IterableBase<Path<V, num>> {
  AStarSearchIterable({
    required this.startVertices,
    required this.successorsOf,
    required this.costEstimate,
    required this.targetPredicate,
    num Function(V source, V target)? edgeCost,
    StorageStrategy<V>? vertexStrategy,
  })  : edgeCost = edgeCost ?? constantFunction2(1),
        vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> startVertices;
  final bool Function(V vertex) targetPredicate;
  final Iterable<V> Function(V vertex) successorsOf;
  final num Function(V source, V target) edgeCost;
  final num Function(V source) costEstimate;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<Path<V, num>> get iterator => _AStarSearchIterator<V>(this);
}

class _AStarSearchIterator<V> implements Iterator<Path<V, num>> {
  _AStarSearchIterator(this.iterable)
      : states = iterable.vertexStrategy.createMap<_State<V>>() {
    for (final source in iterable.startVertices) {
      final state =
          _State<V>(vertex: source, estimate: iterable.costEstimate(source));
      states[source] = state;
      todo.add(state);
    }
  }

  final AStarSearchIterable<V> iterable;
  final Map<V, _State<V>> states;
  final todo = Heap<_State<V>>();

  @override
  late Path<V, num> current;

  @override
  bool moveNext() {
    while (todo.isNotEmpty) {
      final sourceState = todo.removeFirst();
      for (final target in iterable.successorsOf(sourceState.vertex)) {
        final value = iterable.edgeCost(sourceState.vertex, target);
        final total = sourceState.total + value;
        final targetState = states[target];
        if (targetState == null) {
          final state = _State<V>(
              vertex: target,
              parent: sourceState,
              value: value,
              total: total,
              estimate: total + iterable.costEstimate(target));
          states[target] = state;
          todo.add(state);
        } else if (total < targetState.total) {
          todo.remove(targetState);
          targetState.parent = sourceState;
          targetState.value = value;
          targetState.total = total;
          targetState.estimate = total + iterable.costEstimate(target);
          todo.add(targetState);
        }
      }
      if (iterable.targetPredicate(sourceState.vertex)) {
        final vertices = <V>[], values = <num>[];
        for (_State<V>? state = sourceState;
            state != null;
            state = state.parent) {
          vertices.add(state.vertex);
          values.add(state.value);
        }
        if (values.isNotEmpty) values.removeLast();
        current = Path<V, num>.fromVertices(vertices.reversed,
            values: values.reversed);
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
    this.value = 0,
    this.total = 0,
    required this.estimate,
  });

  final V vertex;
  _State<V>? parent;
  num value;
  num total;
  num estimate;

  @override
  int compareTo(_State<V> other) => estimate.compareTo(other.estimate);

  @override
  String toString() => '$vertex|$estimate';
}
