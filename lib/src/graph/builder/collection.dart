import 'package:collection/collection.dart';

import '../builder.dart';
import '../graph.dart';
import 'empty.dart';

extension CollectionGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPath(Iterable<V> chain, {E? data}) =>
      fromPaths([chain], data: data);

  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPaths(Iterable<Iterable<V>> chains, {E? data}) {
    final graph = empty();
    for (final chain in chains) {
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
  /// preceding vertices (incoming adjacency).
  Graph<V, E> fromPredecessors(Map<V, Iterable<V>?> mapping) {
    final graph = empty();
    for (final MapEntry(key: vertex, value: predecessors) in mapping.entries) {
      if (predecessors == null || predecessors.isEmpty) {
        addVertex(graph, vertex);
      } else {
        for (final predecessor in predecessors) {
          addEdge(graph, predecessor, vertex);
        }
      }
    }
    return graph;
  }

  /// Creates a [Graph] from start [vertices] and a function [predecessors]
  /// returning its preceding vertices (incoming adjacency).
  Graph<V, E> fromPredecessorFunction(
      Iterable<V> vertices, Iterable<V> Function(V vertex) predecessors) {
    final graph = empty();
    final todo = QueueList<V>();
    final seen = vertexStrategy.createSet();
    for (final vertex in vertices) {
      addVertex(graph, vertex);
      todo.add(vertex);
      seen.add(vertex);
    }
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final predecessor in predecessors(vertex)) {
        addEdge(graph, predecessor, vertex);
        if (seen.add(predecessor)) {
          todo.add(predecessor);
        }
      }
    }
    return graph;
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// succeeding vertices (outgoing adjacency).
  Graph<V, E> fromSuccessors(Map<V, Iterable<V>?> mapping) {
    final graph = empty();
    for (final MapEntry(key: vertex, value: successors) in mapping.entries) {
      if (successors == null || successors.isEmpty) {
        addVertex(graph, vertex);
      } else {
        for (final successor in successors) {
          addEdge(graph, vertex, successor);
        }
      }
    }
    return graph;
  }

  /// Creates a [Graph] from start [vertices] and a function [successors]
  /// returning its succeeding vertices (outgoing adjacency).
  Graph<V, E> fromSuccessorFunction(
      Iterable<V> vertices, Iterable<V> Function(V vertex) successors) {
    final graph = empty();
    final todo = QueueList<V>();
    final seen = vertexStrategy.createSet();
    for (final vertex in vertices) {
      addVertex(graph, vertex);
      todo.add(vertex);
      seen.add(vertex);
    }
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final successor in successors(vertex)) {
        addEdge(graph, vertex, successor);
        if (seen.add(successor)) {
          todo.add(successor);
        }
      }
    }
    return graph;
  }
}
