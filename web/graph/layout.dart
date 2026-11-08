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
        return math.max(48.0, label.length * 8.5 + 24.0);
      },
      vertexHeight: (v) => 48.0,
    );

    final initialPositions = <String, LayoutPoint>{
      for (final v in vertices)
        if (state.nodes[v]?.x != null && state.nodes[v]?.y != null)
          v: LayoutPoint(state.nodes[v]!.x!, state.nodes[v]!.y!),
    };

    final result = switch (layoutEngine) {
      'circular' => layout.circular(spacing: 32),
      'grid' => layout.grid(spacing: 32),
      'tree' => layout.tree(orientation: orientation, siblingDistance: 40),
      'radial' => layout.radial(spacing: 32),
      'layered' => layout.layered(
        orientation: orientation,
        nodeDistance: 40,
        layerDistance: 80,
      ),
      'random' => layout.random(
        bounds: const LayoutRect(minX: 100, minY: 100, maxX: 750, maxY: 550),
      ),
      _ => layout.forceDirected(
        iterations: 120,
        bounds: const LayoutRect(minX: 80, minY: 80, maxX: 800, maxY: 600),
        spacing: 40,
        initialPositions: initialPositions.isNotEmpty ? initialPositions : null,
      ),
    };

    // Center layout smoothly in the primary viewing area without squashing
    final fitted = result.fit(
      targetBounds: const LayoutRect(
        minX: 120,
        minY: 100,
        maxX: 780,
        maxY: 560,
      ),
      margin: 40,
      scaleDown: false,
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
