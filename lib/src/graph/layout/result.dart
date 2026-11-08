import 'dart:math' as math;

/// 2D coordinate in a graph layout.
final class LayoutPoint {
  /// Constructs a 2D layout point.
  const new(this.x, this.y);

  /// The horizontal coordinate.
  final double x;

  /// The vertical coordinate.
  final double y;

  /// Returns a new [LayoutPoint] shifted by [dx] and [dy].
  LayoutPoint translate(double dx, double dy) => LayoutPoint(x + dx, y + dy);

  /// Returns a new [LayoutPoint] scaled by [sx] and [sy].
  LayoutPoint scale(double sx, [double? sy]) =>
      LayoutPoint(x * sx, y * (sy ?? sx));

  /// Calculates the Euclidean distance to [other].
  double distanceTo(LayoutPoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'LayoutPoint($x, $y)';
}

/// Bounding rectangle enclosing layout elements.
final class LayoutRect {
  /// Constructs an axis-aligned bounding box.
  const new({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  /// Computes the bounding box enclosing all [points].
  factory fromPoints(Iterable<LayoutPoint> points) {
    final iterator = points.iterator;
    if (!iterator.moveNext()) {
      return const LayoutRect(minX: 0, minY: 0, maxX: 0, maxY: 0);
    }
    var minX = iterator.current.x;
    var maxX = iterator.current.x;
    var minY = iterator.current.y;
    var maxY = iterator.current.y;
    while (iterator.moveNext()) {
      final p = iterator.current;
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }
    return LayoutRect(minX: minX, minY: minY, maxX: maxX, maxY: maxY);
  }

  /// Minimum horizontal coordinate.
  final double minX;

  /// Minimum vertical coordinate.
  final double minY;

  /// Maximum horizontal coordinate.
  final double maxX;

  /// Maximum vertical coordinate.
  final double maxY;

  /// Width of the bounding box.
  double get width => maxX - minX;

  /// Height of the bounding box.
  double get height => maxY - minY;

  /// Center point of the bounding box.
  LayoutPoint get center => LayoutPoint((minX + maxX) / 2, (minY + maxY) / 2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutRect &&
          other.minX == minX &&
          other.minY == minY &&
          other.maxX == maxX &&
          other.maxY == maxY;

  @override
  int get hashCode => Object.hash(minX, minY, maxX, maxY);

  @override
  String toString() => 'LayoutRect($minX, $minY, $maxX, $maxY)';
}

/// Layout flow direction for hierarchical or tree layouts.
enum LayoutOrientation {
  /// Flow top to bottom (vertical descending).
  topToBottom,

  /// Flow bottom to top (vertical ascending).
  bottomToTop,

  /// Flow left to right (horizontal ascending).
  leftToRight,

  /// Flow right to left (horizontal descending).
  rightToLeft,
}

/// The result of calculating a 2D graph layout.
final class LayoutResult<V> {
  /// Constructs a layout result.
  const new({
    required this.positions,
    required this.bounds,
    this.edgeRoutes = const {},
  });

  /// Map associating each vertex with its computed 2D position.
  final Map<V, LayoutPoint> positions;

  /// The bounding rectangle enclosing all vertices and routes.
  final LayoutRect bounds;

  /// Optional control/routing points for edges.
  final Map<(V, V), List<LayoutPoint>> edgeRoutes;

  /// Accesses the position for [vertex].
  LayoutPoint? operator [](V vertex) => positions[vertex];

  /// Scales and translates the layout to fit inside [targetBounds] with [margin].
  LayoutResult<V> fit({
    LayoutRect targetBounds = const LayoutRect(
      minX: 0,
      minY: 0,
      maxX: 800,
      maxY: 600,
    ),
    double margin = 40.0,
    bool keepAspectRatio = true,
    bool scaleDown = true,
    bool scaleUp = true,
  }) {
    if (positions.isEmpty) return this;

    final availableWidth = math.max(10.0, targetBounds.width - 2 * margin);
    final availableHeight = math.max(10.0, targetBounds.height - 2 * margin);

    final currentWidth = bounds.width;
    final currentHeight = bounds.height;

    double scaleX;
    double scaleY;

    if (currentWidth <= 0.001) {
      scaleX = 1.0;
    } else {
      scaleX = availableWidth / currentWidth;
    }

    if (currentHeight <= 0.001) {
      scaleY = 1.0;
    } else {
      scaleY = availableHeight / currentHeight;
    }

    if (keepAspectRatio) {
      final uniformScale = math.min(scaleX, scaleY);
      scaleX = uniformScale;
      scaleY = uniformScale;
    }

    if (!scaleDown) {
      scaleX = math.max(1.0, scaleX);
      scaleY = math.max(1.0, scaleY);
    }
    if (!scaleUp) {
      scaleX = math.min(1.0, scaleX);
      scaleY = math.min(1.0, scaleY);
    }

    final scaledCenterX = bounds.center.x * scaleX;
    final scaledCenterY = bounds.center.y * scaleY;
    final targetCenterX = targetBounds.center.x;
    final targetCenterY = targetBounds.center.y;
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
      bounds: LayoutRect.fromPoints(newPositions.values),
      edgeRoutes: newRoutes,
    );
  }
}
