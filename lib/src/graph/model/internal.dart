import '../../functional/types/constant.dart';
import '../graph.dart';

/// Extension on [Graph] providing internal helpers.
extension InternalGraphExtension<V, E> on Graph<V, E> {
  /// Internal helper that returns a function using the numeric edge value
  /// of this graph, or otherwise a constant value for each edge.
  num Function(V source, V target) getDefaultEdgeValueOr(num value) =>
      this is Graph<V, num>
      ? (source, target) => getEdge(source, target)!.value as num
      : constantFunction2(value);
}
