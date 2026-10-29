import '../errors.dart';
import '../graph.dart';
import '../strategy.dart';

/// Extension on [Graph] providing transitive closure and transitive reduction.
extension TransitiveGraphExtension<V, E> on Graph<V, E> {
  /// Computes the transitive closure of this directed graph.
  ///
  /// The transitive closure is a directed graph with the same vertices,
  /// having an edge `(u, v)` whenever there is a directed path of length
  /// $\ge 1$ from `u` to `v`.
  ///
  /// Throws [GraphError] if the graph is undirected.
  Graph<V, void> transitiveClosure({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkDirected(this);
    vertexStrategy ??= this.vertexStrategy;

    final result = Graph<V, void>(
      isDirected: true,
      vertexStrategy: vertexStrategy,
    )..addVertices(vertices);

    for (final source in vertices) {
      final visited = vertexStrategy.createSet();
      final queue = <V>[];

      for (final target in successorsOf(source)) {
        if (visited.add(target)) {
          queue.add(target);
          result.addEdge(source, target);
        }
      }

      while (queue.isNotEmpty) {
        final current = queue.removeLast();
        for (final target in successorsOf(current)) {
          if (visited.add(target)) {
            queue.add(target);
            result.addEdge(source, target);
          }
        }
      }
    }

    return result;
  }

  /// Computes the transitive reduction of this directed acyclic graph (DAG).
  ///
  /// The transitive reduction is a graph with the minimum number of edges
  /// that maintains the same reachability as the original DAG.
  ///
  /// Throws [GraphError] if the graph is undirected or contains a cycle.
  Graph<V, E> transitiveReduction({StorageStrategy<V>? vertexStrategy}) {
    GraphError.checkDirected(this);
    vertexStrategy ??= this.vertexStrategy;

    // Check for cycles by computing in-degrees and topological order
    final inDegrees = vertexStrategy.createMap<int>();
    for (final v in vertices) {
      inDegrees[v] = inDegreeOf(v);
    }
    final queue = <V>[];
    for (final v in vertices) {
      if (inDegrees[v] == 0) {
        queue.add(v);
      }
    }

    final topoOrder = <V>[];
    while (queue.isNotEmpty) {
      final v = queue.removeLast();
      topoOrder.add(v);
      for (final w in successorsOf(v)) {
        final d = inDegrees[w]! - 1;
        inDegrees[w] = d;
        if (d == 0) {
          queue.add(w);
        }
      }
    }

    if (topoOrder.length != vertices.length) {
      throw GraphError(this, 'graph', 'Graph contains a cycle');
    }

    final result = Graph<V, E>(isDirected: true, vertexStrategy: vertexStrategy)
      ..addVertices(vertices);

    // For each edge (u, v), check if there is an alternative path from u to v of length >= 2
    for (final u in vertices) {
      for (final edge in outgoingEdgesOf(u)) {
        final v = edge.target;
        if (u == v) continue; // Skip self-loops

        // Check if v is reachable from u through any other immediate successor of u
        var reachableAlternative = false;
        final visited = vertexStrategy.createSet();
        final searchQueue = <V>[];

        for (final next in successorsOf(u)) {
          if (next != v && visited.add(next)) {
            searchQueue.add(next);
          }
        }

        while (searchQueue.isNotEmpty) {
          final curr = searchQueue.removeLast();
          if (curr == v) {
            reachableAlternative = true;
            break;
          }
          for (final next in successorsOf(curr)) {
            if (visited.add(next)) {
              searchQueue.add(next);
            }
          }
        }

        if (!reachableAlternative) {
          result.addEdge(u, v, value: edge.value);
        }
      }
    }

    return result;
  }
}
