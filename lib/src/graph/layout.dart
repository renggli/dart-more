import 'graph.dart';
import 'layout/geometry.dart';
import 'layout/graph_layout.dart';
import 'layout/postprocess.dart';
import 'model/internal.dart';

/// Extension on [Graph] providing access to graph layout strategies.
///
/// Computes 2D node coordinates and edge routes using configurable layout
/// strategies such as `StressLayout`, `ForceLayout`, `LayeredLayout`,
/// `TreeLayout`, `RadialLayout`, and more.
///
/// ```dart
/// final graph = Graph<String, void>.directed()
///   ..addEdge('A', 'B')
///   ..addEdge('B', 'C');
/// final result = graph.layout(const StressLayout());
/// print(result.positions['A']);
/// ```
extension GraphLayoutExtension<V, E> on Graph<V, E> {
  /// Computes a 2D layout for this graph using [strategy].
  LayoutResult<V> layout(
    GraphLayout<V> strategy, {
    LayoutSize Function(V vertex)? vertexSize,
    num Function(V source, V target)? edgeWeight,
    bool normalize = true,
    bool packComponents = true,
    bool removeOverlaps = false,
  }) {
    final input = LayoutInput<V>(
      vertices: vertices,
      successorsOf: successorsOf,
      predecessorsOf: isDirected ? predecessorsOf : null,
      vertexSize: vertexSize,
      edgeWeight: edgeWeight ?? getDefaultEdgeValueOr(1),
      vertexStrategy: vertexStrategy,
    );
    var result = strategy.layout(input);
    if (removeOverlaps) {
      result = result.removeOverlaps(input);
    }
    if (normalize) {
      result = result.normalized();
    }
    return result;
  }
}
