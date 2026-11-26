import 'dart:collection';

import '../graph.dart';
import '../strategy.dart';
import 'depth_first.dart';

/// Extension on [Graph] to perform topological traversals.
extension TopologicalGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a topological order, starting with [vertex].
  Iterable<V> topological(V vertex, {StorageStrategy<V>? vertexStrategy}) =>
      topologicalAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a topological order, starting with [vertices].
  Iterable<V> topologicalAll(
    Iterable<V> vertices, {
    StorageStrategy<V>? vertexStrategy,
  }) => TopologicalIterable<V>(
    vertices,
    predecessorsOf: predecessorsOf,
    successorsOf: successorsOf,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );
}

/// Iterable over the topological sorting of vertices. This traversal requires a
/// predecessor-function, and ignores nodes that are part of cycles.
///
/// See https://en.wikipedia.org/wiki/Topological_sorting.
class TopologicalIterable<V> extends IterableBase<V> {
  new(
    this.vertices, {
    required this.predecessorsOf,
    required this.successorsOf,
    StorageStrategy<V>? vertexStrategy,
  }) : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> vertices;
  final Iterable<V> Function(V vertex) predecessorsOf;
  final Iterable<V> Function(V vertex) successorsOf;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<V> get iterator => _TopologicalIterator<V>(this);
}

class _TopologicalIterator<V> implements Iterator<V> {
  new(this.iterable) : inDegree = iterable.vertexStrategy.createMap<int>() {
    final reachable = DepthFirstIterable(
      iterable.vertices,
      successorsOf: iterable.successorsOf,
      vertexStrategy: iterable.vertexStrategy,
    ).toList(growable: false);
    final reachableSet = iterable.vertexStrategy.createSet()..addAll(reachable);
    for (final vertex in reachable) {
      final degree = iterable
          .predecessorsOf(vertex)
          .where(reachableSet.contains)
          .length;
      if (degree == 0) {
        todo.add(vertex);
      } else {
        inDegree[vertex] = degree;
      }
    }
  }

  final TopologicalIterable<V> iterable;
  final List<V> todo = <V>[];
  final Map<V, int> inDegree;

  @override
  late V current;

  @override
  bool moveNext() {
    if (todo.isEmpty) return false;
    current = todo.removeLast();
    for (final next in iterable.successorsOf(current)) {
      final remaining = inDegree[next];
      if (remaining != null) {
        if (remaining == 1) {
          inDegree.remove(next);
          todo.add(next);
        } else {
          inDegree[next] = remaining - 1;
        }
      }
    }
    return true;
  }
}
