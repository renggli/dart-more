import 'dart:collection';

import 'package:collection/collection.dart';

import '../../../functional.dart';
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
      : states = iterable.vertexStrategy.createMap<_State<V>>(),
        queue = PriorityQueue<_State<V>>(_stateCompare) {
    for (final vertex in iterable.startVertices) {
      final state =
          _State<V>(vertex: vertex, estimate: iterable.costEstimate(vertex));
      states[vertex] = state;
      queue.add(state);
    }
  }

  final AStarSearchIterable<V> iterable;
  final Map<V, _State<V>> states;
  final PriorityQueue<_State<V>> queue;

  @override
  late Path<V, num> current;

  @override
  bool moveNext() {
    while (queue.isNotEmpty) {
      final sourceState = queue.removeFirst();
      if (sourceState.isObsolete) continue;
      for (final target in iterable.successorsOf(sourceState.vertex)) {
        final value = iterable.edgeCost(sourceState.vertex, target);
        assert(
            value >= 0,
            'Expected positive edge weight between '
            '${sourceState.vertex} and $target');
        final total = sourceState.total + value;
        final targetState = states[target];
        if (targetState == null || total < targetState.total) {
          targetState?.isObsolete = true;
          final state = _State<V>(
              vertex: target,
              parent: sourceState,
              value: value,
              total: total,
              estimate: total + iterable.costEstimate(target));
          states[target] = state;
          queue.add(state);
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

final class _State<V> {
  _State({
    required this.vertex,
    this.parent,
    this.value = 0,
    this.total = 0,
    required this.estimate,
  });

  final V vertex;
  final _State<V>? parent;
  final num value;
  final num total;
  final num estimate;
  bool isObsolete = false;
}

int _stateCompare<V>(_State<V> a, _State<V> b) =>
    a.estimate.compareTo(b.estimate);
