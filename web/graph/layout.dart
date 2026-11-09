import 'dart:math' as math;

import 'package:more/graph.dart';

import 'state.dart';

/// Computes vertex positions using native MoreDart layout algorithms.
abstract final class GraphLayout {
  /// Computes the layout size `(width, height)` for a vertex in [state].
  static LayoutSize computeNodeSize(AppState state, String vertex) {
    final label = state.nodes[vertex]?.label ?? vertex;
    return (width: math.max(48.0, label.length * 8.5 + 24.0), height: 48.0);
  }

  /// Computes and applies layout coordinates to all vertices in [state].
  static void applyLayout(
    AppState state, {
    String? engine,
    String? rankdir,
    bool force = true,
  }) {
    final graph = state.renderGraph;
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) return;

    final layoutEngine = engine ?? state.layoutEngine;
    final layoutRankdir = rankdir ?? state.rankDir;

    final orientation = switch (layoutRankdir) {
      'LR' => LayoutOrientation.leftToRight,
      'RL' => LayoutOrientation.rightToLeft,
      'BT' => LayoutOrientation.bottomToTop,
      _ => LayoutOrientation.topToBottom,
    };

    final initialPositions = <String, LayoutPoint>{
      for (final v in vertices)
        if (state.nodes[v]?.x != null && state.nodes[v]?.y != null)
          v: LayoutPoint(state.nodes[v]!.x!, state.nodes[v]!.y!),
    };

    final strategy = switch (layoutEngine) {
      'circular' => const CircularLayout<String>(vertexDistance: 32),
      'grid' => const GridLayout<String>(vertexDistance: 32),
      'tree' => TreeLayout<String>(
        orientation: orientation,
        vertexDistance: 40,
      ),
      'radial' => const RadialLayout<String>(vertexDistance: 32),
      'shell' => const ShellLayout<String>(vertexDistance: 32),
      'layered' => LayeredLayout<String>(
        orientation: orientation,
        vertexDistance: 40,
        layerDistance: 80,
      ),
      'bipartite' => PartiteLayout<String>(
        orientation: orientation,
        vertexDistance: 40,
        layerDistance: 80,
      ),
      'spectral' => const SpectralLayout<String>(),
      'random' => const RandomLayout<String>(
        bounds: LayoutRectangle(100, 100, 650, 450),
      ),
      'force' => ForceLayout<String>(
        config: const ForceConfig(iterations: 120),
        bounds: const LayoutRectangle(80, 80, 720, 520),
        vertexDistance: 40,
        initialPositions: initialPositions.isNotEmpty ? initialPositions : null,
      ),
      _ => const StressLayout<String>(vertexDistance: 70),
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
      if (pt != null && (force || node.x == null || node.y == null)) {
        node.x = pt.x;
        node.y = pt.y;
      }
    }
  }
}
