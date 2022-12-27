import 'package:collection/collection.dart';

import '../traverse.dart';
import 'depth_first.dart';

/// Performs a post-order depth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Depth-first_search#Vertex_orderings.
extension DepthFirstPostOrderGraphTraverseExtension<V> on GraphTraverse<V> {
  /// Traverses the vertices in a post-order depth-first search (after all its
  /// descendants have been discovered), starting with [vertex].
  Iterable<V> depthFirstPostOrder(V vertex) => depthFirstPostOrderAll([vertex]);

  /// Traverses the vertices in a post-order depth-first search (after all its
  /// descendants have been discovered), starting with [vertices].
  Iterable<V> depthFirstPostOrderAll(Iterable<V> vertices) sync* {
    final seen = vertexStrategy.createSet();
    final stack = addAllReversed(<V>[], vertices);
    while (stack.isNotEmpty) {
      if (seen.add(stack.last)) {
        addAllReversed(stack, successorsOf(stack.last).whereNot(seen.contains));
      } else {
        yield stack.removeLast();
      }
    }
  }
}
