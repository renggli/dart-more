import 'dart:typed_data';

import '../bounds.dart';

/// N-dimensional bounding box backed by [min] and [max] coordinate lists.
class ListBounds extends Bounds {
  new(this._min, this._max) : super() {
    assert(_min.isNotEmpty, 'min must not be empty');
    assert(_min.length == _max.length, 'min and max must have the same length');
    assert(() {
      for (var i = 0; i < _min.length; i++) {
        assert(_min[i] <= _max[i], 'min must be <= max');
      }
      return true;
    }());
  }

  final Float64List _min;
  final Float64List _max;

  @override
  List<double> get min => _min.asUnmodifiableView();

  @override
  List<double> get max => _max.asUnmodifiableView();

  @override
  int get length => _min.length;

  @override
  double getMin(int dimension) => _min[dimension];

  @override
  double getMax(int dimension) => _max[dimension];
}

/// Extension on [List<double>] of coordinates to convert to a zero-volume point [Bounds].
extension ListBoundsExtension on List<double> {
  /// Converts this coordinate list to a zero-volume point [Bounds].
  Bounds toBounds() => Bounds.fromList(this);
}
