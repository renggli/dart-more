import '../strategy.dart';

/// Checks if a directed graph has a cycle.
///
/// The algorithm traverses the graph using a depth-first search approach. It
/// handles disconnected graphs by iterating through all vertices.
///
/// See https://en.wikipedia.org/wiki/Cycle_(graph_theory)#Cycle_detection
bool hasCycle<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final visiting = vertexStrategy.createSet();
  final visited = vertexStrategy.createSet();

  // Iterative depth-first search to avoid stack overflows on deep graphs.
  final stack = <(V, Iterator<V>)>[];
  for (final vertex in vertices) {
    if (visited.contains(vertex)) continue;
    visiting.add(vertex);
    stack.add((vertex, successorsOf(vertex).iterator));
    while (stack.isNotEmpty) {
      final (current, iterator) = stack.last;
      if (iterator.moveNext()) {
        final successor = iterator.current;
        if (visiting.contains(successor)) return true;
        if (!visited.contains(successor)) {
          visiting.add(successor);
          stack.add((successor, successorsOf(successor).iterator));
        }
      } else {
        stack.removeLast();
        visiting.remove(current);
        visited.add(current);
      }
    }
  }
  return false;
}
