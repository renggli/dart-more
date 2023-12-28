import 'dart:collection';

import 'package:collection/collection.dart';

import '../../../functional.dart';
import '../path.dart';
import '../strategy.dart';

/// Dijkstra's search algorithm.
///
/// See https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm.
class DijkstraSearchIterable<V> extends IterableBase<Path<V, num>> {
  DijkstraSearchIterable({
    required this.startVertices,
    required this.successorsOf,
    required this.targetPredicate,
    num Function(V source, V target)? edgeCost,
    StorageStrategy<V>? vertexStrategy,
  })  : edgeCost = edgeCost ?? constantFunction2(1),
        vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> startVertices;
  final bool Function(V vertex) targetPredicate;
  final Iterable<V> Function(V vertex) successorsOf;
  final num Function(V source, V target) edgeCost;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<Path<V, num>> get iterator => _DijkstraSearchIterator<V>(this);
}

class _DijkstraSearchIterator<V> implements Iterator<Path<V, num>> {
  _DijkstraSearchIterator(this.iterable)
      : states = iterable.vertexStrategy.createMap<_State<V>>(),
        queue = PriorityQueue<_State<V>>(_stateCompare) {
    for (final vertex in iterable.startVertices) {
      final state = _State<V>(vertex: vertex);
      states[vertex] = state;
      queue.add(state);
    }
  }

  final DijkstraSearchIterable<V> iterable;
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
          final state = _State<V>(
              vertex: target, parent: sourceState, value: value, total: total);
          targetState?.isObsolete = true;
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
  });

  final V vertex;
  final _State<V>? parent;
  final num value;
  final num total;
  bool isObsolete = false;
}

int _stateCompare<V>(_State<V> a, _State<V> b) => a.total.compareTo(b.total);
