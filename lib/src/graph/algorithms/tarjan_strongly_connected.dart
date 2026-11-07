import 'dart:math';

import '../strategy.dart';

/// The Tarjan's algorithm enumerates the strongly connected components (SCCs).
/// It runs in linear time.
///
/// See https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm.
Iterable<Set<V>> tarjanStronglyConnected<V>(
  Iterable<V> vertices, {
  required Iterable<V> Function(V vertex) successorsOf,
  required StorageStrategy<V> vertexStrategy,
}) sync* {
  final states = vertexStrategy.createMap<_State<V>>();
  final stack = <_State<V>>[];
  // Explicit call stack to avoid stack overflows on deep graphs.
  final callStack = <(_State<V>, Iterator<V>)>[];

  _State<V> visit(V vertex) {
    // Set the depth to smallest unused index.
    final state = _State<V>(vertex, states.length);
    stack.add(states[vertex] = state);
    callStack.add((state, successorsOf(vertex).iterator));
    return state;
  }

  for (final vertex in vertices) {
    if (states.containsKey(vertex)) continue;
    visit(vertex);
    while (callStack.isNotEmpty) {
      final (state, iterator) = callStack.last;
      if (iterator.moveNext()) {
        final successor = iterator.current;
        final successorState = states[successor];
        if (successorState == null) {
          // Successor has not yet been visited, descend into it.
          visit(successor);
        } else if (!successorState.isObsolete) {
          // Successor is on stack and hence in the strongly connected component.
          state.lowLink = min(state.lowLink, successorState.depth);
        }
        continue;
      }
      callStack.removeLast();
      // Propagate the low-link to the parent.
      if (callStack.isNotEmpty) {
        final parent = callStack.last.$1;
        parent.lowLink = min(parent.lowLink, state.lowLink);
      }
      // If vertex is a root node, pop the stack and generate a strongly
      // connected component.
      if (state.lowLink == state.depth) {
        final result = vertexStrategy.createSet();
        while (true) {
          final current = stack.removeLast();
          result.add(current.vertex);
          current.isObsolete = true;
          if (identical(current, state)) break;
        }
        yield result;
      }
    }
  }
}

class _State<V> {
  new(this.vertex, this.depth) : lowLink = depth;

  final V vertex;
  final int depth;
  int lowLink;
  bool isObsolete = false;
}
