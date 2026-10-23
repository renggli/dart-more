import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../path.dart';

/// Abstract helper for search algorithms to represent vertex specific state.
abstract class SearchState<V, E> {
  new();

  /// The vertex of this state.
  V get vertex;

  /// The predecessors of the vertex (typically just one) with edge values.
  List<(SearchState<V, E> state, E value)> get predecessors;
}

Path<V, E> createShortestPath<V, E>(
  SearchState<V, E> last, {
  Iterable<V> startVertices = const [],
}) {
  final vertices = QueueList<V>();
  final values = QueueList<E>();
  SearchState<V, E>? state = last;
  while (state != null) {
    vertices.addFirst(state.vertex);
    if (startVertices.contains(state.vertex)) break;
    final pred = state.predecessors.firstOrNull;
    if (pred == null) break;
    values.addFirst(pred.$2);
    state = pred.$1;
  }
  return Path<V, E>.fromVertices(vertices, values: values);
}

@internal
Iterable<Path<V, E>> createAllShortestPaths<V, E>(
  SearchState<V, E> state, {
  Iterable<V> startVertices = const [],
}) sync* {
  final seen = {state};
  final stack = [(state: state, value: null as E?, index: 0)];
  var top = 0;
  while (top >= 0) {
    final (:state, :value, :index) = stack[top];
    if (state.predecessors.isEmpty || startVertices.contains(state.vertex)) {
      final list = stack.sublist(0, top + 1).reversed;
      yield Path<V, E>.fromVertices(
        list.map((step) => step.state.vertex),
        values: list.take(top).map((step) => step.value as E),
      );
    } else if (index < state.predecessors.length) {
      stack[top] = (state: state, value: value, index: index + 1);
      final (next, edgeValue) = state.predecessors[index];
      if (!seen.add(next)) continue;
      top++;
      if (stack.length == top) {
        stack.add((state: next, value: edgeValue, index: 0));
      } else {
        stack[top] = (state: next, value: edgeValue, index: 0);
      }
      continue;
    }
    seen.remove(state);
    top--;
  }
}
