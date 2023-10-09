import '../graph.dart';
import '../model/utils.dart';

extension LogicalGraphExtension<V, E> on Graph<V, E> {
  /// Returns the union of this graph and [other]. This is a graph with the
  /// nodes and edges present in either of the two graphs. [edgeMerge] specifies
  /// how parallel edges are merged, if unspecified the last one is used.
  Graph<V, E> union(Graph<V, E> other,
      {E Function(V source, V target, E a, E b)? edgeMerge}) {
    final result = copyEmpty<V, E>(this);
    unionAll<V, E>(result, [this, other], edgeMerge: edgeMerge);
    return result;
  }

  /// Merges [others] into [result]. [edgeMerge] specifies how parallel edges
  /// are merged, if unspecified the last one is used.
  static void unionAll<V, E>(Graph<V, E> result, Iterable<Graph<V, E>> others,
      {E Function(V source, V target, E a, E b)? edgeMerge}) {
    for (final graph in others) {
      // Create all vertices present in any graph.
      for (final vertex in graph.vertices) {
        result.addVertex(vertex);
      }
      // Create all edges present in any graph.
      for (final vertex in graph.vertices) {
        for (final edge in graph.outgoingEdgesOf(vertex)) {
          final existing = result.getEdge(edge.source, edge.target);
          final value = existing == null || edgeMerge == null
              ? edge.value
              : edgeMerge(edge.source, edge.target, existing.value, edge.value);
          result.addEdge(edge.source, edge.target, value: value);
        }
      }
    }
  }

  /// Returns the intersection of this graph and [other]. This is a graph with
  /// the nodes and edges present in both graphs. [edgeMerge] specifies
  /// how parallel edges are merged, if unspecified the last one is used.
  Graph<V, E> intersection(Graph<V, E> other,
      {bool Function(V source, V target, E a, E b)? edgeCompare,
      E Function(V source, V target, E a, E b)? edgeMerge}) {
    final result = copyEmpty<V, E>(this);
    // Create all the vertices present in both graphs.
    for (final vertex in vertices) {
      if (other.vertices.contains(vertex)) {
        result.addVertex(vertex);
      }
    }
    // Create all edges that have vertices present in the result, and edges
    // in both graphs.
    for (final edge in edges) {
      final otherEdge = other.getEdge(edge.source, edge.target);
      if (otherEdge != null &&
          (edgeCompare == null ||
              edgeCompare(
                  edge.source, edge.target, edge.value, otherEdge.value))) {
        final value = edgeMerge == null
            ? otherEdge.value
            : edgeMerge(edge.source, edge.target, edge.value, otherEdge.value);
        result.addEdge(edge.source, edge.target, value: value);
      }
    }
    return result;
  }

  /// Returns the complement of this graph, that is a graph with the same
  /// vertices but with edges between vertices that had no edge.
  Graph<V, E> complement(
      {bool allowSelfLoops = false, E? Function(V source, V target)? edge}) {
    final result = copyEmpty<V, E>(this);
    // Copy all the vertices over.
    for (final vertex in vertices) {
      result.addVertex(vertex);
    }
    // Identify all the edges to be created.
    for (final source in vertices) {
      final targets = vertexStrategy.createSet()
        ..addAll(vertices)
        ..removeAll(successorsOf(source));
      if (!allowSelfLoops) {
        targets.remove(source);
      }
      for (final target in targets) {
        result.addEdge(source, target, value: edge?.call(source, target));
      }
    }
    return result;
  }
}
