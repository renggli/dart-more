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

  // Iterative depth-first search to avoid stack overflows on deep graphs.
  final callStack = <({V u, V? parent, Iterator<V> iter, int children})>[];
  for (final root in vertices) {
    if (disc.containsKey(root)) continue;
    disc[root] = low[root] = ++time;
    callStack.add((
      u: root,
      parent: null,
      iter: neighboursOf(root).iterator,
      children: 0,
    ));
    while (callStack.isNotEmpty) {
      final frame = callStack.last;
      final u = frame.u;
      if (frame.iter.moveNext()) {
        final v = frame.iter.current;
        if (v == u || v == frame.parent) continue;
        if (disc.containsKey(v)) {
          // Back edge
          low[u] = min(low[u]!, disc[v]!);
        } else {
          // Forward / Tree edge
          callStack[callStack.length - 1] = (
            u: u,
            parent: frame.parent,
            iter: frame.iter,
            children: frame.children + 1,
          );
          disc[v] = low[v] = ++time;
          callStack.add((
            u: v,
            parent: u,
            iter: neighboursOf(v).iterator,
            children: 0,
          ));
        }
      } else {
        callStack.removeLast();
        if (frame.parent case final p?) {
          low[p] = min(low[p]!, low[u]!);
          if (callStack.last.parent != null && low[u]! >= disc[p]!) {
            result.add(p);
          }
        } else if (frame.children > 1) {
          result.add(u);
        }
      }
    }
  }

  return result;
}

/// Finds bridges (cut edges) in an undirected graph.
///
/// A bridge is an edge whose removal increases the number of connected
/// components. Each bridge is returned as a pair `(u, v)`.
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

  // Iterative depth-first search to avoid stack overflows on deep graphs.
  final callStack =
      <({V u, V? parent, Iterator<V> iter, bool parentEdgeSkipped})>[];
  for (final root in vertices) {
    if (disc.containsKey(root)) continue;
    disc[root] = low[root] = ++time;
    callStack.add((
      u: root,
      parent: null,
      iter: neighboursOf(root).iterator,
      parentEdgeSkipped: false,
    ));
    while (callStack.isNotEmpty) {
      final frame = callStack.last;
      final u = frame.u;
      if (frame.iter.moveNext()) {
        final v = frame.iter.current;
        if (v == u) continue; // Ignore self-loops
        if (v == frame.parent && !frame.parentEdgeSkipped) {
          callStack[callStack.length - 1] = (
            u: u,
            parent: frame.parent,
            iter: frame.iter,
            parentEdgeSkipped: true,
          );
          continue;
        }
        if (disc.containsKey(v)) {
          // Back edge
          low[u] = min(low[u]!, disc[v]!);
        } else {
          // Forward / Tree edge
          disc[v] = low[v] = ++time;
          callStack.add((
            u: v,
            parent: u,
            iter: neighboursOf(v).iterator,
            parentEdgeSkipped: false,
          ));
        }
      } else {
        callStack.removeLast();
        if (frame.parent case final p?) {
          low[p] = min(low[p]!, low[u]!);
          if (low[u]! > disc[p]!) {
            result.add((p, u));
          }
        }
      }
    }
  }

  return result;
}

/// Represents a biconnected component consisting of its vertices and edges.
typedef BiconnectedComponent<V> = ({Set<V> vertices, Set<(V, V)> edges});

/// Computes the biconnected components of an undirected graph.
///
/// Each biconnected component is returned as a record containing its vertices
/// and edges.
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

  // Iterative depth-first search to avoid stack overflows on deep graphs.
  final callStack =
      <
        ({
          V u,
          V? parent,
          Iterator<V> iter,
          int children,
          bool parentEdgeSkipped,
        })
      >[];
  for (final v in vertices) {
    if (!disc.containsKey(v)) {
      disc[v] = low[v] = ++time;
      callStack.add((
        u: v,
        parent: null,
        iter: neighboursOf(v).iterator,
        children: 0,
        parentEdgeSkipped: false,
      ));
      while (callStack.isNotEmpty) {
        final frame = callStack.last;
        final u = frame.u;
        if (frame.iter.moveNext()) {
          final w = frame.iter.current;
          if (w == frame.parent && !frame.parentEdgeSkipped) {
            callStack[callStack.length - 1] = (
              u: u,
              parent: frame.parent,
              iter: frame.iter,
              children: frame.children,
              parentEdgeSkipped: true,
            );
            continue;
          }
          if (disc.containsKey(w)) {
            // Back edge or self-loop
            if (disc[w]! < disc[u]!) {
              stack.add((u, w));
              low[u] = min(low[u]!, disc[w]!);
            }
          } else {
            // Tree edge
            callStack[callStack.length - 1] = (
              u: u,
              parent: frame.parent,
              iter: frame.iter,
              children: frame.children + 1,
              parentEdgeSkipped: frame.parentEdgeSkipped,
            );
            stack.add((u, w));
            disc[w] = low[w] = ++time;
            callStack.add((
              u: w,
              parent: u,
              iter: neighboursOf(w).iterator,
              children: 0,
              parentEdgeSkipped: false,
            ));
          }
        } else {
          callStack.removeLast();
          if (frame.parent case final p?) {
            low[p] = min(low[p]!, low[u]!);
            final pFrame = callStack.last;
            if ((pFrame.parent == null && pFrame.children > 1) ||
                (pFrame.parent != null && low[u]! >= disc[p]!)) {
              addComponent((p, u));
            }
          }
        }
      }
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
