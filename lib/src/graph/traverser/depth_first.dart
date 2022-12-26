import 'package:collection/collection.dart';

import '../traverser.dart';

extension DepthFirstTraverserExtension<V> on Traverser<V> {
  /// Traverses the vertices in a pre-order depth-first search (when they are
  /// first discovered), starting with [vertex].
  Iterable<V> depthFirstPreOrder(V vertex) => depthFirstPreOrderAll([vertex]);

  /// Traverses the vertices in a pre-order depth-first search (when they are
  /// first discovered), starting with [vertices].
  Iterable<V> depthFirstPreOrderAll(Iterable<V> vertices) sync* {
    final seen = vertexStrategy.createSet()..addAll(vertices);
    final stack = addAllReversed(<V>[], vertices);
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      yield current;
      addAllReversed(stack, successorFunction(current).where(seen.add));
    }
  }

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

List<T> addAllReversed<T>(List<T> target, Iterable<T> iterable) {
  final original = target.length;
  return target
    ..addAll(iterable)
    ..reverseRange(original, target.length);
}
