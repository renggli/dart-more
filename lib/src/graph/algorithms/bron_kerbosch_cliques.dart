import '../../../graph.dart';

/// Bron–Kerbosch maximal cliques.
///
/// See https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm.
class BronKerboschCliques<V, E> {
  BronKerboschCliques(this.graph) {
    GraphError.checkNotDirected(graph);
    _recursive(<V>{}, graph.vertices.toSet(), <V>{});
  }

  /// The underlying graph on which these strongly connected components are
  /// computed.
  final Graph<V, E> graph;

  /// Returns a set of strongly connected cliques.
  Set<Set<V>> get vertices => _results;

  /// Returns a set of the strongly connected sub-graphs.
  Set<Graph<V, E>> get graphs => _results
      .map((each) => graph.where(vertexPredicate: each.contains))
      .toSet();

  // Internal state.
  final _results = <Set<V>>{};

  void _recursive(Set<V> r, Set<V> p, Set<V> x) {
    if (p.isEmpty && x.isEmpty) {
      if (r.isNotEmpty) {
        _results.add(r);
      }
      return;
    }
    final pivot = p.isNotEmpty ? p.first : x.first;
    final pivotNeighbors = graph.neighboursOf(pivot).toSet();
    for (final vertex in p.difference(pivotNeighbors)) {
      final neighbors = graph.neighboursOf(vertex).toSet();
      _recursive(
        {...r, vertex},
        neighbors.intersection(p),
        neighbors.intersection(x),
      );
      p.remove(vertex);
      x.add(vertex);
    }
  }
}
