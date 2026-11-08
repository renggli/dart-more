import 'dart:convert';
import 'dart:math' as math;

import 'renderer.dart';
import 'state.dart';
import 'viz_interop.dart';

/// Computes vertex positions using Graphviz via Viz.js JSON output,
/// with an autonomous fallback circular layout.
abstract final class GraphLayout {
  /// Computes and applies layout coordinates to all vertices in [state].
  static void applyLayout(
    AppState state, {
    required VizInstance? viz,
    String? engine,
    String? rankdir,
  }) {
    final vertices = state.renderGraph.vertices.toList();
    if (vertices.isEmpty) return;

    final layoutEngine = engine ?? state.layoutEngine;
    final layoutRankdir = rankdir ?? state.rankDir;

    // Try Graphviz layout via Viz.js JSON format if it's a Graphviz engine
    if (viz != null &&
        const {
          'dot',
          'neato',
          'fdp',
          'sfdp',
          'circo',
          'twopi',
          'osage',
        }.contains(layoutEngine)) {
      try {
        final dotString = GraphRenderer.generateMinimalDot(
          state,
          engine: layoutEngine,
          rankdir: layoutRankdir,
        );
        final jsonString = viz.renderString(
          dotString,
          VizRenderOptions(engine: layoutEngine, format: 'json'),
        );

        final data = json.decode(jsonString) as Map<String, dynamic>;
        final bb =
            (data['bb'] as String?)?.split(',') ?? ['0', '0', '600', '400'];
        final llx = double.tryParse(bb.isNotEmpty ? bb[0] : '0') ?? 0.0;
        final lly = double.tryParse(bb.length > 1 ? bb[1] : '0') ?? 0.0;
        final urx = double.tryParse(bb.length > 2 ? bb[2] : '600') ?? 600.0;
        final ury = double.tryParse(bb.length > 3 ? bb[3] : '400') ?? 400.0;

        final graphWidth = (urx - llx).abs();
        final graphHeight = (ury - lly).abs();

        // Target rendering dimension (center with margin)
        final scaleX = graphWidth > 0
            ? (700.0 / math.max(graphWidth, 400.0)).clamp(0.6, 2.5)
            : 1.0;
        final scaleY = graphHeight > 0
            ? (500.0 / math.max(graphHeight, 300.0)).clamp(0.6, 2.5)
            : 1.0;
        final scale = math.min(scaleX, scaleY);

        final objects = data['objects'] as List<dynamic>? ?? [];
        final parsedCoords = <String, (double, double)>{};

        for (final item in objects) {
          if (item is Map<String, dynamic>) {
            final name = item['name'] as String?;
            final posStr = item['pos'] as String?;
            if (name != null && posStr != null) {
              final parts = posStr.split(',');
              if (parts.length >= 2) {
                final rawX = double.tryParse(parts[0]) ?? 0.0;
                final rawY = double.tryParse(parts[1]) ?? 0.0;
                // Invert Graphviz Y-axis (Graphviz Y increases upwards)
                final x = (rawX - llx) * scale + 80.0;
                final y = (ury - rawY) * scale + 80.0;
                parsedCoords[name] = (x, y);
              }
            }
          }
        }

        if (parsedCoords.isNotEmpty) {
          for (final v in vertices) {
            final coords = parsedCoords[v];
            final node = state.getOrCreateNode(v);
            if (coords != null) {
              node.x = coords.$1;
              node.y = coords.$2;
            } else {
              node.x ??= 100.0 + (vertices.indexOf(v) * 60.0) % 500.0;
              node.y ??= 100.0 + ((vertices.indexOf(v) * 60.0) ~/ 500.0) * 80.0;
            }
          }
          return;
        }
      } catch (_) {
        // Fall back to algorithmic circular layout on error
      }
    }

    if (layoutEngine == 'grid') {
      applyGridLayout(state, force: true);
    } else if (layoutEngine == 'random') {
      applyRandomLayout(state, force: true);
    } else if (layoutEngine == 'force') {
      applyForceLayout(state, force: true);
    } else {
      applyCircularLayout(state, force: true);
    }
  }

  /// Arranges all vertices evenly on a circle.
  static void applyCircularLayout(AppState state, {bool force = false}) {
    final vertices = state.renderGraph.vertices.toList();
    final n = vertices.length;
    if (n == 0) return;

    const centerX = 400.0;
    const centerY = 300.0;
    final radius = math.max(120.0, n * 24.0);

    for (var i = 0; i < n; i++) {
      final v = vertices[i];
      final node = state.getOrCreateNode(v);
      if (force || node.x == null || node.y == null) {
        final angle = (2 * math.pi * i / n) - (math.pi / 2);
        node.x = centerX + radius * math.cos(angle);
        node.y = centerY + radius * math.sin(angle);
      }
    }
  }

  /// Arranges vertices in a 2D grid.
  static void applyGridLayout(AppState state, {bool force = false}) {
    final vertices = state.renderGraph.vertices.toList();
    final n = vertices.length;
    if (n == 0) return;

    final cols = math.max(1, math.sqrt(n).ceil());
    const cellWidth = 110.0;
    const cellHeight = 90.0;
    const startX = 140.0;
    const startY = 120.0;

    for (var i = 0; i < n; i++) {
      final v = vertices[i];
      final node = state.getOrCreateNode(v);
      if (force || node.x == null || node.y == null) {
        final row = i ~/ cols;
        final col = i % cols;
        node.x = startX + col * cellWidth;
        node.y = startY + row * cellHeight;
      }
    }
  }

  /// Randomly spreads vertices across the canvas area.
  static void applyRandomLayout(AppState state, {bool force = false}) {
    final vertices = state.renderGraph.vertices.toList();
    final n = vertices.length;
    if (n == 0) return;

    final rand = math.Random(42);
    for (var i = 0; i < n; i++) {
      final v = vertices[i];
      final node = state.getOrCreateNode(v);
      if (force || node.x == null || node.y == null) {
        node.x = 100.0 + rand.nextDouble() * 650.0;
        node.y = 100.0 + rand.nextDouble() * 450.0;
      }
    }
  }

  /// Runs a simple spring-electrical force simulation to lay out vertices.
  static void applyForceLayout(
    AppState state, {
    bool force = false,
    int iterations = 40,
  }) {
    final graph = state.renderGraph;
    final vertices = graph.vertices.toList();
    final n = vertices.length;
    if (n == 0) return;

    // Initialize with circle if any coordinates missing
    applyCircularLayout(state, force: force);

    final positions = <String, (double, double)>{};
    for (final v in vertices) {
      final node = state.getOrCreateNode(v);
      positions[v] = (node.x ?? 400.0, node.y ?? 300.0);
    }

    const optimalDist = 120.0;
    const kRepel = 8000.0;
    const kAttract = 0.05;

    for (var iter = 0; iter < iterations; iter++) {
      final forces = <String, (double, double)>{};
      for (final v in vertices) {
        forces[v] = (0.0, 0.0);
      }

      // Repulsion between all pairs
      for (var i = 0; i < n; i++) {
        final u = vertices[i];
        final posU = positions[u]!;
        for (var j = i + 1; j < n; j++) {
          final v = vertices[j];
          final posV = positions[v]!;
          var dx = posU.$1 - posV.$1;
          final dy = posU.$2 - posV.$2;
          var dist = math.sqrt(dx * dx + dy * dy);
          if (dist < 1.0) {
            dx = 1.0;
            dist = 1.0;
          }
          final f = kRepel / (dist * dist);
          final fx = (dx / dist) * f;
          final fy = (dy / dist) * f;

          forces[u] = (forces[u]!.$1 + fx, forces[u]!.$2 + fy);
          forces[v] = (forces[v]!.$1 - fx, forces[v]!.$2 - fy);
        }
      }

      // Attraction along edges
      for (final edge in graph.edges) {
        final u = edge.source;
        final v = edge.target;
        if (u == v || !positions.containsKey(u) || !positions.containsKey(v)) {
          continue;
        }
        final posU = positions[u]!;
        final posV = positions[v]!;
        final dx = posV.$1 - posU.$1;
        final dy = posV.$2 - posU.$2;
        final dist = math.sqrt(dx * dx + dy * dy);
        final displacement = dist - optimalDist;
        final f = displacement * kAttract;
        final fx = dist > 0 ? (dx / dist) * f : 0.0;
        final fy = dist > 0 ? (dy / dist) * f : 0.0;

        forces[u] = (forces[u]!.$1 + fx, forces[u]!.$2 + fy);
        forces[v] = (forces[v]!.$1 - fx, forces[v]!.$2 - fy);
      }

      // Apply forces with damping
      final step = 0.8 * (1.0 - (iter / iterations));
      for (final v in vertices) {
        final pos = positions[v]!;
        final forceV = forces[v]!;
        final newX = (pos.$1 + forceV.$1 * step).clamp(80.0, 850.0);
        final newY = (pos.$2 + forceV.$2 * step).clamp(80.0, 600.0);
        positions[v] = (newX, newY);
      }
    }

    for (final v in vertices) {
      final node = state.getOrCreateNode(v);
      node.x = positions[v]!.$1;
      node.y = positions[v]!.$2;
    }
  }
}
