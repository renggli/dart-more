import 'dart:math';

import '../../../graph.dart';

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
  final results = <Set<V>>[];
  final stack = <_State<V>>[];

  _State<V> connect(V vertex) {
    // Set the depth to smallest unused index.
    final state = _State<V>(vertex, states.length);
    stack.add(states[vertex] = state);
    // Consider all successors of `source`.
    for (final successor in successorsOf(vertex)) {
      final successorState = states[successor];
      if (successorState == null) {
        // Successors has not yet been visited, recurse on it.
        final createdState = connect(successor);
        state.lowLink = min(state.lowLink, createdState.lowLink);
      } else if (!successorState.isObsolete) {
        // Successor is on stack and hence in the strongly connected component.
        state.lowLink = min(state.lowLink, successorState.depth);
      }
    }
    // If vertex is a root node, pop the stack and generate an strongly
    // connected component.
    if (state.lowLink == state.depth) {
      final result = vertexStrategy.createSet();
      while (true) {
        final state = stack.removeLast();
        result.add(state.vertex);
        state.isObsolete = true;
        if (state.vertex == vertex) break;
      }
      results.add(result);
    }
    // Return the state of vertex.
    return state;
  }

  for (final vertex in vertices) {
    if (!states.containsKey(vertex)) {
      results.clear();
      connect(vertex);
      yield* results;
    }
  }
}

class _State<V> {
  _State(this.vertex, this.depth) : lowLink = depth;

  final V vertex;
  final int depth;
  int lowLink;
  bool isObsolete = false;
}
