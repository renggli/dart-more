import '../strategy.dart';

/// Bron–Kerbosch maximal cliques.
///
/// See https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm.
Iterable<Set<V>> bronKerboschCliques<V>(
  Iterable<V> vertices, {
  required Iterable<V> Function(V vertex) neighboursOf,
  required StorageStrategy<V> vertexStrategy,
}) sync* {
  final stack = <({Set<V> all, Set<V> some, Set<V> none})>[];
  stack.add(
      (all: {}, some: vertexStrategy.createSet()..addAll(vertices), none: {}));
  while (stack.isNotEmpty) {
    final (:all, :some, :none) = stack.removeLast();
    if (some.isEmpty && none.isEmpty) {
      if (all.isNotEmpty) yield vertexStrategy.createSet()..addAll(all);
      continue;
    }
    final pivot = some.isNotEmpty ? some.first : none.first;
    final vertices = {...some};
    vertices.removeAll(neighboursOf(pivot));
    for (final vertex in vertices) {
      final neighbours = neighboursOf(vertex);
      final newAll = vertexStrategy.createSet()
        ..addAll(all)
        ..add(vertex);
      final newSome = vertexStrategy.createSet()
        ..addAll(some)
        ..retainAll(neighbours);
      final newNone = vertexStrategy.createSet()
        ..addAll(none)
        ..retainAll(neighbours);
      stack.add((all: newAll, some: newSome, none: newNone));
      some.remove(vertex);
      none.add(vertex);
    }
  }
}
