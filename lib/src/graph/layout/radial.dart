import 'dart:math' as math;

import '../layout.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for concentric radial layouts.
extension RadialLayoutExtension<V> on LayoutGraph<V> {
  /// Positions vertices on concentric circular rings expanding outwards from a center vertex,
  /// sizing ring circumferences to accommodate vertex widths and avoid overlaps.
  LayoutResult<V> radial({
    V? centerVertex,
    double? radiusStep,
    LayoutPoint center = const LayoutPoint(0, 0),
    double startAngle = 0.0,
    double spacing = 20.0,
  }) {
    final allVertices = vertices.toSet();
    if (allVertices.isEmpty) {
      return LayoutResult<V>(
        positions: const {},
        bounds: LayoutRect(
          minX: center.x,
          minY: center.y,
          maxX: center.x,
          maxY: center.y,
        ),
      );
    }

    final V root;
    if (centerVertex != null && allVertices.contains(centerVertex)) {
      root = centerVertex;
    } else {
      var best = allVertices.first;
      var maxDegree = -1;
      for (final v in allVertices) {
        final deg = successorsOf(v).length;
        if (deg > maxDegree) {
          maxDegree = deg;
          best = v;
        }
      }
      root = best;
    }

    final levels = <int, List<V>>{};
    final visited = <V>{root};
    levels[0] = [root];

    final queue = <(V, int)>[(root, 0)];
    while (queue.isNotEmpty) {
      final (curr, depth) = queue.removeAt(0);
      for (final next in successorsOf(curr)) {
        if (allVertices.contains(next) && visited.add(next)) {
          final nextDepth = depth + 1;
          levels.putIfAbsent(nextDepth, () => []).add(next);
          queue.add((next, nextDepth));
        }
      }
    }

    var nextAvailableDepth =
        (levels.keys.isEmpty ? 0 : levels.keys.reduce(math.max)) + 1;
    final unvisited = allVertices.difference(visited).toList();
    while (unvisited.isNotEmpty) {
      final componentRoot = unvisited.removeAt(0);
      visited.add(componentRoot);
      levels.putIfAbsent(nextAvailableDepth, () => []).add(componentRoot);
      final compQueue = <(V, int)>[(componentRoot, nextAvailableDepth)];

      while (compQueue.isNotEmpty) {
        final (curr, depth) = compQueue.removeAt(0);
        for (final next in successorsOf(curr)) {
          if (allVertices.contains(next) && visited.add(next)) {
            unvisited.remove(next);
            final nextDepth = depth + 1;
            levels.putIfAbsent(nextDepth, () => []).add(next);
            compQueue.add((next, nextDepth));
          }
        }
      }
      nextAvailableDepth = levels.keys.reduce(math.max) + 1;
    }

    final positions = <V, LayoutPoint>{};
    positions[root] = center;

    var currentRadius = 0.0;
    var prevMaxHeight = heightOf(root);

    for (final entry in levels.entries) {
      final depth = entry.key;
      if (depth == 0) continue;

      final ringVertices = entry.value;
      final count = ringVertices.length;

      var currMaxHeight = 0.0;
      var requiredPerimeter = 0.0;
      final diameters = <double>[];
      for (final v in ringVertices) {
        final d = diameterOf(v);
        diameters.add(d);
        requiredPerimeter += d + spacing;
        final h = heightOf(v);
        if (h > currMaxHeight) currMaxHeight = h;
      }

      final minCircumferenceRadius = requiredPerimeter / (2 * math.pi);
      final radialIncrement =
          radiusStep ?? ((prevMaxHeight + currMaxHeight) / 2.0 + spacing);
      currentRadius = math.max(
        currentRadius + radialIncrement,
        minCircumferenceRadius,
      );
      prevMaxHeight = currMaxHeight;

      var currentAngle = startAngle;
      for (var i = 0; i < count; i++) {
        final d = diameters[i];
        final arc = (d + spacing) / currentRadius;
        final angle = currentAngle + (arc / 2.0);
        final x = center.x + currentRadius * math.cos(angle);
        final y = center.y + currentRadius * math.sin(angle);
        positions[ringVertices[i]] = LayoutPoint(x, y);
        currentAngle += arc;
      }
    }

    return LayoutResult<V>(
      positions: positions,
      bounds: LayoutRect.fromPoints(positions.values),
    );
  }
}
