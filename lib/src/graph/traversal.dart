import 'path.dart';
import 'strategy.dart';
import 'traversal/breadth_first.dart';
import 'traversal/depth_first.dart';
import 'traversal/topological.dart';
import 'utils/next.dart';

/// Implements various traversal techniques over a graph-like structure with
/// vertexes of type [V].
abstract class Traversal<V> {
  Traversal({
    NextEdges<V>? nextEdges,
    NextVertices<V>? nextVertices,
    GraphStrategy<V>? vertexStrategy,
  })  : nextEdges =
            createNextEdges(nextEdges: nextEdges, nextVertices: nextVertices),
        vertexStrategy = vertexStrategy ?? GraphStrategy<V>.defaultStrategy();

  /// Creates a breadth-first traversal.
  factory Traversal.breadthFirst({
    NextEdges<V>? nextEdges,
    NextVertices<V>? nextVertices,
    GraphStrategy<V>? vertexStrategy,
  }) = BreadthFirstTraversal;

  /// Creates a depth-first traversal.
  factory Traversal.depthFirst({
    NextEdges<V>? nextEdges,
    NextVertices<V>? nextVertices,
    GraphStrategy<V>? vertexStrategy,
  }) = DepthFirstTraversal;

  /// Creates a topological traversal.
  factory Traversal.topological({
    NextEdges<V>? nextEdges,
    NextVertices<V>? nextVertices,
    GraphStrategy<V>? vertexStrategy,
  }) = TopologicalTraversal;

  /// Returns the outgoing edges of a `vertex`.
  final NextEdges<V> nextEdges;

  /// A strategy to handle vertex data.
  final GraphStrategy<V> vertexStrategy;

  /// Starts the traversal with the given [vertex].
  Iterable<Path<V>> start(V vertex) => startAll(<V>[vertex]);

  /// Starts the traversal with the given [vertices].
  Iterable<Path<V>> startAll(Iterable<V> vertices);

// /// Finds the path with the lowest cost starting at [source] and ending in
// /// an element that satisfies [predicate]. Returns `null` if there is no such
// /// path.
// Path<V>? find(V source, Predicate1<V> predicate) =>
//     findAll(source, predicate).firstOrNull;
//
// /// Finds the path with the lowest cost starting at [source] and ending with
// /// [target]. Returns `null` if there is no such path.
// Path<V>? findTo(V source, V target) =>
//     find(source, (element) => target == element);
//
// /// Finds all the paths with the lowest cost starting at [source] and ending
// /// in an element that satisfies [predicate].
// Iterable<Path<V>> findAll(V source, Predicate1<V> predicate) sync* {
//   final start = Path<V>(source);
//   final seen = <V, Path<V>>{start.tail: start};
//   final queue = PriorityQueue<Path<V>>()..add(start);
//   while (queue.isNotEmpty) {
//     final current = queue.removeFirst();
//     if (predicate(current.tail)) {
//       yield current;
//     }
//     for (var edge in nextEdges(current.tail)) {
//       final cost = current.cost + edge.weight;
//       if (!seen.containsKey(edge.target) || cost < seen[edge.target]!.cost) {
//         final node = Path<V>(edge.target, parent: current, cost: cost);
//         seen[edge.target] = node;
//         queue.add(node);
//       }
//     }
//   }
// }
//
// /// Finds all the paths with the lowest cost starting at [source] and ending
// /// with [target].
// Iterable<Path<V>> findAllTo(V source, Iterable<V> targets) =>
//     findAll(source, targets.contains);
}
