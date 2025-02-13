import 'dart:collection';

import 'package:collection/collection.dart';

import '../graph.dart';
import '../strategy.dart';

extension DepthFirstGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a depth-first order, starting with [vertex].
  Iterable<V> depthFirst(V vertex, {StorageStrategy<V>? vertexStrategy}) =>
      depthFirstAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a depth-first order, starting with [vertices].
  Iterable<V> depthFirstAll(
    Iterable<V> vertices, {
    StorageStrategy<V>? vertexStrategy,
  }) => DepthFirstIterable<V>(
    vertices,
    successorsOf: successorsOf,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );
}

/// Iterable over the depth-first traversal of vertices. The vertices are
/// emitted pre-order, that is right when they are first discovered.
///
/// See https://en.wikipedia.org/wiki/Depth-first_search.
class DepthFirstIterable<V> extends IterableBase<V> {
  DepthFirstIterable(
    this.vertices, {
    required this.successorsOf,
    StorageStrategy<V>? vertexStrategy,
  }) : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> vertices;
  final Iterable<V> Function(V vertex) successorsOf;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<V> get iterator => _DepthFirstIterator<V>(this);
}

class _DepthFirstIterator<V> implements Iterator<V> {
  _DepthFirstIterator(this.iterable)
    : todo = addAllReversed(<V>[], iterable.vertices),
      seen = iterable.vertexStrategy.createSet()..addAll(iterable.vertices);

  final DepthFirstIterable<V> iterable;
  final List<V> todo;
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    if (todo.isEmpty) return false;
    current = todo.removeLast();
    addAllReversed(todo, iterable.successorsOf(current).where(seen.add));
    return true;
  }
}

List<T> addAllReversed<T>(List<T> target, Iterable<T> iterable) {
  final original = target.length;
  return target
    ..addAll(iterable)
    ..reverseRange(original, target.length);
}
