import 'dart:math';

import '../edge.dart';
import '../errors.dart';
import '../graph.dart';
import '../strategy.dart';

/// Finds articulation points (cut vertices) in an undirected [graph].
///
/// An articulation point is a vertex whose removal increases the number
/// of connected components of the graph.
Set<V> articulationPoints<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final result = vertexStrategy.createSet();
  final disc = vertexStrategy.createMap<int>();
  final low = vertexStrategy.createMap<int>();
  var time = 0;

  void dfs(V u, V? parent) {
    disc[u] = low[u] = ++time;
    var children = 0;

    for (final edge in graph.outgoingEdgesOf(u)) {
      final v = edge.target;
      if (v == u) continue; // Ignore self-loops
      if (v == parent) continue;

      if (disc.containsKey(v)) {
        // Back edge
        low[u] = min(low[u]!, disc[v]!);
      } else {
        // Forward / Tree edge
        children++;
        dfs(v, u);
        low[u] = min(low[u]!, low[v]!);

        // Condition 1: Non-root vertex u is an articulation point if low[v] >= disc[u]
        if (parent != null && low[v]! >= disc[u]!) {
          result.add(u);
        }
      }
    }

    // Condition 2: Root vertex u is an articulation point if it has 2 or more children
    if (parent == null && children > 1) {
      result.add(u);
    }
  }

  for (final v in graph.vertices) {
    if (!disc.containsKey(v)) {
      dfs(v, null);
    }
  }

  return result;
}

/// Finds bridges (cut edges) in an undirected [graph].
///
/// A bridge is an edge whose removal increases the number of connected components.
Set<Edge<V, E>> bridges<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final result = <Edge<V, E>>{};
  final disc = vertexStrategy.createMap<int>();
  final low = vertexStrategy.createMap<int>();
  var time = 0;

  void dfs(V u, V? parent) {
    disc[u] = low[u] = ++time;
    var parentEdgeSkipped = false;

    for (final edge in graph.outgoingEdgesOf(u)) {
      final v = edge.target;
      if (v == u) continue; // Ignore self-loops

      if (v == parent && !parentEdgeSkipped) {
        parentEdgeSkipped = true;
        continue;
      }

      if (disc.containsKey(v)) {
        // Back edge
        low[u] = min(low[u]!, disc[v]!);
      } else {
        // Forward / Tree edge
        dfs(v, u);
        low[u] = min(low[u]!, low[v]!);

        // Edge (u, v) is a bridge if low[v] > disc[u]
        if (low[v]! > disc[u]!) {
          result.add(edge);
        }
      }
    }
  }

  for (final v in graph.vertices) {
    if (!disc.containsKey(v)) {
      dfs(v, null);
    }
  }

  return result;
}

/// Computes the biconnected components of an undirected [graph].
///
/// Each biconnected component is returned as an undirected subgraph
/// (maximal biconnected subgraph).
Iterable<Graph<V, E>> biconnectedComponents<V, E>(
  Graph<V, E> graph, {
  StorageStrategy<V>? vertexStrategy,
}) {
  GraphError.checkNotDirected(graph);
  vertexStrategy ??= graph.vertexStrategy;

  final components = <Graph<V, E>>[];
  final disc = vertexStrategy.createMap<int>();
  final low = vertexStrategy.createMap<int>();
  final edgeStack = <Edge<V, E>>[];
  var time = 0;

  void addComponent(Edge<V, E> boundaryEdge) {
    final sub = Graph<V, E>(isDirected: false, vertexStrategy: vertexStrategy);
    while (edgeStack.isNotEmpty) {
      final edge = edgeStack.removeLast();
      sub.addEdge(edge.source, edge.target, value: edge.value);
      if ((edge.source == boundaryEdge.source &&
              edge.target == boundaryEdge.target) ||
          (edge.source == boundaryEdge.target &&
              edge.target == boundaryEdge.source)) {
        break;
      }
    }
    components.add(sub);
  }

  void dfs(V u, V? parent) {
    disc[u] = low[u] = ++time;
    var children = 0;
    var parentEdgeSkipped = false;

    for (final edge in graph.outgoingEdgesOf(u)) {
      final v = edge.target;
      if (v == parent && !parentEdgeSkipped) {
        parentEdgeSkipped = true;
        continue;
      }

      if (disc.containsKey(v)) {
        // Back edge or self-loop
        if (disc[v]! < disc[u]!) {
          edgeStack.add(edge);
          low[u] = min(low[u]!, disc[v]!);
        }
      } else {
        // Tree edge
        children++;
        edgeStack.add(edge);
        dfs(v, u);
        low[u] = min(low[u]!, low[v]!);

        if ((parent == null && children > 1) ||
            (parent != null && low[v]! >= disc[u]!)) {
          addComponent(edge);
        }
      }
    }
  }

  for (final v in graph.vertices) {
    if (!disc.containsKey(v)) {
      dfs(v, null);
      if (edgeStack.isNotEmpty) {
        final sub = Graph<V, E>(
          isDirected: false,
          vertexStrategy: vertexStrategy,
        );
        while (edgeStack.isNotEmpty) {
          final edge = edgeStack.removeLast();
          sub.addEdge(edge.source, edge.target, value: edge.value);
        }
        components.add(sub);
      } else if (graph.degreeOf(v) == 0) {
        // Isolated vertex forms its own component
        final sub = Graph<V, E>(
          isDirected: false,
          vertexStrategy: vertexStrategy,
        )..addVertex(v);
        components.add(sub);
      }
    }
  }

  return components;
}
