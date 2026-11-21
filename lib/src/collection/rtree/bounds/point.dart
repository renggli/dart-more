import 'dart:math' as math;

import '../bounds.dart';

/// 2-dimensional point bounding box.
class PointBounds extends Bounds {
  const new(this.x, this.y) : super();

  final double x;

  final double y;

  @override
  int get length => 2;

  @override
  double getMin(int dimension) => switch (dimension) {
    0 => x,
    1 => y,
    _ => throw RangeError.range(dimension, 0, 1, 'dimension'),
  };

  @override
  double getMax(int dimension) => getMin(dimension);

  @override
  bool get isPoint => true;

  @override
  double get minX => x;

  @override
  double get minY => y;

  @override
  double get maxX => x;

  @override
  double get maxY => y;

  @override
  double get width => 0.0;

  @override
  double get height => 0.0;

  @override
  double get area => 0.0;

  @override
  double get margin => 0.0;

  @override
  List<double> get edges => const [0.0, 0.0];

  @override
  List<double> get center => [x, y];
}

/// Extension on [math.Point<double>] to convert to [Bounds].
extension PointBoundsExtension on math.Point<double> {
  /// Converts this [math.Point] to a [Bounds].
  Bounds toBounds() => PointBounds(x, y);
}
