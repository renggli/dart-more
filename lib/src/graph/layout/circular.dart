import 'dart:math' as math;

import '../layout.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for circular layouts.
extension CircularLayoutExtension<V> on LayoutGraph<V> {
  /// Positions vertices evenly along a circle or elliptical arc.
  ///
  /// Prevents overlap by ensuring the circumference accommodates vertex diameters
  /// plus [spacing].
  LayoutResult<V> circular({
    LayoutPoint center = const LayoutPoint(0, 0),
    double? radius,
    double startAngle = -math.pi / 2,
    double sweepAngle = 2 * math.pi,
    double spacing = 20.0,
  }) {
    final list = vertices.toList();
    if (list.isEmpty) {
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

    final n = list.length;
    if (n == 1) {
      return LayoutResult<V>(
        positions: {list.first: center},
        bounds: LayoutRect(
          minX: center.x,
          minY: center.y,
          maxX: center.x,
          maxY: center.y,
        ),
      );
    }

    var requiredPerimeter = 0.0;
    final diameters = <double>[];
    for (final v in list) {
      final d = diameterOf(v);
      diameters.add(d);
      requiredPerimeter += d + spacing;
    }

    final minRadius = requiredPerimeter / math.max(0.001, sweepAngle.abs());
    final r = math.max(radius ?? 0.0, minRadius);
    final positions = <V, LayoutPoint>{};

    var currentAngle = startAngle;
    for (var i = 0; i < n; i++) {
      final d = diameters[i];
      final arc = (d + spacing) / r;
      final angle = currentAngle + (arc / 2.0);
      final x = center.x + r * math.cos(angle);
      final y = center.y + r * math.sin(angle);
      positions[list[i]] = LayoutPoint(x, y);
      currentAngle += arc;
    }

    return LayoutResult<V>(
      positions: positions,
      bounds: LayoutRect.fromPoints(positions.values),
    );
  }
}
