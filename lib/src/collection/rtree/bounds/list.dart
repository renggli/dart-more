import 'dart:typed_data';

import '../bounds.dart';

/// N-dimensional bounding box backed by [min] and [max] coordinate lists.
class ListBounds extends Bounds {
  new(this.min, this.max) : super() {
    assert(min.isNotEmpty, 'min must not be empty');
    assert(min.length == max.length, 'min and max must have the same length');
    assert(() {
      for (var i = 0; i < min.length; i++) {
        assert(min[i] <= max[i], 'min must be <= max');
      }
      return true;
    }());
  }

  @override
  final Float64List min;

  @override
  final Float64List max;

  @override
  int get length => min.length;

  @override
  double getMin(int dimension) => min[dimension];

  @override
  double getMax(int dimension) => max[dimension];
}

/// Extension on [List<double>] of coordinates to convert to a zero-volume point [Bounds].
extension ListBoundsExtension on List<double> {
  /// Converts this coordinate list to a zero-volume point [Bounds].
  Bounds toBounds() => Bounds.fromList(this);
}
