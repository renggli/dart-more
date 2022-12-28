import 'dart:collection';

import 'package:collection/collection.dart';

import '../graph.dart';
import '../strategy.dart';

extension BreadthFirstGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a breadth-first search, starting with [vertex].
  Iterable<V> breadthFirst(V vertex, {StorageStrategy<V>? vertexStrategy}) =>
      breadthFirstAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a breadth-first search, starting with [vertices].
  Iterable<V> breadthFirstAll(Iterable<V> vertices,
          {StorageStrategy<V>? vertexStrategy}) =>
      BreadthFirstIterable<V>(vertices,
          successorsOf: successorsOf,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy);
}

/// Iterable over the breadth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Breadth-first_search.
class BreadthFirstIterable<V> extends IterableBase<V> {
  BreadthFirstIterable(this.vertices,
      {required this.successorsOf, StorageStrategy<V>? vertexStrategy})
      : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final Iterable<V> vertices;
  final Iterable<V> Function(V vertex) successorsOf;
  final StorageStrategy<V> vertexStrategy;

  @override
  Iterator<V> get iterator => _BreadthFirstIterator<V>(this);
}

class _BreadthFirstIterator<V> extends Iterator<V> {
  _BreadthFirstIterator(this.iterable)
      : todo = QueueList<V>.from(iterable.vertices),
        seen = iterable.vertexStrategy.createSet()..addAll(iterable.vertices);

  final BreadthFirstIterable<V> iterable;
  final QueueList<V> todo;
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    if (todo.isEmpty) return false;
    current = todo.removeFirst();
    for (final next in iterable.successorsOf(current)) {
      if (seen.add(next)) {
        todo.addLast(next);
      }
    }
    return true;
  }
}
