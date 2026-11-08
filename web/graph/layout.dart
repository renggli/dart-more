import 'dart:math' as math;

import 'package:more/graph.dart';

import 'state.dart';

/// Computes vertex positions using native MoreDart layout algorithms.
abstract final class GraphLayout {
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

    final layout = graph.layout(
      vertexWidth: (v) {
        final label = state.nodes[v]?.label ?? v;
        return math.max(40.0, label.length * 8.0 + 24.0);
      },
      vertexHeight: (v) => 40.0,
    );

    final result = switch (layoutEngine) {
      'circular' => layout.circular(spacing: 24),
      'grid' => layout.grid(spacing: 24),
      'tree' => layout.tree(orientation: orientation, siblingDistance: 24),
      'radial' => layout.radial(spacing: 24),
      'layered' => layout.layered(orientation: orientation, nodeDistance: 24),
      'random' => layout.random(
        bounds: const LayoutRect(minX: 100, minY: 100, maxX: 750, maxY: 550),
      ),
      _ => layout.forceDirected(
        iterations: 80,
        bounds: const LayoutRect(minX: 80, minY: 80, maxX: 800, maxY: 600),
        spacing: 24,
      ),
    };

    // Fit layout smoothly into the primary viewing area
    final fitted = result.fit(
      targetBounds: const LayoutRect(
        minX: 120,
        minY: 100,
        maxX: 780,
        maxY: 560,
      ),
      margin: 40,
    );

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
