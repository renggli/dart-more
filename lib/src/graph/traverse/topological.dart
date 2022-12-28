import '../../../collection.dart';
import '../graph.dart';
import '../strategy.dart';
import 'depth_first.dart';

extension TopologicalGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a topological order, starting with [vertex].
  ///
  /// This traversal requires a predecessor-function, and ignores nodes that
  /// are part of cycles.
  Iterable<V> topological(V vertex, {StorageStrategy<V>? vertexStrategy}) =>
      topologicalAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a breadth-first search, starting with [vertices].
  Iterable<V> topologicalAll(Iterable<V> vertices,
          {StorageStrategy<V>? vertexStrategy}) =>
      PluggableIterable<V>(() => TopologicalIterator<V>(
            vertices,
            successorsOf: successorsOf,
            predecessorsOf: predecessorsOf,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          ));
}

/// Performs a topological sorting of vertices.
///
/// See https://en.wikipedia.org/wiki/Topological_sorting.
class TopologicalIterator<V> extends Iterator<V> {
  TopologicalIterator(
    Iterable<V> vertices, {
    required this.predecessorsOf,
    required this.successorsOf,
    required StorageStrategy<V> vertexStrategy,
  }) : seen = vertexStrategy.createSet() {
    final iterator = DepthFirstIterator<V>(vertices,
        successorsOf: successorsOf, vertexStrategy: vertexStrategy);
    while (iterator.moveNext()) {
      if (predecessorsOf(iterator.current).isEmpty) {
        stack.add(iterator.current);
      }
    }
  }

  final Iterable<V> Function(V vertex) predecessorsOf;
  final Iterable<V> Function(V vertex) successorsOf;
  final List<V> stack = <V>[];
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    while (stack.isNotEmpty) {
      current = stack.removeLast();
      if (seen.add(current)) {
        for (final next in successorsOf(current)) {
          if (predecessorsOf(next).every((other) => seen.contains(other))) {
            stack.add(next);
          }
        }
        return true;
      }
    }
    return false;
  }
}
