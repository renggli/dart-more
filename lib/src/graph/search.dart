import '../../functional.dart';
import 'edge.dart';
import 'graph.dart';
import 'strategy.dart';

typedef OutgoingEdgesFunction<V, E> = Iterable<Edge<V, E>> Function(V vertex);
typedef EdgeCostFunction<V, E> = num Function(Edge<V, E> edge);

extension SearchGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph search strategy.
  GraphSearch<V, E> search({EdgeCostFunction<V, E>? edgeCost}) =>
      GraphSearch<V, E>.fromGraph(this,
          edgeCost: edgeCost, vertexStrategy: vertexStrategy);
}

/// Generic strategy to search graphs.
class GraphSearch<V, E> {
  /// Constructs a search strategy from a [Graph].
  GraphSearch.fromGraph(
    Graph<V, E> graph, {
    EdgeCostFunction<V, E>? edgeCost,
    StorageStrategy<V>? vertexStrategy,
  }) : this._(
          outgoingEdgesOf: graph.outgoingEdgesOf,
          edgeCost: edgeCost ?? constantFunction1(1),
          vertexStrategy: vertexStrategy ?? graph.vertexStrategy,
        );

  /// Constructs a traversal strategy from a successor function.
  GraphSearch._({
    required this.outgoingEdgesOf,
    required this.edgeCost,
    required this.vertexStrategy,
  });

  final OutgoingEdgesFunction<V, E> outgoingEdgesOf;

  final EdgeCostFunction<V, E> edgeCost;

  final StorageStrategy<V> vertexStrategy;
}

//
// // /// Finds the path with the lowest cost starting at [source] and ending in
// // /// an element that satisfies [predicate]. Returns `null` if there is no such
// // /// path.
// // Path<V>? find(V source, Predicate1<V> predicate) =>
// //     findAll(source, predicate).firstOrNull;
// //
// // /// Finds the path with the lowest cost starting at [source] and ending with
// // /// [target]. Returns `null` if there is no such path.
// // Path<V>? findTo(V source, V target) =>
// //     find(source, (element) => target == element);
// //
// // /// Finds all the paths with the lowest cost starting at [source] and ending
// // /// in an element that satisfies [predicate].
// // Iterable<Path<V>> findAll(V source, Predicate1<V> predicate) sync* {
// //   final start = Path<V>(source);
// //   final seen = <V, Path<V>>{start.tail: start};
// //   final queue = PriorityQueue<Path<V>>()..add(start);
// //   while (queue.isNotEmpty) {
// //     final current = queue.removeFirst();
// //     if (predicate(current.tail)) {
// //       yield current;
// //     }
// //     for (var edge in nextEdges(current.tail)) {
// //       final cost = current.cost + edge.weight;
// //       if (!seen.containsKey(edge.target) || cost < seen[edge.target]!.cost) {
// //         final node = Path<V>(edge.target, parent: current, cost: cost);
// //         seen[edge.target] = node;
// //         queue.add(node);
// //       }
// //     }
// //   }
// // }
// //
// // /// Finds all the paths with the lowest cost starting at [source] and ending
// // /// with [target].
// // Iterable<Path<V>> findAllTo(V source, Iterable<V> targets) =>
// //     findAll(source, targets.contains);
// }
