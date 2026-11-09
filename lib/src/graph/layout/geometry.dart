import 'dart:math' as math;

/// Represents a 2D point coordinate.
typedef LayoutPoint = math.Point<double>;

/// Represents a 2D bounding rectangle.
typedef LayoutRectangle = math.Rectangle<double>;

/// Represents a 2D size with `width` and `height`.
typedef LayoutSize = ({double width, double height});

/// Extensions on [LayoutPoint].
extension PointLayoutExtension on LayoutPoint {
  /// Returns a new [LayoutPoint] shifted by [dx] and [dy].
  LayoutPoint translate(double dx, double dy) => LayoutPoint(x + dx, y + dy);

  /// Returns a new [LayoutPoint] scaled by [sx] and [sy].
  LayoutPoint scale(double sx, [double? sy]) =>
      LayoutPoint(x * sx, y * (sy ?? sx));
}

/// Extensions on [LayoutRectangle].
extension RectangleLayoutExtension on LayoutRectangle {
  /// Minimum horizontal coordinate.
  double get minX => left;

  /// Minimum vertical coordinate.
  double get minY => top;

  /// Maximum horizontal coordinate.
  double get maxX => right;

  /// Maximum vertical coordinate.
  double get maxY => bottom;

  /// Center point of the rectangle.
  LayoutPoint get center => LayoutPoint(left + width / 2.0, top + height / 2.0);

  /// Returns a new rectangle enclosing both this and [other].
  LayoutRectangle expandToInclude(LayoutRectangle other) {
    final x1 = math.min(left, other.left);
    final y1 = math.min(top, other.top);
    final x2 = math.max(right, other.right);
    final y2 = math.max(bottom, other.bottom);
    return LayoutRectangle(x1, y1, x2 - x1, y2 - y1);
  }

  /// Returns a new rectangle enclosing this rectangle and [point].
  LayoutRectangle expandToIncludePoint(LayoutPoint point) {
    final x1 = math.min(left, point.x);
    final y1 = math.min(top, point.y);
    final x2 = math.max(right, point.x);
    final y2 = math.max(bottom, point.y);
    return LayoutRectangle(x1, y1, x2 - x1, y2 - y1);
  }
}

/// Returns the smallest rectangle containing all [points].
LayoutRectangle boundingBox(Iterable<LayoutPoint> points) {
  final iterator = points.iterator;
  if (!iterator.moveNext()) {
    return const LayoutRectangle(0, 0, 0, 0);
  }
  var x1 = iterator.current.x;
  var x2 = iterator.current.x;
  var y1 = iterator.current.y;
  var y2 = iterator.current.y;
  while (iterator.moveNext()) {
    final p = iterator.current;
    if (p.x < x1) x1 = p.x;
    if (p.x > x2) x2 = p.x;
    if (p.y < y1) y1 = p.y;
    if (p.y > y2) y2 = p.y;
  }
  return LayoutRectangle(x1, y1, x2 - x1, y2 - y1);
}
