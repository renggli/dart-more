import 'package:collection/collection.dart';

import '../../functional.dart';
import '../../graph.dart';

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

  num Function(V source, V target) _getDefaultEdgeValueOr(num value) =>
      this is Graph<V, num>
          ? (source, target) => getEdge(source, target)!.value as num
          : constantFunction2(value);
}
