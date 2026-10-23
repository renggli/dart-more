import '../strategy.dart';

/// The Bron–Kerbosch algorithm enumerates all *maximal cliques* in an
/// undirected graph. This implementation uses the variation with pivoting. The
/// algorithm has exponential complexity, but for graphs with small outgoing
/// vertex degree is fast.
///
/// [vertices] should be the nodes of the graph. [neighboursOf] is a function
/// that returns the neighbours of a vertex.
///
/// See https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm.
Iterable<Set<V>> bronKerboschCliques<V>(
  Iterable<V> vertices, {
  required Iterable<V> Function(V vertex) neighboursOf,
  required StorageStrategy<V> vertexStrategy,
}) sync* {
  Iterable<V> neighbours(V vertex) =>
      neighboursOf(vertex).where((each) => each != vertex);
  final stack = <({Set<V> all, Set<V> some, Set<V> none})>[];
  stack.add((
    all: vertexStrategy.createSet(), // R
    some: vertexStrategy.createSet()..addAll(vertices), // P
    none: vertexStrategy.createSet(), // X
  ));
  while (stack.isNotEmpty) {
    final (:all, :some, :none) = stack.removeLast();
    if (some.isEmpty && none.isEmpty) {
      if (all.isNotEmpty) {
        yield vertexStrategy.createSet()..addAll(all);
      }
      continue;
    }
    final pivot = some.isNotEmpty ? some.first : none.first;
    final vertices = vertexStrategy.createSet()
      ..addAll(some)
      ..removeAll(neighbours(pivot));
    for (final vertex in vertices) {
      final vertexNeighbours = neighbours(vertex);
      final newAll = vertexStrategy.createSet()
        ..addAll(all)
        ..add(vertex);
      final newSome = vertexStrategy.createSet()
        ..addAll(some)
        ..retainAll(vertexNeighbours);
      final newNone = vertexStrategy.createSet()
        ..addAll(none)
        ..retainAll(vertexNeighbours);
      stack.add((all: newAll, some: newSome, none: newNone));
      some.remove(vertex);
      none.add(vertex);
    }
  }
}
