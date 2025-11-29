import '../edge.dart';
import '../graph.dart';
import '../strategy.dart';
import 'directed/base.dart';
import 'undirected/base.dart';

/// Abstract base class for all graph implementations.
abstract class BaseGraph<V, E> extends Graph<V, E> {
  factory BaseGraph.create({
    bool isDirected = false,
    bool parallelEdges = false,
    bool uniqueEdges = false,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => isDirected
      ? DirectedGraph.create(
          parallelEdges: parallelEdges,
          uniqueEdges: uniqueEdges,
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        )
      : UndirectedGraph.create(
          parallelEdges: parallelEdges,
          uniqueEdges: uniqueEdges,
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        );

  BaseGraph({required this.vertexStrategy, required this.edgeStrategy});

  @override
  final StorageStrategy<V> vertexStrategy;

  @override
  final StorageStrategy<E> edgeStrategy;

  Edge<V, E> createEdge(V source, V target, {E? value});
}
