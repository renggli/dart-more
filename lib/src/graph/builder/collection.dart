import 'package:collection/collection.dart';

import '../builder.dart';
import '../graph.dart';

extension CollectionGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPath(Iterable<V> chain, {E? data}) =>
      fromPaths([chain], data: data);

  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPaths(Iterable<Iterable<V>> chains, {E? data}) {
    final factory = newFactory();
    for (final chain in chains) {
      final vertices = chain.toList(growable: false);
      if (vertices.length == 1) {
        factory.addVertex(vertices.first);
      } else {
        for (var i = 0; i < vertices.length - 1; i++) {
          factory.addEdge(vertices[i], vertices[i + 1], data: data);
        }
      }
    }
    return factory.build();
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// preceding vertices (incoming adjacency).
  Graph<V, E> fromPredecessors(Map<V, Iterable<V>?> mapping) {
    final factory = newFactory();
    for (final MapEntry(key: vertex, value: predecessors) in mapping.entries) {
      if (predecessors == null || predecessors.isEmpty) {
        factory.addVertex(vertex);
      } else {
        for (final predecessor in predecessors) {
          factory.addEdge(predecessor, vertex);
        }
      }
    }
    return factory.build();
  }

  /// Creates a [Graph] from start [vertices] and a function [predecessors]
  /// returning its preceding vertices (incoming adjacency).
  Graph<V, E> fromPredecessorFunction(
      Iterable<V> vertices, Iterable<V> Function(V vertex) predecessors) {
    final factory = newFactory();
    final todo = QueueList<V>();
    final seen = vertexStrategy.createSet();
    for (final vertex in vertices) {
      factory.addVertex(vertex);
      todo.add(vertex);
      seen.add(vertex);
    }
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final predecessor in predecessors(vertex)) {
        factory.addEdge(predecessor, vertex);
        if (seen.add(predecessor)) {
          todo.add(predecessor);
        }
      }
    }
    return factory.build();
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// succeeding vertices (outgoing adjacency).
  Graph<V, E> fromSuccessors(Map<V, Iterable<V>?> mapping) {
    final factory = newFactory();
    for (final MapEntry(key: vertex, value: successors) in mapping.entries) {
      if (successors == null || successors.isEmpty) {
        factory.addVertex(vertex);
      } else {
        for (final successor in successors) {
          factory.addEdge(vertex, successor);
        }
      }
    }
    return factory.build();
  }

  /// Creates a [Graph] from start [vertices] and a function [successors]
  /// returning its succeeding vertices (outgoing adjacency).
  Graph<V, E> fromSuccessorFunction(
      Iterable<V> vertices, Iterable<V> Function(V vertex) successors) {
    final factory = newFactory();
    final todo = QueueList<V>();
    final seen = vertexStrategy.createSet();
    for (final vertex in vertices) {
      factory.addVertex(vertex);
      todo.add(vertex);
      seen.add(vertex);
    }
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final successor in successors(vertex)) {
        factory.addEdge(vertex, successor);
        if (seen.add(successor)) {
          todo.add(successor);
        }
      }
    }
    return factory.build();
  }
}
