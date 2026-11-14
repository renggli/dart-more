import 'dart:math' as math;

import 'package:more/graph.dart';

import 'enums.dart';
import 'state.dart';

export 'enums.dart';

/// Computes vertex positions using native MoreDart layout algorithms.
abstract final class GraphLayout {
  /// Computes the layout size `(width, height)` for a vertex in [state].
  static LayoutSize computeNodeSize(AppState state, String vertex) {
    final label = state.nodes[vertex]?.label ?? vertex;
    return (
      width: math.max(
        minNodeWidth,
        label.length * charWidthEstimate + nodeHorizontalPadding,
      ),
      height: defaultNodeHeight,
    );
  }

  /// Computes and applies layout coordinates to all vertices in [state].
  static void applyLayout(
    AppState state, {
    Graph<String, num>? graph,
    LayoutEngine? engine,
    RankDir? rankdir,
    RankDir? componentDirection,
    double? vertexDistance,
    double? layerDistance,
    int? iterations,
    int? columns,
    int? seed,
    bool removeOverlaps = true,
  }) {
    final targetGraph = graph ?? state.renderGraph;
    final vertices = targetGraph.vertices.toList();
    if (vertices.isEmpty) return;

    final layoutEngine = engine ?? state.layoutEngine;
    final layoutRankdir = rankdir ?? state.rankDir;
    final layoutCompDir = componentDirection ?? state.componentDirection;
    final orientation = layoutRankdir.toOrientation();
    final compOrientation = layoutCompDir.toOrientation();

    final spacing = vertexDistance ?? 40.0;
    final lDist = layerDistance ?? 80.0;
    final iter = iterations ?? 100;

    final strategy = switch (layoutEngine) {
      LayoutEngine.circular => CircularLayout<String>(vertexDistance: spacing),
      LayoutEngine.grid => GridLayout<String>(
        columns: (columns != null && columns > 0) ? columns : null,
        vertexDistance: spacing,
      ),
      LayoutEngine.tree => TreeLayout<String>(
        orientation: orientation,
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      LayoutEngine.radial => RadialLayout<String>(
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      LayoutEngine.shell => ShellLayout<String>(
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      LayoutEngine.layered => LayeredLayout<String>(
        orientation: orientation,
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      LayoutEngine.spectral => SpectralLayout<String>(
        vertexDistance: spacing,
        iterations: iter,
        seed: seed ?? 42,
      ),
      LayoutEngine.random => RandomLayout<String>(
        bounds: const LayoutRectangle(100, 100, 650, 450),
        seed: seed,
      ),
      LayoutEngine.force => () {
        final span = math.max(
          720.0,
          math.sqrt(vertices.length) * (spacing + 60.0) * 2.0,
        );
        return ForceLayout<String>(
          config: ForceConfig(iterations: iterations ?? 120),
          bounds: LayoutRectangle(80, 80, span, span * 0.75),
          vertexDistance: spacing,
          seed: seed,
        );
      }(),
      LayoutEngine.stress => StressLayout<String>(
        vertexDistance: spacing,
        iterations: iter,
        seed: seed ?? 42,
      ),
    };

    var result = targetGraph.layout(
      strategy,
      vertexSize: (v) => computeNodeSize(state, v),
      componentDirection: compOrientation,
      removeOverlaps: removeOverlaps,
    );

    final center = result.bounds.center;
    final dx = 450.0 - center.x;
    final dy = 300.0 - center.y;
    result = result.transform((_, pt) => pt.translate(dx, dy));

    state.edgeRoutes = Map.of(result.edgeRoutes);

    for (final v in vertices) {
      final pt = result[v];
      final node = state.getOrCreateNode(v);
      if (pt != null) {
        node.x = pt.x;
        node.y = pt.y;
      }
    }
  }
}
