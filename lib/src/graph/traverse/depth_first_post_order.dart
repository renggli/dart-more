import 'dart:collection';

import 'package:collection/collection.dart';

import '../graph.dart';
import '../strategy.dart';
import 'depth_first.dart';

/// Extension on [Graph] to perform depth-first post-order traversals.
extension DepthFirstPostOrderGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a depth-first order, starting with [vertex].
  Iterable<V> depthFirstPostOrder(
    V vertex, {
    StorageStrategy<V>? vertexStrategy,
  }) => depthFirstPostOrderAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a depth-first order, starting with [vertices].
  Iterable<V> depthFirstPostOrderAll(
    Iterable<V> vertices, {
    StorageStrategy<V>? vertexStrategy,
  }) => DepthFirstPostOrderIterable<V>(
    vertices,
    successorsOf: successorsOf,
    vertexStrategy: vertexStrategy ?? this.vertexStrategy,
  );
}

/// Iterable over the post-order depth-first traversal of vertices. The vertices
/// are emitted post-order, that is after all its descendants have been
/// discovered.
///
/// See https://en.wikipedia.org/wiki/Depth-first_search#Vertex_orderings.
class DepthFirstPostOrderIterable<V> extends IterableBase<V> {
  new(
    this.vertices, {
    required this.successorsOf,
    StorageStrategy<V>? vertexStrategy,
  }) : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> vertices;
  final Iterable<V> Function(V vertex) successorsOf;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<V> get iterator => _DepthFirstPostOrderIterator<V>(this);
}

class _DepthFirstPostOrderIterator<V> implements Iterator<V> {
  new(this.iterable)
    : todo = addAllReversed(<V>[], iterable.vertices),
      seen = iterable.vertexStrategy.createSet(),
      emitted = iterable.vertexStrategy.createSet();

  final DepthFirstPostOrderIterable<V> iterable;
  final List<V> todo;
  final Set<V> seen;
  final Set<V> emitted;

  @override
  late V current;

  @override
  bool moveNext() {
    while (todo.isNotEmpty) {
      final vertex = todo.last;
      if (emitted.contains(vertex)) {
        todo.removeLast();
      } else if (seen.add(vertex)) {
        addAllReversed(
          todo,
          iterable.successorsOf(vertex).whereNot(seen.contains),
        );
      } else {
        current = todo.removeLast();
        emitted.add(current);
        return true;
      }
    }
    return false;
  }
}
