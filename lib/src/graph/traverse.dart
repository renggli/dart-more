import '../../functional.dart';
import 'graph.dart';
import 'strategy.dart';

typedef VertexFunction<V> = Iterable<V> Function(V vertex);

extension TraverseGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph traversal strategy.
  GraphTraverse<V> get traverse =>
      GraphTraverse.fromGraph(this, vertexStrategy: vertexStrategy);
}

/// Generic strategy to traverse graphs.
class GraphTraverse<V> {
  /// Constructs a traversal strategy from a [Graph].
  GraphTraverse.fromGraph(
    Graph<V, void> graph, {
    StorageStrategy<V>? vertexStrategy,
  }) : this._(
          successorsOf: graph.successorsOf,
          predecessorsOf: graph.predecessorsOf,
          vertexStrategy: vertexStrategy ?? graph.vertexStrategy,
        );

  /// Constructs a traversal strategy from functions.
  GraphTraverse.fromFunction({
    VertexFunction<V>? successorsOf,
    VertexFunction<V>? predecessorsOf,
    StorageStrategy<V>? vertexStrategy,
  }) : this._(
          successorsOf: successorsOf ?? successorsOfRequired,
          predecessorsOf: predecessorsOf ?? predecessorsOfRequired,
          vertexStrategy: vertexStrategy ?? StorageStrategy.defaultStrategy(),
        );

  GraphTraverse._({
    required this.successorsOf,
    required this.predecessorsOf,
    required this.vertexStrategy,
  });

  final VertexFunction<V> successorsOf;

  final VertexFunction<V>? predecessorsOf;

  final StorageStrategy<V> vertexStrategy;
}

final successorsOfRequired =
    throwFunction1(ArgumentError.notNull('successorsOf'));
final predecessorsOfRequired =
    throwFunction1(ArgumentError.notNull('predecessorsOf'));

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
