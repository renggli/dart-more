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

  bool hasCycleFrom(V vertex) {
    visiting.add(vertex);
    for (final successor in successorsOf(vertex)) {
      if (visiting.contains(successor)) {
        return true;
      }
      if (!visited.contains(successor)) {
        if (hasCycleFrom(successor)) return true;
      }
    }
    visiting.remove(vertex);
    visited.add(vertex);
    return false;
  }

  for (final vertex in vertices) {
    if (!visited.contains(vertex) && hasCycleFrom(vertex)) return true;
  }

  return false;
}
