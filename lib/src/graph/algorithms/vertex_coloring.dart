import '../strategy.dart';

/// Computes a greedy coloring of the vertices in a graph.
///
/// The algorithm iterates over all vertices and assigns the smallest integer
/// color that is not used by any of the neighbours.
///
/// The result is a map from vertex to color (integer).
///
/// See https://en.wikipedia.org/wiki/Graph_coloring for more information.
Map<V, int> vertexColoring<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final colors = vertexStrategy.createMap<int>();
  for (final vertex in vertices) {
    final neighbourColors = <int>{};
    for (final neighbour in neighboursOf(vertex)) {
      if (colors.containsKey(neighbour)) {
        neighbourColors.add(colors[neighbour]!);
      }
    }
    var color = 0;
    while (neighbourColors.contains(color)) {
      color++;
    }
    colors[vertex] = color;
  }
  return colors;
}
