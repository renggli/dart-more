import 'dart:math';

import '../graph.dart';
import '../model/where.dart';
import '../strategy.dart';

/// Tarjan's strongly connected components.
///
/// https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm.
class TarjanStronglyConnected<V, E> {
  TarjanStronglyConnected(this.graph,
      {required StorageStrategy<V> vertexStrategy})
      : _states = vertexStrategy.createMap<_State<V>>() {
    for (final vertex in graph.vertices) {
      if (!_states.containsKey(vertex)) {
        _connect(vertex);
      }
    }
  }

  /// The underlying graph on which these strongly connected components are
  /// computed.
  final Graph<V, E> graph;

  // Internal state.
  final Map<V, _State<V>> _states;
  final _stack = <_State<V>>[];
  final _results = <Set<V>>{};

  /// Returns a set of strongly connected vertices.
  Set<Set<V>> get vertices => _results;

  /// Returns a set of the strongly connected sub-graphs.
  Set<Graph<V, E>> get graphs => _results
      .map((each) => graph.where(vertexPredicate: each.contains))
      .toSet();

  _State<V> _connect(V vertex) {
    // Set the depth to smallest unused index.
    final state = _State<V>(vertex, _states.length);
    _stack.add(_states[vertex] = state);
    // Consider all successors of `source`.
    for (final successor in graph.successorsOf(vertex)) {
      final successorState = _states[successor];
      if (successorState == null) {
        // Successors has not yet been visited, recurse on it.
        final createdState = _connect(successor);
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
        final state = _stack.removeLast();
        result.add(state.vertex);
        state.isObsolete = true;
        if (state.vertex == vertex) break;
      }
      _results.add(result);
    }
    // Return the state of vertex.
    return state;
  }
}

class _State<V> {
  _State(this.vertex, this.depth) : lowLink = depth;

  final V vertex;
  final int depth;
  int lowLink;
  bool isObsolete = false;
}
