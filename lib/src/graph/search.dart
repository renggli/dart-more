import 'package:collection/collection.dart';

import '../../functional.dart';
import 'edge.dart';
import 'graph.dart';
import 'path.dart';
import 'search/dijkstra.dart';
import 'strategy.dart';

extension SearchGraphExtension<V, E> on Graph<V, E> {
  /// Performs a search for the shortest path between [source] and [target].
  Path<V>? shortestPath(
    V source,
    V target, {
    num Function(Edge<V, E> edge)? edgeCost,
    num Function(V target)? estimateCost,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      shortestPathAll(
        source,
        (vertex) => target == vertex,
        edgeCost: edgeCost,
        estimateCost: estimateCost,
        vertexStrategy: vertexStrategy,
      ).firstOrNull;

  /// Performs a search for the shortest paths between [source] and [target],
  /// where the target is specified as a predicate over the vertices.
  Iterable<Path<V>> shortestPathAll(
    V source,
    Predicate1<V> target, {
    num Function(Edge<V, E> edge)? edgeCost,
    num Function(V target)? estimateCost,
    StorageStrategy<V>? vertexStrategy,
  }) =>
      DijkstraSearchIterable<V>(
        startVertices: [source],
        targetPredicate: target,
        successorsOf: successorsOf,
        edgeCost: edgeCost == null
            ? null
            : ((source, target) => edgeCost(getEdges(source, target).first)),
        vertexStrategy: vertexStrategy,
      );
}
