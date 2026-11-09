import 'dart:math' as math;

import './geometry.dart';
import 'shell.dart';

/// Positions vertices evenly along a circular ring.
///
/// Places all vertices equidistant along a single circumference.
///
/// ```dart
/// final graph = Graph<String, void>.undirected()
///   ..addEdge('A', 'B')
///   ..addEdge('B', 'C');
/// final result = graph.layout(const CircularLayout());
/// print(result.positions['A']);
/// ```
final class CircularLayout<V> extends ShellLayout<V> {
  /// Constructs a circular layout strategy.
  const new({
    super.radius = 0.0,
    super.vertexDistance = 20.0,
    super.center = const LayoutPoint(0, 0),
    super.startAngle = -math.pi / 2,
    super.sweepAngle = 2 * math.pi,
  }) : super.single();
}
