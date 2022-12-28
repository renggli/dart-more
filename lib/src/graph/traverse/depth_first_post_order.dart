import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../graph.dart';
import '../strategy.dart';
import 'depth_first.dart';

extension DepthFirstPostOrderGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a post-order depth-first search (after all its
  /// descendants have been discovered), starting with [vertex].
  Iterable<V> depthFirstPostOrder(V vertex,
          {StorageStrategy<V>? vertexStrategy}) =>
      depthFirstPostOrderAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a post-order depth-first search (after all its
  /// descendants have been discovered), starting with [vertices].
  Iterable<V> depthFirstPostOrderAll(Iterable<V> vertices,
          {StorageStrategy<V>? vertexStrategy}) =>
      PluggableIterable<V>(() => DepthFirstPostOrderIterator<V>(
            vertices,
            successorsOf: successorsOf,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          ));
}

/// Performs a post-order depth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Depth-first_search#Vertex_orderings.
class DepthFirstPostOrderIterator<V> extends Iterator<V> {
  DepthFirstPostOrderIterator(
    Iterable<V> vertices, {
    required this.successorsOf,
    required StorageStrategy<V> vertexStrategy,
  })  : stack = addAllReversed(<V>[], vertices),
        seen = vertexStrategy.createSet();

  final Iterable<V> Function(V vertex) successorsOf;
  final List<V> stack;
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    while (stack.isNotEmpty) {
      if (seen.add(stack.last)) {
        addAllReversed(stack, successorsOf(stack.last).whereNot(seen.contains));
      } else {
        current = stack.removeLast();
        return true;
      }
    }
    return false;
  }
}
