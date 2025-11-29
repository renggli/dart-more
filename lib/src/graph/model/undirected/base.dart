import '../../edge.dart';
import '../../strategy.dart';
import '../base.dart';
import 'edge.dart';
import 'multi.dart';
import 'simple.dart';

/// Abstract base class for undirected graphs.
abstract class UndirectedGraph<V, E> extends BaseGraph<V, E> {
  UndirectedGraph({required super.vertexStrategy, required super.edgeStrategy});

  factory UndirectedGraph.create({
    required bool parallelEdges,
    required bool uniqueEdges,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => parallelEdges
      ? UndirectedMultiGraph.create(
          uniqueEdges: uniqueEdges,
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        )
      : UndirectedSimpleGraph.create(
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        );

  @override
  bool get isDirected => false;

  @override
  Edge<V, E> createEdge(V source, V target, {E? value}) =>
      UndirectedEdge<V, E>(source, target, value: value);
}
