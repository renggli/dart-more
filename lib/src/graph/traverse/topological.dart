import 'dart:collection';

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
      TopologicalIterable<V>(vertices,
          predecessorsOf: predecessorsOf,
          successorsOf: successorsOf,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy);
}

/// Iterable over the topological sorting of vertices.
///
/// See https://en.wikipedia.org/wiki/Topological_sorting.
class TopologicalIterable<V> extends IterableBase<V> {
  TopologicalIterable(this.vertices,
      {required this.predecessorsOf,
      required this.successorsOf,
      StorageStrategy<V>? vertexStrategy})
      : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> vertices;
  final Iterable<V> Function(V vertex) predecessorsOf;
  final Iterable<V> Function(V vertex) successorsOf;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<V> get iterator => _TopologicalIterator<V>(this);
}

class _TopologicalIterator<V> extends Iterator<V> {
  _TopologicalIterator(this.iterable)
      : seen = iterable.vertexStrategy.createSet() {
    for (final vertex in DepthFirstIterable(iterable.vertices,
        successorsOf: iterable.successorsOf)) {
      if (iterable.predecessorsOf(vertex).isEmpty) {
        todo.add(vertex);
      }
    }
  }

  final TopologicalIterable<V> iterable;
  final List<V> todo = <V>[];
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    while (todo.isNotEmpty) {
      current = todo.removeLast();
      if (seen.add(current)) {
        for (final next in iterable.successorsOf(current)) {
          if (iterable
              .predecessorsOf(next)
              .every((other) => seen.contains(other))) {
            todo.add(next);
          }
        }
        return true;
      }
    }
    return false;
  }
}
