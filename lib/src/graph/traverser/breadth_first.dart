import 'dart:collection';

import '../traverser.dart';

extension BreadthFirstTraverserExtension<V> on Traverser<V> {
  Iterable<V> breadthFirst(V vertex) => breadthFirstAll([vertex]);

  Iterable<V> breadthFirstAll(Iterable<V> vertices) sync* {
    final queue = Queue<V>.of(vertices);
    final seen = vertexStrategy.createSet()..addAll(vertices);
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      yield current;
      for (final next in successorFunction(current)) {
        if (seen.add(next)) {
          queue.add(next);
        }
      }
    }
  }
}
