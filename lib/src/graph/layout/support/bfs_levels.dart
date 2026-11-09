import 'dart:collection';

import '../graph_layout.dart';

/// Computes BFS level sets (distances from [roots]) for [input].
List<List<V>> bfsLevels<V>(
  LayoutInput<V> input,
  Iterable<V> roots, {
  Iterable<V> Function(V vertex)? successors,
}) {
  final nextOf = successors ?? input.successorsOf;
  final visited = input.vertexStrategy?.createSet() ?? <V>{};
  final levels = <List<V>>[];
  final queue = Queue<(V, int)>();

  for (final root in roots) {
    if (visited.add(root)) {
      queue.add((root, 0));
    }
  }

  while (queue.isNotEmpty) {
    final (vertex, level) = queue.removeFirst();
    while (levels.length <= level) {
      levels.add(<V>[]);
    }
    levels[level].add(vertex);

    for (final next in nextOf(vertex)) {
      if (visited.add(next)) {
        queue.add((next, level + 1));
      }
    }
  }
  return levels;
}
