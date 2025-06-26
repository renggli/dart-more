import '../strategy.dart';

/// Checks if a graph is bipartite.
///
/// A graph is bipartite if the vertices can be divided into two disjoint and
/// independent sets, U and V, such that every edge connects a vertex in U to
/// one in V. This is equivalent to checking if the graph is 2-colorable or
/// has no odd-length cycles.
///
/// The algorithm traverses the graph using a breadth-first search approach. It
/// handles disconnected graphs by iterating through all vertices.
///
/// See https://en.wikipedia.org/wiki/Bipartite_graph.
bool isBipartite<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final colors = vertexStrategy.createMap<bool>();
  final queue = <V>[];
  for (final vertex in vertices) {
    if (colors.containsKey(vertex)) continue;
    colors[vertex] = true;
    queue.add(vertex);
    while (queue.isNotEmpty) {
      final source = queue.removeLast();
      final sourceColor = colors[source]!;
      for (final target in successorsOf(source)) {
        if (colors.containsKey(target)) {
          final targetColor = colors[target]!;
          if (sourceColor == targetColor) {
            return false;
          }
        } else {
          colors[target] = !sourceColor;
          queue.add(target);
        }
      }
    }
  }
  return true;
}
