import '../traverse.dart';
import 'depth_first.dart';

/// Performs a topological sorting of vertices.
///
/// See https://en.wikipedia.org/wiki/Topological_sorting.
extension TopologicalGraphTraverseExtension<V> on GraphTraverse<V> {
  /// Traverses the vertices in a topological order, starting with [vertex].
  ///
  /// This traversal requires a predecessor-function, and ignores nodes that
  /// are part of cycles.
  Iterable<V> topological(V vertex) => topologicalAll([vertex]);

  /// Traverses the vertices in a topological order, starting with [vertices].
  ///
  /// This traversal requires a predecessor-function, and ignores nodes that
  /// are part of cycles.
  Iterable<V> topologicalAll(Iterable<V> vertices) sync* {
    ArgumentError.checkNotNull(predecessorsOf, 'predecessorFunction');
    final stack = <V>[];
    for (final vertex in depthFirstAll(vertices)) {
      if (predecessorsOf!(vertex).isEmpty) {
        stack.add(vertex);
      }
    }
    final seen = vertexStrategy.createSet();
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      if (seen.add(current)) {
        yield current;
        // Find successors with all visited predecessors to visit next.
        for (final next in successorsOf(current)) {
          if (predecessorsOf!(next).every((other) => seen.contains(other))) {
            stack.add(next);
          }
        }
      }
    }
    // Nodes that are part of cycles have not been visited at this point.
  }
}
