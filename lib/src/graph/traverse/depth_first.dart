import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../graph.dart';
import '../strategy.dart';

extension DepthFirstGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a pre-order depth-first search (when they are
  /// first discovered), starting with [vertex].
  Iterable<V> depthFirst(V vertex, {StorageStrategy<V>? vertexStrategy}) =>
      depthFirstAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a pre-order depth-first search (when they are
  /// first discovered), starting with [vertices].
  Iterable<V> depthFirstAll(Iterable<V> vertices,
          {StorageStrategy<V>? vertexStrategy}) =>
      PluggableIterable<V>(() => DepthFirstIterator<V>(
            vertices,
            successorsOf: successorsOf,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          ));
}

/// Performs a depth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Depth-first_search.
class DepthFirstIterator<V> extends Iterator<V> {
  DepthFirstIterator(
    Iterable<V> vertices, {
    required this.successorsOf,
    required StorageStrategy<V> vertexStrategy,
  })  : stack = addAllReversed(<V>[], vertices),
        seen = vertexStrategy.createSet()..addAll(vertices);

  final Iterable<V> Function(V vertex) successorsOf;
  final List<V> stack;
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    if (stack.isEmpty) return false;
    current = stack.removeLast();
    addAllReversed(stack, successorsOf(current).where(seen.add));
    return true;
  }
}

List<T> addAllReversed<T>(List<T> target, Iterable<T> iterable) {
  final original = target.length;
  return target
    ..addAll(iterable)
    ..reverseRange(original, target.length);
}
