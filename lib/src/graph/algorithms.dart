import 'package:collection/collection.dart';

import '../../functional.dart';
import 'algorithms/a_star_search.dart';
import 'algorithms/dijkstra_search.dart';
import 'algorithms/dinic_max_flow.dart';
import 'algorithms/prims_min_spanning_tree.dart';
import 'algorithms/stoer_wagner_min_cut.dart';
import 'algorithms/tarjan_strongly_connected.dart';
import 'graph.dart';
import 'path.dart';
import 'strategy.dart';

extension AlgorithmsGraphExtension<V, E> on Graph<V, E> {
  /// Performs a search for the shortest path between [source] and [target].
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  /// - [costEstimate] is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  Path<V, num>? shortestPath(
    V source,
    V target, {
    num Function(V source, V target)? edgeCost,
    num Function(V vertex)? costEstimate,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      shortestPathAll(
        source,
        (vertex) => target == vertex,
        edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
        costEstimate: costEstimate,
        vertexStrategy: vertexStrategy ?? this.vertexStrategy,
      ).firstOrNull;

  /// Performs a search for the shortest paths between [source] and the
  /// [targetPredicate] predicate.
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the numeric edge
  ///   value or a constant weight of _1_ is used.
  ///
  /// - [costEstimate] is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  Iterable<Path<V, num>> shortestPathAll(
    V source,
    Predicate1<V> targetPredicate, {
    num Function(V source, V target)? edgeCost,
    num Function(V target)? costEstimate,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      costEstimate == null
          ? DijkstraSearchIterable<V>(
              startVertices: [source],
              targetPredicate: targetPredicate,
              successorsOf: successorsOf,
              edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
              vertexStrategy: vertexStrategy ?? this.vertexStrategy,
            )
          : AStarSearchIterable<V>(
              startVertices: [source],
              targetPredicate: targetPredicate,
              successorsOf: successorsOf,
              costEstimate: costEstimate,
              edgeCost: edgeCost ?? _getDefaultEdgeValueOr(1),
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

  /// Returns the minimum spanning graphs using Prim's algorithm. If the graph
  /// is disconnected, a single graph containing only the nodes reachable from
  /// the start vertex is returned.
  ///
  /// - [startVertex] is the root node of the new graph. If omitted, a random
  ///   node of the graph is picked.
  /// - [edgeWeight] is a function function that returns the positive weight
  ///   between two edges. If no function is provided, the numeric edge value
  ///   or a constant weight of _1_ is used.
  Graph<V, E> minSpanning({
    V? startVertex,
    num Function(V source, V target)? edgeWeight,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      primsMinSpanningTree<V, E>(
        this,
        startVertex: startVertex,
        edgeWeight: edgeWeight ?? _getDefaultEdgeValueOr(1),
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
