import 'dart:math' as math;

import '../layout.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for 2D grid layouts.
extension GridLayoutExtension<V> on LayoutGraph<V> {
  /// Positions vertices in a 2D rectangular grid.
  ///
  /// Prevents overlap by calculating cell dimensions from maximum vertex dimensions
  /// plus [spacing].
  LayoutResult<V> grid({
    int? columns,
    double? cellWidth,
    double? cellHeight,
    double spacing = 20.0,
    LayoutPoint origin = const LayoutPoint(0, 0),
  }) {
    final list = vertices.toList();
    if (list.isEmpty) {
      return LayoutResult<V>(
        positions: const {},
        bounds: LayoutRect(
          minX: origin.x,
          minY: origin.y,
          maxX: origin.x,
          maxY: origin.y,
        ),
      );
    }

    final n = list.length;
    final cols = math.max(1, columns ?? math.sqrt(n).ceil());

    var maxW = 0.0;
    var maxH = 0.0;
    for (final v in list) {
      final w = widthOf(v);
      final h = heightOf(v);
      if (w > maxW) maxW = w;
      if (h > maxH) maxH = h;
    }

    final effectiveCellWidth = cellWidth ?? (maxW + spacing);
    final effectiveCellHeight = cellHeight ?? (maxH + spacing);
    final positions = <V, LayoutPoint>{};

    for (var i = 0; i < n; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final x = origin.x + col * effectiveCellWidth;
      final y = origin.y + row * effectiveCellHeight;
      positions[list[i]] = LayoutPoint(x, y);
    }

    return LayoutResult<V>(
      positions: positions,
      bounds: LayoutRect.fromPoints(positions.values),
    );
  }
}
