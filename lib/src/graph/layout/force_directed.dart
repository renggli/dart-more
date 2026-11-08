import 'dart:math' as math;
import 'dart:typed_data';

import '../layout.dart';
import 'circular.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for force-directed layouts.
extension ForceDirectedLayoutExtension<V> on LayoutGraph<V> {
  /// Positions vertices using the Fruchterman-Reingold force-directed simulation,
  /// with collision repulsion between vertex bounding boxes to prevent overlap.
  LayoutResult<V> forceDirected({
    int iterations = 100,
    double? optimalDistance,
    LayoutRect bounds = const LayoutRect(
      minX: 0,
      minY: 0,
      maxX: 800,
      maxY: 600,
    ),
    Map<V, LayoutPoint>? initialPositions,
    math.Random? random,
    int? seed,
    double spacing = 20.0,
  }) {
    final list = vertices.toList();
    if (list.isEmpty) {
      return LayoutResult<V>(positions: const {}, bounds: bounds);
    }
    if (list.length == 1) {
      final v = list.first;
      final pos = initialPositions?[v] ?? bounds.center;
      return LayoutResult<V>(
        positions: {v: pos},
        bounds: LayoutRect(minX: pos.x, minY: pos.y, maxX: pos.x, maxY: pos.y),
      );
    }

    final n = list.length;
    final width = bounds.width > 0 ? bounds.width : 800.0;
    final height = bounds.height > 0 ? bounds.height : 600.0;
    final area = width * height;
    final k = optimalDistance ?? 0.75 * math.sqrt(area / n);
    final k2 = k * k;

    final rng = random ?? (seed != null ? math.Random(seed) : math.Random(42));
    final posMap = <V, (double, double)>{};

    final radius = Float64List(n);
    for (var i = 0; i < n; i++) {
      radius[i] = (diameterOf(list[i]) / 2.0) + (spacing / 2.0);
    }

    if (initialPositions != null) {
      for (final v in list) {
        final p = initialPositions[v];
        if (p != null) {
          posMap[v] = (p.x, p.y);
        }
      }
    }

    final missing = list.where((v) => !posMap.containsKey(v)).toList();
    if (missing.isNotEmpty) {
      final seedCircle = circular(
        center: bounds.center,
        radius: math.min(width, height) * 0.35,
      );
      for (final v in missing) {
        final p = seedCircle[v]!;
        final jx = (rng.nextDouble() - 0.5) * 5.0;
        final jy = (rng.nextDouble() - 0.5) * 5.0;
        posMap[v] = (p.x + jx, p.y + jy);
      }
    }

    final vertexIndex = <V, int>{for (var i = 0; i < n; i++) list[i]: i};
    final adj = List<List<int>>.generate(n, (_) => <int>[]);
    for (var i = 0; i < n; i++) {
      final v = list[i];
      final seen = <int>{};
      for (final neighbour in neighboursOf(v)) {
        final idx = vertexIndex[neighbour];
        if (idx != null && idx != i && seen.add(idx)) {
          adj[i].add(idx);
        }
      }
    }

    final posX = Float64List(n);
    final posY = Float64List(n);
    final dispX = Float64List(n);
    final dispY = Float64List(n);

    for (var i = 0; i < n; i++) {
      final p = posMap[list[i]]!;
      posX[i] = p.$1;
      posY[i] = p.$2;
    }

    var temp = math.min(width, height) / 10.0;
    final initialTemp = temp;

    for (var iter = 0; iter < iterations; iter++) {
      for (var i = 0; i < n; i++) {
        dispX[i] = 0.0;
        dispY[i] = 0.0;
      }

      // 1. Repulsive forces + collision overlap avoidance
      for (var i = 0; i < n; i++) {
        final pxI = posX[i];
        final pyI = posY[i];
        final rI = radius[i];
        for (var j = i + 1; j < n; j++) {
          var dx = pxI - posX[j];
          var dy = pyI - posY[j];
          var dist = math.sqrt(dx * dx + dy * dy);
          if (dist < 0.01) {
            dx = (rng.nextDouble() - 0.5) * 2.0;
            dy = (rng.nextDouble() - 0.5) * 2.0;
            dist = 0.01;
          }

          final minDist = rI + radius[j];
          var force = k2 / dist;
          if (dist < minDist) {
            final overlap = minDist - dist;
            force += (k2 / dist) * (1.0 + 3.0 * (overlap / minDist));
          }

          final fx = (dx / dist) * force;
          final fy = (dy / dist) * force;

          dispX[i] += fx;
          dispY[i] += fy;
          dispX[j] -= fx;
          dispY[j] -= fy;
        }
      }

      // 2. Attractive forces along adjacent edges
      for (var i = 0; i < n; i++) {
        final pxI = posX[i];
        final pyI = posY[i];
        for (final j in adj[i]) {
          if (i < j) {
            final dx = pxI - posX[j];
            final dy = pyI - posY[j];
            final dist = math.sqrt(dx * dx + dy * dy);
            if (dist > 0.01) {
              final force = (dist * dist) / k;
              final fx = (dx / dist) * force;
              final fy = (dy / dist) * force;

              dispX[i] -= fx;
              dispY[i] -= fy;
              dispX[j] += fx;
              dispY[j] += fy;
            }
          }
        }
      }

      // 3. Update positions clamped by current temperature
      const margin = 20.0;
      for (var i = 0; i < n; i++) {
        final dx = dispX[i];
        final dy = dispY[i];
        final disp = math.sqrt(dx * dx + dy * dy);
        if (disp > 0.001) {
          final step = math.min(disp, temp);
          posX[i] += (dx / disp) * step;
          posY[i] += (dy / disp) * step;
        }
        posX[i] = posX[i].clamp(bounds.minX + margin, bounds.maxX - margin);
        posY[i] = posY[i].clamp(bounds.minY + margin, bounds.maxY - margin);
      }

      temp = initialTemp * (1.0 - (iter + 1) / iterations);
    }

    // 4. Overlap resolution pass
    for (var pass = 0; pass < 5; pass++) {
      var hadOverlap = false;
      for (var i = 0; i < n; i++) {
        final rI = radius[i];
        for (var j = i + 1; j < n; j++) {
          final rJ = radius[j];
          final minDist = rI + rJ;
          var dx = posX[i] - posX[j];
          final dy = posY[i] - posY[j];
          var dist = math.sqrt(dx * dx + dy * dy);
          if (dist < minDist) {
            hadOverlap = true;
            if (dist < 0.01) {
              dx = 1.0;
              dist = 1.0;
            }
            final push = (minDist - dist) / 2.0;
            posX[i] += (dx / dist) * push;
            posY[i] += (dy / dist) * push;
            posX[j] -= (dx / dist) * push;
            posY[j] -= (dy / dist) * push;
          }
        }
      }
      if (!hadOverlap) break;
    }

    final finalPositions = <V, LayoutPoint>{};
    for (var i = 0; i < n; i++) {
      finalPositions[list[i]] = LayoutPoint(posX[i], posY[i]);
    }

    return LayoutResult<V>(
      positions: finalPositions,
      bounds: LayoutRect.fromPoints(finalPositions.values),
    );
  }
}
