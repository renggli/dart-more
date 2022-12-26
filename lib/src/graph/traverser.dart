import 'graph.dart';
import 'strategy.dart';

typedef SuccessorFunction<V> = Iterable<V> Function(V vertex);

extension TraverseGraphExtension<V, E> on Graph<V, E> {
  Traverser<V> get traverse =>
      Traverser.fromGraph(this, vertexStrategy: vertexStrategy);
}

class Traverser<V> {
  Traverser.fromGraph(Graph<V, void> graph,
      {StorageStrategy<V>? vertexStrategy})
      : this.fromFunction(graph.successorsOf, vertexStrategy: vertexStrategy);

  Traverser.fromFunction(this.successorFunction,
      {StorageStrategy<V>? vertexStrategy})
      : vertexStrategy = vertexStrategy ?? StorageStrategy.defaultStrategy();

  final SuccessorFunction<V> successorFunction;

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
