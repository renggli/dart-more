import 'package:collection/collection.dart';

import '../../../collection.dart';
import '../../comparator/constructors/delegate.dart';
import '../strategy.dart';

/// The Bron–Kerbosch algorithm enumerates all *maximal cliques* in an
/// undirected graph. The code implements the variation with pivoting and
/// vertex ordering. The algorithm has exponential complexity, but for graphs
/// with small outgoing vertex degree is considerably faster.
///
/// `vertices` should be the nodes of the graph. `neighboursOf` is a function
/// that returns the neighbours of a vertex.
///
/// See https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm.
Iterable<Set<V>> bronKerboschCliques<V>(
  Iterable<V> vertices, {
  required Iterable<V> Function(V vertex) neighboursOf,
  required StorageStrategy<V> vertexStrategy,
}) sync* {
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
    // Pick a pivot with the highest degree.
    final pivot = CombinedIterableView([some, none]).max(
        comparator: delegateComparator<V, num>(
            (vertex) => neighboursOf(vertex).length));
    final vertices = vertexStrategy.createSet()
      ..addAll(some)
      ..removeAll(neighboursOf(pivot));
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
