import 'dart:math' as math;

import '../layout.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for random layouts.
extension RandomLayoutExtension<V> on LayoutGraph<V> {
  /// Randomly positions vertices uniformly within [bounds].
  LayoutResult<V> random({
    LayoutRect bounds = const LayoutRect(
      minX: 0,
      minY: 0,
      maxX: 800,
      maxY: 600,
    ),
    math.Random? random,
    int? seed,
  }) {
    final list = vertices.toList();
    if (list.isEmpty) {
      return LayoutResult<V>(positions: const {}, bounds: bounds);
    }

    final rng = random ?? (seed != null ? math.Random(seed) : math.Random(42));
    final positions = <V, LayoutPoint>{};

    for (final v in list) {
      final w = widthOf(v);
      final h = heightOf(v);
      final availW = math.max(1.0, bounds.width - w);
      final availH = math.max(1.0, bounds.height - h);
      final x = bounds.minX + (w / 2.0) + rng.nextDouble() * availW;
      final y = bounds.minY + (h / 2.0) + rng.nextDouble() * availH;
      positions[v] = LayoutPoint(x, y);
    }

    return LayoutResult<V>(
      positions: positions,
      bounds: LayoutRect.fromPoints(positions.values),
    );
  }
}
