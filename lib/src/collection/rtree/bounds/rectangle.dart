import 'dart:math' as math;

import '../bounds.dart';

/// 2-dimensional rectangle bounding box.
class RectangleBounds extends Bounds {
  const new(this.minX, this.minY, this.maxX, this.maxY)
    : assert(minX <= maxX, 'minX must be <= maxX'),
      assert(minY <= maxY, 'minY must be <= maxY'),
      super();

  @override
  final double minX;

  @override
  final double minY;

  @override
  final double maxX;

  @override
  final double maxY;

  @override
  int get length => 2;

  @override
  double getMin(int dimension) => switch (dimension) {
    0 => minX,
    1 => minY,
    _ => throw RangeError.range(dimension, 0, 1, 'dimension'),
  };

  @override
  double getMax(int dimension) => switch (dimension) {
    0 => maxX,
    1 => maxY,
    _ => throw RangeError.range(dimension, 0, 1, 'dimension'),
  };

  @override
  double get width => maxX - minX;

  @override
  double get height => maxY - minY;

  @override
  double get area => (maxX - minX) * (maxY - minY);

  @override
  double get margin => (maxX - minX) + (maxY - minY);

  @override
  List<double> get center => [
    minX + 0.5 * (maxX - minX),
    minY + 0.5 * (maxY - minY),
  ];
}

/// Extension on [math.Rectangle<double>] to convert to [Bounds].
extension RectangleBoundsExtension on math.Rectangle<double> {
  /// Converts this [math.Rectangle] to a [Bounds].
  Bounds toBounds() => RectangleBounds(left, top, right, bottom);
}
