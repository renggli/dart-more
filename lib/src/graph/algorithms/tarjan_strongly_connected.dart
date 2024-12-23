import 'dart:math';

import '../../../graph.dart';

/// Tarjan's strongly connected components.
///
/// See https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm.
Iterable<Set<V>> tarjanStronglyConnected<V>(
  Iterable<V> vertices, {
  required Iterable<V> Function(V vertex) successorsOf,
  required StorageStrategy<V> vertexStrategy,
}) {
  final states = vertexStrategy.createMap<_State<V>>();
  final stack = <_State<V>>[];
  final results = <Set<V>>[];
  for (final vertex in vertices) {
    if (!states.containsKey(vertex)) {
      _connect(states, stack, vertex, successorsOf, results);
    }
  }
  return results;
}

_State<V> _connect<V>(Map<V, _State<V>> states, List<_State<V>> stack, V vertex,
    Iterable<V> Function(V vertex) successorsOf, List<Set<V>> results) {
  // Set the depth to smallest unused index.
  final state = _State<V>(vertex, states.length);
  stack.add(states[vertex] = state);
  // Consider all successors of `source`.
  for (final successor in successorsOf(vertex)) {
    final successorState = states[successor];
    if (successorState == null) {
      // Successors has not yet been visited, recurse on it.
      final createdState =
          _connect(states, stack, successor, successorsOf, results);
      state.lowLink = min(state.lowLink, createdState.lowLink);
    } else if (!successorState.isObsolete) {
      // Successor is on stack and hence in the strongly connected component.
      state.lowLink = min(state.lowLink, successorState.depth);
    }
  }
  // If vertex is a root node, pop the stack and generate an strongly
  // connected component.
  if (state.lowLink == state.depth) {
    final result = <V>{};
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

class _State<V> {
  _State(this.vertex, this.depth) : lowLink = depth;

  final V vertex;
  final int depth;
  int lowLink;
  bool isObsolete = false;
}
