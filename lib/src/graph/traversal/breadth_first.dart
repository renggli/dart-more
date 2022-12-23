import 'dart:collection';

import '../path.dart';
import '../traversal.dart';

class BreadthFirstTraversal<V> extends Traversal<V> {
  BreadthFirstTraversal({
    super.nextEdges,
    super.nextVertices,
    super.vertexStrategy,
  });

  @override
  Iterable<Path<V>> startAll(Iterable<V> vertices) sync* {
    final seen = vertexStrategy.createSet()..addAll(vertices);
    final queue = Queue.of(vertices.map((vertex) => Path<V>(vertex)));
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      yield current;
      nextEdges(current.tail)
          .where((edge) => seen.add(edge.target))
          .map((edge) => Path<V>(edge.target,
              parent: current, weight: current.weight + edge.weight))
          .forEach(queue.addLast);
    }
  }
}
