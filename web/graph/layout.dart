import 'dart:math' as math;

import 'package:more/graph.dart';

import 'layout_options.dart';
import 'state.dart';

export 'layout_options.dart';

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
    String? engine,
    String? rankdir,
    double? vertexDistance,
    double? layerDistance,
    int? iterations,
    int? columns,
    int? seed,
  }) {
    final graph = state.renderGraph;
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) return;

    final layoutEngine = engine ?? state.layoutEngine;
    final layoutRankdir = rankdir ?? state.rankDir;
    final orientation = RankDir.fromId(layoutRankdir).toOrientation();

    final spacing = vertexDistance ?? 40.0;
    final lDist = layerDistance ?? 80.0;
    final iter = iterations ?? 100;

    final strategy = switch (layoutEngine) {
      'circular' => CircularLayout<String>(vertexDistance: spacing),
      'grid' => GridLayout<String>(
        columns: (columns != null && columns > 0) ? columns : null,
        vertexDistance: spacing,
      ),
      'tree' => TreeLayout<String>(
        orientation: orientation,
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      'radial' => RadialLayout<String>(vertexDistance: spacing),
      'shell' => ShellLayout<String>(vertexDistance: spacing),
      'layered' => LayeredLayout<String>(
        orientation: orientation,
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      'bipartite' => PartiteLayout<String>(
        orientation: orientation,
        vertexDistance: spacing,
        layerDistance: lDist,
      ),
      'spectral' => SpectralLayout<String>(
        vertexDistance: spacing,
        iterations: iter,
      ),
      'random' => RandomLayout<String>(
        bounds: const LayoutRectangle(100, 100, 650, 450),
        seed: seed,
      ),
      'force' => () {
        final initialPositions = <String, LayoutPoint>{
          for (final v in vertices)
            if (state.nodes[v]?.x != null && state.nodes[v]?.y != null)
              v: LayoutPoint(state.nodes[v]!.x!, state.nodes[v]!.y!),
        };
        return ForceLayout<String>(
          config: ForceConfig(iterations: iterations ?? 120),
          bounds: const LayoutRectangle(80, 80, 720, 520),
          vertexDistance: spacing,
          initialPositions: initialPositions.isNotEmpty
              ? initialPositions
              : null,
          seed: seed,
        );
      }(),
      _ => StressLayout<String>(
        vertexDistance: vertexDistance ?? 50.0,
        iterations: iter,
        seed: seed ?? 42,
      ),
    };

    final result = graph.layout(
      strategy,
      vertexSize: (v) => computeNodeSize(state, v),
      normalize: false,
    );

    // Center layout smoothly in the primary viewing area without squashing
    final fitted = result.fit(
      const LayoutRectangle(120, 100, 660, 460),
      margin: 40,
      mode: FitMode.shrinkOnly,
    );

    state.edgeRoutes = fitted.edgeRoutes;

    for (final v in vertices) {
      final pt = fitted[v];
      final node = state.getOrCreateNode(v);
      if (pt != null) {
        node.x = pt.x;
        node.y = pt.y;
      }
    }
  }
}
