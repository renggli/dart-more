import '../builder.dart';
import '../graph.dart';

extension CollectionGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPath(Iterable<V> chain, {E? data}) =>
      fromPaths([chain], data: data);

  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPaths(Iterable<Iterable<V>> chains, {E? data}) {
    final graph = empty();
    for (var chain in chains) {
      final vertices = chain.toList(growable: false);
      if (vertices.length == 1) {
        addVertex(graph, vertices.first);
      } else {
        for (var i = 0; i < vertices.length - 1; i++) {
          addEdge(graph, vertices[i], vertices[i + 1], data: data);
        }
      }
    }
    return graph;
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// preceding vertices.
  Graph<V, E> fromPredecessors(Map<V, Iterable<V>?> mapping) {
    final graph = empty();
    for (var entry in mapping.entries) {
      final predecessors = entry.value;
      if (predecessors == null) {
        addVertex(graph, entry.key);
      } else {
        for (var predecessor in predecessors) {
          addEdge(graph, predecessor, entry.key);
        }
      }
    }
    return graph;
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// succeeding vertices.
  Graph<V, E> fromSuccessors(Map<V, Iterable<V>?> mapping) {
    final graph = empty();
    for (var entry in mapping.entries) {
      final successors = entry.value;
      if (successors == null) {
        addVertex(graph, entry.key);
      } else {
        for (var successor in successors) {
          addEdge(graph, entry.key, successor);
        }
      }
    }
    return graph;
  }
}
