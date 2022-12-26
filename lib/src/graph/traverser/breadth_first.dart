import 'dart:collection';

import '../traverser.dart';

/// Performs a breadth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Breadth-first_search.
extension BreadthFirstTraverserExtension<V> on Traverser<V> {
  /// Traverses the vertices in a breadth-first search, starting with [vertex].
  Iterable<V> breadthFirst(V vertex) => breadthFirstAll([vertex]);

  /// Traverses the vertices in a breadth-first search, starting with [vertices].
  Iterable<V> breadthFirstAll(Iterable<V> vertices) sync* {
    final queue = Queue<V>.of(vertices);
    final seen = vertexStrategy.createSet()..addAll(vertices);
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      yield current;
      for (final next in successorFunction(current)) {
        if (seen.add(next)) {
          queue.add(next);
        }
      }
    }
  }
}
