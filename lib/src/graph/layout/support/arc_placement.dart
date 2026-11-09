import 'dart:math' as math;

import '../geometry.dart';

/// Places vertices along a circular arc, accommodating vertex dimensions and [vertexDistance].
(Map<V, LayoutPoint> positions, double radius) arcPlacement<V>({
  required List<V> vertices,
  required LayoutSize Function(V vertex) sizeOf,
  double radius = 0.0,
  LayoutPoint center = const LayoutPoint(0, 0),
  double startAngle = -math.pi / 2,
  double sweepAngle = 2 * math.pi,
  double vertexDistance = 20.0,
}) {
  final positions = <V, LayoutPoint>{};
  final n = vertices.length;
  if (n == 0) {
    return (positions, radius);
  }
  if (n == 1) {
    final x = center.x + radius * math.cos(startAngle);
    final y = center.y + radius * math.sin(startAngle);
    positions[vertices.first] = LayoutPoint(x, y);
    return (positions, radius);
  }

  var requiredPerimeter = 0.0;
  final diameters = <double>[];
  for (final v in vertices) {
    final size = sizeOf(v);
    final (w, h) = (size.width, size.height);
    final d = math.sqrt(w * w + h * h);
    diameters.add(d);
    requiredPerimeter += d + vertexDistance;
  }

  final minRadius = requiredPerimeter / math.max(0.001, sweepAngle.abs());
  final effectiveRadius = math.max(radius, minRadius);

  var currentAngle = startAngle;
  for (var i = 0; i < n; i++) {
    final d = diameters[i];
    final arc = (d + vertexDistance) / effectiveRadius;
    final angle = currentAngle + (arc / 2.0);
    final x = center.x + effectiveRadius * math.cos(angle);
    final y = center.y + effectiveRadius * math.sin(angle);
    positions[vertices[i]] = LayoutPoint(x, y);
    currentAngle += arc;
  }

  return (positions, effectiveRadius);
}
