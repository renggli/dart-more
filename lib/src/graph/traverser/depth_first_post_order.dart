import 'package:collection/collection.dart';

import '../traverser.dart';
import 'depth_first.dart';

extension DepthFirstPostOrderTraverserExtension<V> on Traverser<V> {
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
        addAllReversed(
            stack, successorFunction(stack.last).whereNot(seen.contains));
      } else {
        yield stack.removeLast();
      }
    }
  }
}
