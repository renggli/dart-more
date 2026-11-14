import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/collection.dart';
import 'package:web/web.dart' as web;

import 'state.dart';

/// Level palette for depth-based coloring.
const levelColors = [
  (
    border: '#f59e0b',
    fill: 'rgba(245, 158, 11, 0.08)',
    text: '#fbbf24',
  ), // Root / L0 (Amber)
  (
    border: '#8b5cf6',
    fill: 'rgba(139, 92, 246, 0.08)',
    text: '#a78bfa',
  ), // L1 (Purple)
  (
    border: '#3b82f6',
    fill: 'rgba(59, 130, 246, 0.08)',
    text: '#60a5fa',
  ), // L2 (Blue)
  (
    border: '#10b981',
    fill: 'rgba(16, 185, 129, 0.08)',
    text: '#34d399',
  ), // L3 (Emerald)
  (
    border: '#ec4899',
    fill: 'rgba(236, 72, 153, 0.08)',
    text: '#f472b6',
  ), // L4 (Pink)
  (
    border: '#14b8a6',
    fill: 'rgba(20, 184, 166, 0.08)',
    text: '#2dd4bf',
  ), // L5 (Teal)
];

/// Responsible for rendering the spatial canvas with smooth zooming and panning.
class RTreeRenderer {
  new({required this.canvas}) {
    context = canvas.context2D;
  }

  final web.HTMLCanvasElement canvas;
  late final web.CanvasRenderingContext2D context;

  double scale = 1.0;
  double panX = 0.0;
  double panY = 0.0;

  double toCanvasX(double screenX) => (screenX - panX) / scale;
  double toCanvasY(double screenY) => (screenY - panY) / scale;
  double toScreenX(double canvasX) => canvasX * scale + panX;
  double toScreenY(double canvasY) => canvasY * scale + panY;

  void zoomAt(double mouseX, double mouseY, double factor) {
    final newScale = (scale * factor).clamp(0.01, 50.0);
    panX = mouseX - (mouseX - panX) * (newScale / scale);
    panY = mouseY - (mouseY - panY) * (newScale / scale);
    scale = newScale;
  }

  void zoomIn() {
    final rect = canvas.getBoundingClientRect();
    zoomAt(rect.width / 2.0, rect.height / 2.0, 1.25);
  }

  void zoomOut() {
    final rect = canvas.getBoundingClientRect();
    zoomAt(rect.width / 2.0, rect.height / 2.0, 0.8);
  }

  void zoomFit(RTreeAppState state) {
    final rootBounds = state.tree.root.bounds;
    final rect = canvas.getBoundingClientRect();
    final vw = rect.width > 0 ? rect.width : 800.0;
    final vh = rect.height > 0 ? rect.height : 600.0;

    if (rootBounds != null && rootBounds.length >= 2) {
      final minX = rootBounds.minX;
      final minY = rootBounds.minY;
      final maxX = rootBounds.maxX;
      final maxY = rootBounds.maxY;
      final treeW = rootBounds.width;
      final treeH = rootBounds.height;

      const padding = 50.0;
      final availW = vw - padding * 2;
      final availH = vh - padding * 2;

      if (availW > 0 && availH > 0 && treeW > 0 && treeH > 0) {
        scale = math.min(availW / treeW, availH / treeH).clamp(0.01, 10.0);
      } else {
        scale = 1.0;
      }

      final centerX = (minX + maxX) / 2.0;
      final centerY = (minY + maxY) / 2.0;
      panX = vw / 2.0 - centerX * scale;
      panY = vh / 2.0 - centerY * scale;
    } else {
      scale = 1.0;
      panX = 0.0;
      panY = 0.0;
    }
  }

  void render(RTreeAppState state) {
    final dpr = web.window.devicePixelRatio;
    final rect = canvas.getBoundingClientRect();
    final width = (rect.width * dpr).truncate();
    final height = (rect.height * dpr).truncate();

    if (canvas.width != width || canvas.height != height) {
      canvas.width = width;
      canvas.height = height;
    }

    context.save();
    context.scale(dpr, dpr);
    context.clearRect(0, 0, rect.width, rect.height);

    // Apply zoom & pan camera transformation
    context.save();
    context.translate(panX, panY);
    context.scale(scale, scale);

    _renderBackgroundGrid(rect.width, rect.height);
    _renderSpatialTree(state, rect.width, rect.height);
    _renderOverlays(state);

    context.restore(); // restore zoom & pan
    context.restore(); // restore dpr
  }

  void _renderBackgroundGrid(double width, double height) {
    context.strokeStyle = 'rgba(255, 255, 255, 0.03)'.toJS;
    context.lineWidth = 1.0 / scale;
    const step = 40.0;

    final startX = ((-panX) / scale / step).floor() * step;
    final endX = ((width - panX) / scale / step).ceil() * step;
    final startY = ((-panY) / scale / step).floor() * step;
    final endY = ((height - panY) / scale / step).ceil() * step;

    context.beginPath();
    for (var x = startX; x <= endX; x += step) {
      context.moveTo(x, startY);
      context.lineTo(x, endY);
    }
    for (var y = startY; y <= endY; y += step) {
      context.moveTo(startX, y);
      context.lineTo(endX, y);
    }
    context.stroke();
  }

  void _renderSpatialTree(RTreeAppState state, double canvasW, double canvasH) {
    // 1. Calculate visible viewport bounds in spatial coordinates for tree culling
    final minVx = toCanvasX(0);
    final minVy = toCanvasY(0);
    final maxVx = toCanvasX(canvasW);
    final maxVy = toCanvasY(canvasH);
    final viewportBounds = Bounds.from2D(
      math.min(minVx, maxVx),
      math.min(minVy, maxVy),
      math.max(minVx, maxVx),
      math.max(minVy, maxVy),
    );

    // 2. Query the R-Tree to collect only nodes that intersect the visible viewport
    final nodesByLevel = <int, List<RTreeNode<SpatialItem>>>{};
    void collectVisible(RTreeNode<SpatialItem> node, int depth) {
      if (node.bounds != null && !node.bounds!.intersects(viewportBounds)) {
        return; // Entire subtree culled by R-Tree bounding box
      }
      nodesByLevel.putIfAbsent(depth, () => []).add(node);
      if (!node.isLeaf) {
        for (final entry in node.entries) {
          if (entry.bounds.intersects(viewportBounds)) {
            collectVisible(entry.child!, depth + 1);
          }
        }
      }
    }

    collectVisible(state.tree.root, 0);

    // 3. Render Internal Nodes (from root down to parents of leaves)
    final levels = nodesByLevel.keys.toList()..sort();
    for (final level in levels) {
      if (state.filterLevel != null && state.filterLevel != level) continue;
      final palette = levelColors[level % levelColors.length];
      final nodes = nodesByLevel[level]!;

      for (final node in nodes) {
        if (node.isLeaf) continue; // Leaf items drawn separately
        final b = node.bounds;
        if (b == null) continue;

        final isHovered = state.hoveredNode == node;
        final x = b.minX;
        final y = b.minY;
        final w = b.width;
        final h = b.height;

        context.fillStyle =
            (isHovered ? 'rgba(139, 92, 246, 0.25)' : palette.fill).toJS;
        context.fillRect(x, y, w, h);

        context.strokeStyle = (isHovered ? '#ffffff' : palette.border).toJS;
        context.lineWidth =
            (isHovered ? 2.5 : math.max(1.0, 2.0 - level * 0.3)) / scale;
        context.strokeRect(x, y, w, h);

        // Capacity badge with constant screen font size
        if (state.showBadges && w * scale > 30 && h * scale > 18) {
          final badgeText = '${node.entries.length}/${state.maxEntries}';
          context.save();
          context.translate(x, y);
          context.scale(1.0 / scale, 1.0 / scale);
          context.font = '10px monospace';
          context.fillStyle = palette.text.toJS;
          context.fillText(badgeText, 4, 12);
          context.restore();
        }
      }
    }

    // 4. Render Leaf Entries & Items
    final leafNodes = nodesByLevel.values
        .expand((list) => list)
        .where((n) => n.isLeaf);
    for (final leaf in leafNodes) {
      final isHoveredLeaf = state.hoveredNode == leaf;
      for (final entry in leaf.entries) {
        if (!entry.bounds.intersects(viewportBounds)) continue;
        final b = entry.bounds;
        final isHit = state.lastQueryHits.contains(entry);
        final item = entry.data;

        final x = b.minX;
        final y = b.minY;
        final w = b.width;
        final h = b.height;

        if (b.isPoint) {
          // Point rendered with constant screen radius
          final radius = (isHit ? 4.5 : 3.0) / scale;

          context.beginPath();
          context.arc(x, y, radius, 0, 2 * math.pi);
          context.fillStyle =
              (isHit ? '#ef4444' : (isHoveredLeaf ? '#60a5fa' : '#f8fafc'))
                  .toJS;
          context.fill();

          if (isHit) {
            context.strokeStyle = '#fca5a5'.toJS;
            context.lineWidth = 2.0 / scale;
            context.stroke();
          }

          // Point label rendered with constant screen font size (10px)
          if (state.showLabels && item != null) {
            context.save();
            context.translate(x, y);
            context.scale(1.0 / scale, 1.0 / scale);
            context.font = '10px sans-serif';
            context.fillStyle = 'rgba(255, 255, 255, 0.85)'.toJS;
            context.textAlign = 'center';
            context.fillText(item.label, 0, -6);
            context.restore();
          }
        } else {
          // Render box
          context.fillStyle =
              (isHit
                      ? 'rgba(239, 68, 68, 0.3)'
                      : (isHoveredLeaf
                            ? 'rgba(96, 165, 250, 0.2)'
                            : 'rgba(248, 250, 252, 0.08)'))
                  .toJS;
          context.fillRect(x, y, w, h);

          context.strokeStyle =
              (isHit ? '#ef4444' : (isHoveredLeaf ? '#60a5fa' : '#cbd5e1'))
                  .toJS;
          context.lineWidth = (isHit ? 2.0 : 1.2) / scale;
          context.strokeRect(x, y, w, h);

          // Box label rendered with constant screen font size (10px)
          if (state.showLabels &&
              item != null &&
              w * scale > 24 &&
              h * scale > 16) {
            context.save();
            context.translate(x, y);
            context.scale(1.0 / scale, 1.0 / scale);
            context.font = '10px sans-serif';
            context.fillStyle = '#ffffff'.toJS;
            context.textAlign = 'start';
            context.fillText(item.label, 4, 12);
            context.restore();
          }
        }
      }
    }
  }

  void _renderOverlays(RTreeAppState state) {
    // 1. Range Query Window / Lasso Overlay
    if (state.activeQueryBounds != null) {
      final q = state.activeQueryBounds!;
      final x = q.minX;
      final y = q.minY;
      final w = q.width;
      final h = q.height;

      context.fillStyle = 'rgba(239, 68, 68, 0.12)'.toJS;
      context.fillRect(x, y, w, h);

      context.strokeStyle = '#ef4444'.toJS;
      context.lineWidth = 1.8 / scale;
      // Dashed lines with constant screen dash length (5px dash, 4px gap)
      context.setLineDash([(5.0 / scale).toJS, (4.0 / scale).toJS].toJS);
      context.strokeRect(x, y, w, h);
      context.setLineDash(<JSNumber>[].toJS);
    }

    // 2. k-NN Radar Query Overlay
    if (state.activeKnnPoint != null) {
      final pt = state.activeKnnPoint!;
      final px = pt[0];
      final py = pt[1];

      // Draw search center bullet with constant screen radius (5px)
      context.beginPath();
      context.arc(px, py, 5.0 / scale, 0, 2 * math.pi);
      context.fillStyle = '#f59e0b'.toJS;
      context.fill();
      context.strokeStyle = '#ffffff'.toJS;
      context.lineWidth = 1.5 / scale;
      context.stroke();

      // Find max distance among hits to draw radar search circle
      var maxDist = 0.0;
      for (final hit in state.lastQueryHits) {
        final d = math.sqrt(hit.bounds.minDistanceToPointSquared(pt));
        if (d > maxDist) maxDist = d;

        // Draw connecting ray
        final targetCenter = hit.bounds.center;
        context.beginPath();
        context.moveTo(px, py);
        context.lineTo(targetCenter[0], targetCenter[1]);
        context.strokeStyle = 'rgba(245, 158, 11, 0.5)'.toJS;
        context.lineWidth = 1.0 / scale;
        context.stroke();
      }

      if (maxDist > 0) {
        context.beginPath();
        context.arc(px, py, maxDist, 0, 2 * math.pi);
        context.strokeStyle = 'rgba(245, 158, 11, 0.35)'.toJS;
        context.lineWidth = 1.5 / scale;
        // Dashed radar circle with constant screen dash length (4px dash, 3px gap)
        context.setLineDash([(4.0 / scale).toJS, (3.0 / scale).toJS].toJS);
        context.stroke();
        context.setLineDash(<JSNumber>[].toJS);
      }
    }
  }
}
