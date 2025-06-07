import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../path.dart';

/// Abstract helper for search algorithms to represent vertex specific state.
abstract class SearchState<V, E> {
  SearchState({required this.vertex});

  /// The vertex of this state.
  final V vertex;

  /// The edge value from the predecessors to the vertex.
  E get value;

  /// The predecessors of the vertex (typically just one).
  List<SearchState<V, E>> get predecessors;
}

Path<V, E> createShortestPath<V, E>(
  SearchState<V, E> last, {
  Iterable<V> startVertices = const [],
}) {
  final vertices = QueueList<V>();
  final values = QueueList<E>();
  for (
    SearchState<V, E>? state = last;
    state != null;
    state = state.predecessors.firstOrNull
  ) {
    vertices.addFirst(state.vertex);
    values.addFirst(state.value);
    if (startVertices.contains(state.vertex)) break;
  }
  if (values.isNotEmpty) values.removeFirst();
  return Path<V, E>.fromVertices(vertices, values: values);
}

@internal
Iterable<Path<V, E>> createAllShortestPaths<V, E>(
  SearchState<V, E> state, {
  Iterable<V> startVertices = const [],
}) sync* {
  final seen = {state};
  final stack = [(state, 0)];
  var top = 0;
  while (top >= 0) {
    final (state, i) = stack[top];
    if (state.predecessors.isEmpty || startVertices.contains(state.vertex)) {
      final list = stack.sublist(0, top + 1).reversed;
      yield Path<V, E>.fromVertices(
        list.map((state) => state.$1.vertex),
        values: list.skip(1).map((state) => state.$1.value),
      );
    }
    if (i < state.predecessors.length) {
      stack[top] = (state, i + 1);
      final next = state.predecessors[i];
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
