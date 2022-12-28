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