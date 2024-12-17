import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../path.dart';

/// Generic helper for all the path search algorithms.
mixin PathSearch<V, E> {
  /// Find all the paths starting at `startVertices` and that end at a vertex
  /// satisfying the `targetPredicate`.
  Iterable<Path<V, E>> find({
    required Iterable<V> startVertices,
    required bool Function(V vertex) targetPredicate,
  });

  @internal
  Path<V, E> createShortestPath(State<V, E> last) {
    final vertices = QueueList<V>();
    final values = QueueList<E>();
    for (State<V, E>? state = last;
        state != null;
        state = state.parents.firstOrNull) {
      vertices.addFirst(state.vertex);
      values.addFirst(state.value);
    }
    if (values.isNotEmpty) values.removeFirst();
    return Path<V, E>.fromVertices(vertices, values: values);
  }

  @internal
  Iterable<Path<V, E>> createAllShortestPaths(State<V, E> state) sync* {
    final seen = {state};
    final stack = [(state, 0)];
    var top = 0;
    while (top >= 0) {
      final (state, i) = stack[top];
      if (state.parents.isEmpty) {
        final list = stack.sublist(0, top + 1).reversed;
        yield Path<V, E>.fromVertices(
          list.map((state) => state.$1.vertex),
          values: list.skip(1).map((state) => state.$1.value),
        );
      }
      if (i < state.parents.length) {
        stack[top] = (state, i + 1);
        final next = state.parents[i];
        if (!seen.add(next)) continue;
        top++;
        if (stack.length == top) {
          stack.add((next, 0));
        } else {
          stack[top] = (next, 0);
        }
      } else {
        seen.remove(state);
        top--;
      }
    }
  }
}

class State<V, E> {
  State({required this.vertex, required this.value});

  final V vertex;
  final E value;
  final List<State<V, E>> parents = [];
}
