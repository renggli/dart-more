import 'package:collection/collection.dart';

import '../traverser.dart';

/// Performs a depth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Depth-first_search.
extension DepthFirstTraverserExtension<V> on Traverser<V> {
  /// Traverses the vertices in a pre-order depth-first search (when they are
  /// first discovered), starting with [vertex].
  Iterable<V> depthFirst(V vertex) => depthFirstAll([vertex]);

  /// Traverses the vertices in a pre-order depth-first search (when they are
  /// first discovered), starting with [vertices].
  Iterable<V> depthFirstAll(Iterable<V> vertices) sync* {
    final seen = vertexStrategy.createSet()..addAll(vertices);
    final stack = addAllReversed(<V>[], vertices);
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      yield current;
      addAllReversed(stack, successorFunction(current).where(seen.add));
    }
  }
}

List<T> addAllReversed<T>(List<T> target, Iterable<T> iterable) {
  final original = target.length;
  return target
    ..addAll(iterable)
    ..reverseRange(original, target.length);
}
