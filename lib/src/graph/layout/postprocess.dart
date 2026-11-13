import 'dart:math' as math;

import 'geometry.dart';
import 'graph_layout.dart';
import 'orientation.dart';

/// Scaling behavior for [LayoutResultExtension.fit].
enum FitMode {
  /// Uniformly scales the layout in both dimensions to fit within the target.
  contain,

  /// Scales horizontal and vertical dimensions independently.
  stretch,

  /// Uniformly shrinks the layout if larger than the target, but never enlarges it.
  shrinkOnly,

  /// Uniformly enlarges the layout if smaller than the target, but never shrinks it.
  growOnly,
}

/// Postprocessing extensions on [LayoutResult].
extension LayoutResultExtension<V> on LayoutResult<V> {
  /// Translates the layout so that its bounding box's top-left corner is at [origin].
  LayoutResult<V> normalized({LayoutPoint origin = const LayoutPoint(0, 0)}) {
    if (positions.isEmpty) return this;
    final b = bounds;
    final dx = origin.x - b.minX;
    final dy = origin.y - b.minY;
    if (dx == 0 && dy == 0) return this;
    return transform((_, pt) => pt.translate(dx, dy));
  }

  /// Scales and centers the layout to fit within [target] with [margin].
  LayoutResult<V> fit(
    LayoutRectangle target, {
    double margin = 0.0,
    FitMode mode = FitMode.contain,
  }) {
    if (positions.isEmpty) return this;

    final availableWidth = math.max(10.0, target.width - 2 * margin);
    final availableHeight = math.max(10.0, target.height - 2 * margin);

    final currentWidth = bounds.width;
    final currentHeight = bounds.height;

    final sx = currentWidth <= 0.001 ? 1.0 : availableWidth / currentWidth;
    final sy = currentHeight <= 0.001 ? 1.0 : availableHeight / currentHeight;

    final double scaleX;
    final double scaleY;

    switch (mode) {
      case FitMode.stretch:
        scaleX = sx;
        scaleY = sy;
      case FitMode.contain:
        final s = math.min(sx, sy);
        scaleX = s;
        scaleY = s;
      case FitMode.shrinkOnly:
        final s = math.min(1.0, math.min(sx, sy));
        scaleX = s;
        scaleY = s;
      case FitMode.growOnly:
        final s = math.max(1.0, math.min(sx, sy));
        scaleX = s;
        scaleY = s;
    }

    final scaledCenterX = bounds.center.x * scaleX;
    final scaledCenterY = bounds.center.y * scaleY;
    final targetCenterX = target.center.x;
    final targetCenterY = target.center.y;
    final offsetX = targetCenterX - scaledCenterX;
    final offsetY = targetCenterY - scaledCenterY;

    final newPositions = <V, LayoutPoint>{};
    for (final entry in positions.entries) {
      newPositions[entry.key] = LayoutPoint(
        entry.value.x * scaleX + offsetX,
        entry.value.y * scaleY + offsetY,
      );
    }

    final newRoutes = <(V, V), List<LayoutPoint>>{};
    for (final entry in edgeRoutes.entries) {
      newRoutes[entry.key] = [
        for (final pt in entry.value)
          LayoutPoint(pt.x * scaleX + offsetX, pt.y * scaleY + offsetY),
      ];
    }

    return LayoutResult<V>(
      positions: newPositions,
      edgeRoutes: newRoutes,
      vertexSizes: vertexSizes,
    );
  }

  /// Removes vertex-vertex and vertex-edge overlaps iteratively by pushing colliding elements apart.
  LayoutResult<V> removeOverlaps(
    LayoutInput<V> input, {
    double padding = 4.0,
    int maxPasses = 20,
  }) {
    if (positions.length <= 1) return this;

    final vertices = positions.keys.toList();
    final n = vertices.length;
    final currentPositions = Map<V, LayoutPoint>.of(positions);

    // Collect unique edges from input topology
    final edges = <(V, V)>[];
    final seen = <(V, V)>{};
    for (final u in input.vertices) {
      if (!currentPositions.containsKey(u)) continue;
      for (final v in input.successorsOf(u)) {
        if (u == v || !currentPositions.containsKey(v)) continue;
        if (!input.isDirected) {
          final pair = u.hashCode <= v.hashCode ? (u, v) : (v, u);
          if (seen.add(pair)) {
            edges.add((u, v));
          }
        } else {
          edges.add((u, v));
        }
      }
    }

    for (var pass = 0; pass < maxPasses; pass++) {
      var hadOverlap = false;

      // 1. Resolve vertex-vertex overlaps (Sweep-line on X)
      vertices.sort(
        (a, b) => currentPositions[a]!.x.compareTo(currentPositions[b]!.x),
      );

      for (var i = 0; i < n; i++) {
        final u = vertices[i];
        final sizeU = input.sizeOf(u);
        final (wu, hu) = (sizeU.width, sizeU.height);

        for (var j = i + 1; j < n; j++) {
          final v = vertices[j];
          final posU = currentPositions[u]!;
          final posV = currentPositions[v]!;
          final sizeV = input.sizeOf(v);
          final (wv, hv) = (sizeV.width, sizeV.height);

          final minDistX = (wu + wv) / 2.0 + padding;
          final dx = posV.x - posU.x;

          // Beyond horizontal reach, stop checking this inner loop
          if (dx >= minDistX) break;

          final minDistY = (hu + hv) / 2.0 + padding;
          final dy = posV.y - posU.y;

          if (dy.abs() < minDistY) {
            hadOverlap = true;
            final overlapX = minDistX - dx.abs();
            final overlapY = minDistY - dy.abs();

            if (overlapX < overlapY) {
              final shift = overlapX / 2.0;
              final sign = dx >= 0 ? 1.0 : -1.0;
              currentPositions[u] = posU.translate(-sign * shift, 0);
              currentPositions[v] = posV.translate(sign * shift, 0);
            } else {
              final shift = overlapY / 2.0;
              final sign = dy >= 0 ? 1.0 : -1.0;
              currentPositions[u] = posU.translate(0, -sign * shift);
              currentPositions[v] = posV.translate(0, sign * shift);
            }
          }
        }
      }

      // 2. Resolve vertex-edge overlaps (push non-incident vertices off edge segments)
      for (final (u, v) in edges) {
        final posU = currentPositions[u]!;
        final posV = currentPositions[v]!;

        final route =
            edgeRoutes[(u, v)] ??
            (!input.isDirected ? edgeRoutes[(v, u)] : null);
        final points = route != null && route.isNotEmpty
            ? [posU, ...route, posV]
            : [posU, posV];

        for (var s = 0; s < points.length - 1; s++) {
          final a = points[s];
          final b = points[s + 1];
          final dx = b.x - a.x;
          final dy = b.y - a.y;
          final segLenSq = dx * dx + dy * dy;
          if (segLenSq < 1e-6) continue;
          final segLen = math.sqrt(segLenSq);

          for (final w in vertices) {
            if (w == u || w == v) continue;
            final posW = currentPositions[w]!;
            final sizeW = input.sizeOf(w);
            final hw = sizeW.width / 2.0;
            final hh = sizeW.height / 2.0;
            final maxRadius = math.max(hw, hh);
            final clearance = maxRadius + padding;

            if (posW.x < math.min(a.x, b.x) - clearance ||
                posW.x > math.max(a.x, b.x) + clearance ||
                posW.y < math.min(a.y, b.y) - clearance ||
                posW.y > math.max(a.y, b.y) + clearance) {
              continue;
            }

            final t = ((posW.x - a.x) * dx + (posW.y - a.y) * dy) / segLenSq;
            if (t <= 0.0 || t >= 1.0) continue;

            final projX = a.x + t * dx;
            final projY = a.y + t * dy;
            final dispX = posW.x - projX;
            final dispY = posW.y - projY;
            final distSq = dispX * dispX + dispY * dispY;

            final double nx;
            final double ny;
            final double dist;
            if (distSq > 1e-8) {
              dist = math.sqrt(distSq);
              nx = dispX / dist;
              ny = dispY / dist;
            } else {
              dist = 0.0;
              nx = -dy / segLen;
              ny = dx / segLen;
            }

            final reqClearance =
                math.sqrt((nx * hw) * (nx * hw) + (ny * hh) * (ny * hh)) +
                padding;

            if (dist < reqClearance) {
              hadOverlap = true;
              final overlap = reqClearance - dist;
              currentPositions[w] = posW.translate(nx * overlap, ny * overlap);
            }
          }
        }
      }

      if (!hadOverlap) break;
    }

    return LayoutResult<V>(
      positions: currentPositions,
      edgeRoutes: edgeRoutes,
      vertexSizes: vertexSizes,
    );
  }
}

/// Packs multiple disjoint component [LayoutResult]s into a unified layout.
LayoutResult<V> packComponents<V>(
  List<LayoutResult<V>> componentResults, {
  double vertexDistance = 20.0,
  LayoutOrientation direction = LayoutOrientation.topToBottom,
}) {
  if (componentResults.isEmpty) return LayoutResult.empty<V>();
  if (componentResults.length == 1) return componentResults.first;

  final allPositions = <V, LayoutPoint>{};
  final allRoutes = <(V, V), List<LayoutPoint>>{};
  final allSizes = <V, LayoutSize>{};

  var currentOffset = 0.0;

  for (final comp in componentResults) {
    final compBounds = comp.bounds;
    final double offsetX;
    final double offsetY;

    switch (direction) {
      case LayoutOrientation.topToBottom:
        offsetX = -compBounds.minX;
        offsetY = currentOffset - compBounds.minY;
        currentOffset += compBounds.height + vertexDistance;
      case LayoutOrientation.bottomToTop:
        offsetX = -compBounds.minX;
        offsetY = -currentOffset - compBounds.maxY;
        currentOffset += compBounds.height + vertexDistance;
      case LayoutOrientation.leftToRight:
        offsetX = currentOffset - compBounds.minX;
        offsetY = -compBounds.minY;
        currentOffset += compBounds.width + vertexDistance;
      case LayoutOrientation.rightToLeft:
        offsetX = -currentOffset - compBounds.maxX;
        offsetY = -compBounds.minY;
        currentOffset += compBounds.width + vertexDistance;
    }

    for (final entry in comp.positions.entries) {
      allPositions[entry.key] = entry.value.translate(offsetX, offsetY);
    }
    for (final entry in comp.edgeRoutes.entries) {
      allRoutes[entry.key] = [
        for (final pt in entry.value) pt.translate(offsetX, offsetY),
      ];
    }
    if (comp.vertexSizes != null) {
      allSizes.addAll(comp.vertexSizes!);
    }
  }

  return LayoutResult<V>(
    positions: allPositions,
    edgeRoutes: allRoutes,
    vertexSizes: allSizes.isNotEmpty ? allSizes : null,
  );
}
