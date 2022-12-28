import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../graph.dart';
import '../strategy.dart';

extension BreadthFirstGraphExtension<V, E> on Graph<V, E> {
  /// Traverses the vertices in a breadth-first search, starting with [vertex].
  Iterable<V> breadthFirst(V vertex, {StorageStrategy<V>? vertexStrategy}) =>
      breadthFirstAll([vertex], vertexStrategy: vertexStrategy);

  /// Traverses the vertices in a breadth-first search, starting with [vertices].
  Iterable<V> breadthFirstAll(Iterable<V> vertices,
          {StorageStrategy<V>? vertexStrategy}) =>
      PluggableIterable<V>(() => BreadthFirstIterator<V>(
            vertices,
            successorsOf: successorsOf,
            vertexStrategy: vertexStrategy ?? this.vertexStrategy,
          ));
}

/// Performs a breadth-first traversal of vertices.
///
/// See https://en.wikipedia.org/wiki/Breadth-first_search.
class BreadthFirstIterator<V> extends Iterator<V> {
  BreadthFirstIterator(
    Iterable<V> vertices, {
    required this.successorsOf,
    required StorageStrategy<V> vertexStrategy,
  })  : todo = QueueList<V>()..addAll(vertices),
        seen = vertexStrategy.createSet()..addAll(vertices);

  final Iterable<V> Function(V vertex) successorsOf;
  final QueueList<V> todo;
  final Set<V> seen;

  @override
  late V current;

  @override
  bool moveNext() {
    if (todo.isEmpty) return false;
    current = todo.removeFirst();
    for (final next in successorsOf(current)) {
      if (seen.add(next)) {
        todo.addLast(next);
      }
    }
    return true;
  }
}
