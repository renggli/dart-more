import 'dart:math' as math;

import 'geometry.dart';
import 'graph_layout.dart';

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

  /// Removes vertex overlaps iteratively by pushing colliding vertices apart.
  LayoutResult<V> removeOverlaps(
    LayoutInput<V> input, {
    double padding = 4.0,
    int maxPasses = 20,
  }) {
    if (positions.length <= 1) return this;

    final vertices = positions.keys.toList();
    final n = vertices.length;
    final currentPositions = Map<V, LayoutPoint>.of(positions);

    for (var pass = 0; pass < maxPasses; pass++) {
      var hadOverlap = false;

      // Sort by X coordinate for sweep-line overlap detection
      vertices.sort(
        (a, b) => currentPositions[a]!.x.compareTo(currentPositions[b]!.x),
      );

      for (var i = 0; i < n; i++) {
        final u = vertices[i];
        final posU = currentPositions[u]!;
        final sizeU = input.sizeOf(u);
        final (wu, hu) = (sizeU.width, sizeU.height);

        for (var j = i + 1; j < n; j++) {
          final v = vertices[j];
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
}) {
  if (componentResults.isEmpty) return LayoutResult.empty<V>();
  if (componentResults.length == 1) return componentResults.first;

  // Sort components by bounding height descending for shelf packing
  final sorted = componentResults.toList()
    ..sort((a, b) => b.bounds.height.compareTo(a.bounds.height));

  var totalArea = 0.0;
  var maxCompWidth = 0.0;
  for (final comp in sorted) {
    totalArea += comp.bounds.width * comp.bounds.height;
    if (comp.bounds.width > maxCompWidth) maxCompWidth = comp.bounds.width;
  }

  final maxShelfWidth = math.max(maxCompWidth, math.sqrt(totalArea) * 1.3);

  var currentX = 0.0;
  var currentY = 0.0;
  var shelfHeight = 0.0;

  final allPositions = <V, LayoutPoint>{};
  final allRoutes = <(V, V), List<LayoutPoint>>{};
  final allSizes = <V, LayoutSize>{};

  for (final comp in sorted) {
    final compBounds = comp.bounds;
    final w = compBounds.width;
    final h = compBounds.height;

    if (currentX + w > maxShelfWidth && currentX > 0) {
      currentY += shelfHeight + vertexDistance;
      currentX = 0.0;
      shelfHeight = 0.0;
    }

    final offsetX = currentX - compBounds.minX;
    final offsetY = currentY - compBounds.minY;

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

    currentX += w + vertexDistance;
    if (h > shelfHeight) shelfHeight = h;
  }

  return LayoutResult<V>(
    positions: allPositions,
    edgeRoutes: allRoutes,
    vertexSizes: allSizes.isNotEmpty ? allSizes : null,
  );
}
