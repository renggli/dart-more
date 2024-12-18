import 'package:collection/collection.dart';

import '../comparator/constructors/natural.dart';
import '../functional/types/constant.dart';
import '../functional/types/predicate.dart';
import 'algorithms/dinic_max_flow.dart';
import 'algorithms/kruskal_spanning_tree.dart';
import 'algorithms/prim_spanning_tree.dart';
import 'algorithms/search/a_star.dart';
import 'algorithms/search/dijkstra.dart';
import 'algorithms/stoer_wagner_min_cut.dart';
import 'algorithms/tarjan_strongly_connected.dart';
import 'graph.dart';
import 'path.dart';
import 'strategy.dart';

extension AlgorithmsGraphExtension<V, E> on Graph<V, E> {
  /// Performs a search for the shortest path between `source` and `target`.
  ///
  /// - `edgeCost` is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  /// - `costEstimate` is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  Path<V, num>? shortestPath(
    V source,
    V target, {
    num Function(V source, V target)? edgeCost,
    num Function(V vertex)? costEstimate,
    bool includeAlternativePaths = false,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      shortestPathAll(
        source,
        targetPredicate: (vertex) => target == vertex,
        edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
        costEstimate: costEstimate,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      ).firstOrNull;

  /// Performs a search for the shortest paths starting at [source].
  ///
  /// - `targetPredicate` is a predicate function that decides if the target
  ///   vertex has been reached. If no predicate is provided, the shortest
  ///   paths to all reachable vertices are returned.
  ///
  /// - `edgeCost` is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  /// - `costEstimate` is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  /// - If `includeAlternativePaths` is set to `true`, multiple equal cost
  ///   paths to the same target are returned. The default is to not include
  ///   such alternatives.
  ///
  Iterable<Path<V, num>> shortestPathAll(
    V source, {
    Predicate1<V>? targetPredicate,
    num Function(V source, V target)? edgeCost,
    num Function(V target)? costEstimate,
    bool includeAlternativePaths = false,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      costEstimate == null
          ? dijkstraSearch<V>(
              startVertices: [source],
              targetPredicate: targetPredicate ?? constantFunction1(true),
              successorsOf: successorsOf,
              edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
              includeAlternativePaths: includeAlternativePaths,
              vertexStrategy: vertexStrategy ?? this.vertexStrategy,
            )
          : aStarSearch<V>(
              startVertices: [source],
              targetPredicate: targetPredicate ?? constantFunction1(true),
              successorsOf: successorsOf,
              costEstimate: costEstimate,
              edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
              includeAlternativePaths: includeAlternativePaths,
              vertexStrategy: vertexStrategy ?? this.vertexStrategy,
            );

  /// Returns an object that can compute the maximum flow between different
  /// vertices of this graph using the Dinic max flow algorithm.
  ///
  /// - [edgeCapacity] is a function function that returns the positive maximum
  ///   capacity between two vertices. If no function is provided, the numeric
  ///   edge value or a constant weight of _1_ is used.
  ///
  DinicMaxFlow<V> maxFlow({
    num Function(V source, V target)? edgeCapacity,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      DinicMaxFlow<V>(
        seedVertices: vertices,
        successorsOf: successorsOf,
        edgeCapacity: edgeCapacity ?? _getDefaultEdgeValueOr(1),
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Returns an object that computes the min-cut using the Stoer-Wagner
  /// algorithm.
  ///
  /// - [edgeWeight] is a function function that returns the positive weight
  ///   between two edges. If no function is provided, the numeric edge value
  ///   or a constant weight of _1_ is used.
  ///
  StoerWagnerMinCut<V, E> minCut({
    num Function(V source, V target)? edgeWeight,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      StoerWagnerMinCut<V, E>(
        graph: this,
        edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      );

  /// Returns the spanning tree of the graph.
  ///
  /// - [startVertex] is the root node of the new graph. If specified, Prim's
  ///   algorithm is returning the spanning tree starting at that vertex;
  ///   disconnected parts of the graph will be missing. Otherwise Kruskal's
  ///   algorithm is used, which always returns all vertices of the graph.
  ///
  /// - [edgeWeight] is a function that returns the weight between two edges. If
  ///   no function is provided, the numeric edge value or a constant weight of
  ///   _1_ is used.
  ///
  ///  - [weightComparator] is a function that compares two weights. If no
  ///    function is provided, the standard comparator is used yielding a
  ///    minimum spanning tree.
  ///
  Graph<V, E> spanningTree({
    V? startVertex,
    num Function(V source, V target)? edgeWeight,
    Comparator<num>? weightComparator,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      startVertex == null
          ? kruskalSpanningTree<V, E>(
              this,
              edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
              weightComparator: weightComparator ?? naturalComparable<num>,
              vertexStrategy: vertexStrategy ?? this.vertexStrategy,
            )
          : primSpanningTree<V, E>(
              this,
              startVertex: startVertex,
              edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
              weightComparator: weightComparator ?? naturalComparable<num>,
              vertexStrategy: vertexStrategy ?? this.vertexStrategy,
            );

  /// Returns the strongly connected components in this graph. The
  /// implementation uses the Tarjan's algorithm and runs in linear time.
  TarjanStronglyConnected<V, E> stronglyConnected({
    StorageStrategy<V>? vertexStrategy,
  }) =>
      TarjanStronglyConnected<V, E>(this,
          vertexStrategy: vertexStrategy ?? this.vertexStrategy);

  /// Internal helper that returns a function using the numeric edge value
  /// of this graph, or otherwise a constant value for each edge.
  num Function(V source, V target) _getDefaultEdgeValueOr(num value) =>
      this is Graph<V, num>
          ? (source, target) => getEdge(source, target)!.value as num
          : constantFunction2(value);
}
