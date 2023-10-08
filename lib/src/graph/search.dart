import 'package:collection/collection.dart';

import '../../functional.dart';
import 'graph.dart';
import 'path.dart';
import 'search/a_star.dart';
import 'search/dijkstra.dart';
import 'strategy.dart';

extension SearchGraphExtension<V, E> on Graph<V, E> {
  /// Performs a search for the shortest path between [source] and [target].
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the cost is assumed
  ///   to be constant with a weight of _1_.
  ///
  /// - [costEstimate] is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  Path<V>? shortestPath(
    V source,
    V target, {
    num Function(V source, V target)? edgeCost,
    num Function(V vertex)? costEstimate,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      shortestPathAll(
        source,
        (vertex) => target == vertex,
        edgeCost: edgeCost,
        costEstimate: costEstimate,
        vertexStrategy: vertexStrategy,
      ).firstOrNull;

  /// Performs a search for the shortest paths between [source] and the
  /// [targetPredicate] predicate.
  ///
  /// - [edgeCost] is a function that returns the cost to traverse an edge
  ///   between two vertices. If no function is provided, the cost is assumed
  ///   to be constant with a weight of _1_.
  ///
  /// - [costEstimate] is a function that returns the remaining cost from the
  ///   provided vertex. If an estimate is provided a faster _A*-Search_ is
  ///   performed, otherwise a _Dijkstra Search_.
  ///
  Iterable<Path<V>> shortestPathAll(
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
              edgeCost: edgeCost,
              vertexStrategy: vertexStrategy,
            )
          : AStarSearchIterable<V>(
              startVertices: [source],
              targetPredicate: targetPredicate,
              successorsOf: successorsOf,
              costEstimate: costEstimate,
              edgeCost: edgeCost,
              vertexStrategy: vertexStrategy,
            );
}
