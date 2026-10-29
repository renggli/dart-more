import 'dart:math';

import '../strategy.dart';

/// Finds articulation points (cut vertices) in an undirected graph.
///
/// An articulation point is a vertex whose removal increases the number
/// of connected components of the graph.
Set<V> articulationPoints<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();

  final result = vertexStrategy.createSet();
  final disc = vertexStrategy.createMap<int>();
  final low = vertexStrategy.createMap<int>();
  var time = 0;

  void dfs(V u, V? parent) {
    disc[u] = low[u] = ++time;
    var children = 0;

    for (final v in neighboursOf(u)) {
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

  for (final v in vertices) {
    if (!disc.containsKey(v)) {
      dfs(v, null);
    }
  }

  return result;
}

/// Finds bridges (cut edges) in an undirected graph.
///
/// A bridge is an edge whose removal increases the number of connected components.
/// Each bridge is returned as a pair `(u, v)`.
Set<(V, V)> bridges<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();

  final result = <(V, V)>{};
  final disc = vertexStrategy.createMap<int>();
  final low = vertexStrategy.createMap<int>();
  var time = 0;

  void dfs(V u, V? parent) {
    disc[u] = low[u] = ++time;
    var parentEdgeSkipped = false;

    for (final v in neighboursOf(u)) {
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
          result.add((u, v));
        }
      }
    }
  }

  for (final v in vertices) {
    if (!disc.containsKey(v)) {
      dfs(v, null);
    }
  }

  return result;
}

/// Represents a biconnected component consisting of its vertices and edges.
typedef BiconnectedComponent<V> = ({Set<V> vertices, Set<(V, V)> edges});

/// Computes the biconnected components of an undirected graph.
///
/// Each biconnected component is returned as a record containing its vertices and edges.
Iterable<BiconnectedComponent<V>> biconnectedComponents<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();

  final components = <BiconnectedComponent<V>>[];
  final disc = vertexStrategy.createMap<int>();
  final low = vertexStrategy.createMap<int>();
  final stack = <(V, V)>[];
  var time = 0;

  void addComponent((V, V) boundaryEdge) {
    final componentEdges = <(V, V)>{};
    final componentVertices = vertexStrategy!.createSet();
    while (stack.isNotEmpty) {
      final edge = stack.removeLast();
      componentEdges.add(edge);
      componentVertices.add(edge.$1);
      componentVertices.add(edge.$2);
      if ((edge.$1 == boundaryEdge.$1 && edge.$2 == boundaryEdge.$2) ||
          (edge.$1 == boundaryEdge.$2 && edge.$2 == boundaryEdge.$1)) {
        break;
      }
    }
    components.add((vertices: componentVertices, edges: componentEdges));
  }

  void dfs(V u, V? parent) {
    disc[u] = low[u] = ++time;
    var children = 0;
    var parentEdgeSkipped = false;

    for (final v in neighboursOf(u)) {
      if (v == parent && !parentEdgeSkipped) {
        parentEdgeSkipped = true;
        continue;
      }

      if (disc.containsKey(v)) {
        // Back edge or self-loop
        if (disc[v]! < disc[u]!) {
          stack.add((u, v));
          low[u] = min(low[u]!, disc[v]!);
        }
      } else {
        // Tree edge
        children++;
        stack.add((u, v));
        dfs(v, u);
        low[u] = min(low[u]!, low[v]!);

        if ((parent == null && children > 1) ||
            (parent != null && low[v]! >= disc[u]!)) {
          addComponent((u, v));
        }
      }
    }
  }

  for (final v in vertices) {
    if (!disc.containsKey(v)) {
      dfs(v, null);
      if (stack.isNotEmpty) {
        final componentEdges = <(V, V)>{};
        final componentVertices = vertexStrategy.createSet();
        while (stack.isNotEmpty) {
          final edge = stack.removeLast();
          componentEdges.add(edge);
          componentVertices.add(edge.$1);
          componentVertices.add(edge.$2);
        }
        components.add((vertices: componentVertices, edges: componentEdges));
      } else if (neighboursOf(v).isEmpty) {
        // Isolated vertex forms its own component
        final componentVertices = vertexStrategy.createSet()..add(v);
        components.add((vertices: componentVertices, edges: <(V, V)>{}));
      }
    }
  }

  return components;
}
