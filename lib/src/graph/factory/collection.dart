import 'package:collection/collection.dart';

import '../factory.dart';
import '../graph.dart';

extension CollectionGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPath(Iterable<V> chain, {E? value}) =>
      fromPaths([chain], value: value);

  /// Creates a [Graph] from a [Iterable] of chains.
  Graph<V, E> fromPaths(Iterable<Iterable<V>> chains, {E? value}) {
    final builder = newBuilder();
    for (final chain in chains) {
      final vertices = chain.toList(growable: false);
      if (vertices.length == 1) {
        builder.addVertex(vertices.first);
      } else {
        for (var i = 0; i < vertices.length - 1; i++) {
          builder.addEdge(vertices[i], vertices[i + 1], value: value);
        }
      }
    }
    return builder.build();
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// preceding vertices (incoming adjacency).
  Graph<V, E> fromPredecessors(Map<V, Iterable<V>?> mapping) {
    final builder = newBuilder();
    for (final MapEntry(key: vertex, value: predecessors) in mapping.entries) {
      if (predecessors == null || predecessors.isEmpty) {
        builder.addVertex(vertex);
      } else {
        for (final predecessor in predecessors) {
          builder.addEdge(predecessor, vertex);
        }
      }
    }
    return builder.build();
  }

  /// Creates a [Graph] from start [vertices] and a function [predecessors]
  /// returning its preceding vertices (incoming adjacency).
  Graph<V, E> fromPredecessorFunction(
    Iterable<V> vertices,
    Iterable<V> Function(V vertex) predecessors,
  ) {
    final builder = newBuilder();
    final todo = QueueList<V>();
    final seen = vertexStrategy.createSet();
    for (final vertex in vertices) {
      builder.addVertex(vertex);
      todo.add(vertex);
      seen.add(vertex);
    }
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final predecessor in predecessors(vertex)) {
        builder.addEdge(predecessor, vertex);
        if (seen.add(predecessor)) {
          todo.add(predecessor);
        }
      }
    }
    return builder.build();
  }

  /// Creates a [Graph] from a [Map] of vertices pointing to an [Iterable] of
  /// succeeding vertices (outgoing adjacency).
  Graph<V, E> fromSuccessors(Map<V, Iterable<V>?> mapping) {
    final builder = newBuilder();
    for (final MapEntry(key: vertex, value: successors) in mapping.entries) {
      if (successors == null || successors.isEmpty) {
        builder.addVertex(vertex);
      } else {
        for (final successor in successors) {
          builder.addEdge(vertex, successor);
        }
      }
    }
    return builder.build();
  }

  /// Creates a [Graph] from start [vertices] and a function [successors]
  /// returning its succeeding vertices (outgoing adjacency).
  Graph<V, E> fromSuccessorFunction(
    Iterable<V> vertices,
    Iterable<V> Function(V vertex) successors,
  ) {
    final builder = newBuilder();
    final todo = QueueList<V>();
    final seen = vertexStrategy.createSet();
    for (final vertex in vertices) {
      builder.addVertex(vertex);
      todo.add(vertex);
      seen.add(vertex);
    }
    while (todo.isNotEmpty) {
      final vertex = todo.removeFirst();
      for (final successor in successors(vertex)) {
        builder.addEdge(vertex, successor);
        if (seen.add(successor)) {
          todo.add(successor);
        }
      }
    }
    return builder.build();
  }
}
