import '../../edge.dart';
import '../../strategy.dart';
import '../base.dart';
import 'edge.dart';
import 'multi.dart';
import 'simple.dart';

/// Abstract base class for directed graphs.
abstract class DirectedGraph<V, E> extends BaseGraph<V, E> {
  DirectedGraph({required super.vertexStrategy, required super.edgeStrategy});

  factory DirectedGraph.create({
    required bool parallelEdges,
    required bool uniqueEdges,
    StorageStrategy<V>? vertexStrategy,
    StorageStrategy<E>? edgeStrategy,
  }) => parallelEdges
      ? DirectedMultiGraph.create(
          uniqueEdges: uniqueEdges,
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        )
      : DirectedSimpleGraph.create(
          vertexStrategy: vertexStrategy,
          edgeStrategy: edgeStrategy,
        );

  @override
  bool get isDirected => true;

  @override
  Edge<V, E> createEdge(V source, V target, {E? value}) =>
      DirectedEdge<V, E>(source, target, value: value);
}
