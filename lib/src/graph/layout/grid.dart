import 'dart:math' as math;

import 'geometry.dart';
import 'graph_layout.dart';

/// Positions vertices in a 2D rectangular grid.
///
/// Distributes vertices sequentially across rows and columns.
///
/// ```dart
/// final graph = Graph<int, void>.undirected()
///   ..addVertices([1, 2, 3, 4]);
/// final result = graph.layout(const GridLayout(columns: 2));
/// print(result.positions[1]);
/// ```
final class GridLayout<V> extends GraphLayout<V> {
  /// Constructs a grid layout strategy.
  const new({
    this.columns,
    this.cellWidth,
    this.cellHeight,
    this.vertexDistance = 20.0,
    this.origin = const LayoutPoint(0, 0),
    this.order,
  });

  /// The number of columns in the grid. If null, defaults to `ceil(sqrt(n))`.
  final int? columns;

  /// Fixed cell width. If null, computed from the maximum vertex width plus [vertexDistance].
  final double? cellWidth;

  /// Fixed cell height. If null, computed from the maximum vertex height plus [vertexDistance].
  final double? cellHeight;

  /// Spacing between adjacent grid cells when cell dimensions are auto-computed.
  final double vertexDistance;

  /// Origin coordinate for the top-left cell.
  final LayoutPoint origin;

  /// Optional custom ordering of vertices.
  final Iterable<V>? order;

  @override
  bool get packDisconnectedComponents => false;

  @override
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final list = order?.toList() ?? input.vertices;
    final n = list.length;
    final cols = math.max(1, columns ?? math.sqrt(n).ceil());

    var maxW = 0.0;
    var maxH = 0.0;
    final sizes = <V, LayoutSize>{};
    for (final v in list) {
      final size = input.sizeOf(v);
      sizes[v] = size;
      if (size.width > maxW) maxW = size.width;
      if (size.height > maxH) maxH = size.height;
    }

    final effCellWidth = cellWidth ?? (maxW + vertexDistance);
    final effCellHeight = cellHeight ?? (maxH + vertexDistance);
    final positions = <V, LayoutPoint>{};

    for (var i = 0; i < n; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final x = origin.x + col * effCellWidth;
      final y = origin.y + row * effCellHeight;
      positions[list[i]] = LayoutPoint(x, y);
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}
