import 'dart:math' as math;
import 'dart:typed_data';

import 'bounds/list.dart';
import 'bounds/point.dart';
import 'bounds/rectangle.dart';

export 'bounds/list.dart' show ListBoundsExtension;
export 'bounds/point.dart' show PointBoundsExtension;
export 'bounds/rectangle.dart' show RectangleBoundsExtension;

/// Axis-aligned bounding box for N-dimensional spatial indexing.
abstract class Bounds {
  /// Const constructor for subclasses.
  const new();

  /// Creates a bounding box from a [math.Point].
  factory fromPoint(math.Point<double> point) => point.toBounds();

  /// Creates a bounding box from a [math.Rectangle].
  factory fromRectangle(math.Rectangle<double> rectangle) =>
      rectangle.toBounds();

  /// Creates a 2D bounding box from coordinates.
  ///
  /// If [maxX] and [maxY] are omitted, creates a point bounding box at
  /// ([minX], [minY]).
  factory from2D(double minX, double minY, [double? maxX, double? maxY]) {
    assert(
      (maxX == null) == (maxY == null),
      'maxX and maxY must both be provided or omitted',
    );
    return maxX != null && maxY != null
        ? RectangleBounds(minX, minY, maxX, maxY)
        : PointBounds(minX, minY);
  }

  /// Creates a bounding box from coordinate list [min] and optional [max].
  ///
  /// If [max] is omitted, creates a point bounding box at [min].
  factory fromList(List<double> min, [List<double>? max]) {
    assert(min.isNotEmpty, 'min must not be empty');
    if (max == null) {
      if (min.length == 2) {
        return PointBounds(min[0], min[1]);
      }
      final values = Float64List.fromList(min);
      return ListBounds(values, values);
    }
    assert(min.length == max.length, 'min and max must have matching lengths');
    if (min.length == 2) {
      return RectangleBounds(min[0], min[1], max[0], max[1]);
    }
    return ListBounds(Float64List.fromList(min), Float64List.fromList(max));
  }

  /// Number of dimensions.
  int get length;

  /// Returns the minimum coordinate value for the given [dimension].
  ///
  /// Throws a [RangeError] if [dimension] is out of bounds.
  double getMin(int dimension);

  /// Returns the maximum coordinate value for the given [dimension].
  ///
  /// Throws a [RangeError] if [dimension] is out of bounds.
  double getMax(int dimension);

  /// Minimum X coordinate for 2D bounds.
  ///
  /// Throws a [RangeError] if [length] is less than `1`.
  double get minX => getMin(0);

  /// Minimum Y coordinate for 2D bounds.
  ///
  /// Throws a [RangeError] if [length] is less than `2`.
  double get minY => getMin(1);

  /// Maximum X coordinate for 2D bounds.
  ///
  /// Throws a [RangeError] if [length] is less than `1`.
  double get maxX => getMax(0);

  /// Maximum Y coordinate for 2D bounds.
  ///
  /// Throws a [RangeError] if [length] is less than `2`.
  double get maxY => getMax(1);

  /// Width (extent along dimension 0).
  ///
  /// Throws a [RangeError] if [length] is less than `1`.
  double get width => getMax(0) - getMin(0);

  /// Height (extent along dimension 1).
  ///
  /// Throws a [RangeError] if [length] is less than `2`.
  double get height => getMax(1) - getMin(1);

  /// Minimum coordinate values for each dimension.
  List<double> get min => [for (var i = 0; i < length; i++) getMin(i)];

  /// Maximum coordinate values for each dimension.
  List<double> get max => [for (var i = 0; i < length; i++) getMax(i)];

  /// Whether this bounding box represents a single point (zero extent in all
  /// dimensions).
  bool get isPoint {
    for (var i = 0; i < length; i++) {
      if (getMin(i) != getMax(i)) return false;
    }
    return true;
  }

  /// Edge lengths of each dimension.
  List<double> get edges => [
    for (var i = 0; i < length; i++) getMax(i) - getMin(i),
  ];

  /// Sum of edge lengths (margin or half-perimeter in 2D) of this bounding box.
  double get margin {
    var result = 0.0;
    for (var i = 0; i < length; i++) {
      result += getMax(i) - getMin(i);
    }
    return result;
  }

  /// Hypervolume (area) of this bounding box.
  double get area {
    var result = getMax(0) - getMin(0);
    for (var i = 1; i < length; i++) {
      result *= getMax(i) - getMin(i);
    }
    return result;
  }

  /// Center coordinates of this bounding box.
  List<double> get center => [
    for (var i = 0; i < length; i++) getMin(i) + 0.5 * (getMax(i) - getMin(i)),
  ];

  /// Computes the Euclidean distance squared from a given [point] to the
  /// closest point in this bounding box.
  double minDistanceToPointSquared(List<double> point) {
    assert(point.length == length, 'Point must have matching dimensions');
    var sum = 0.0;
    for (var i = 0; i < length; i++) {
      final p = point[i];
      final minVal = getMin(i);
      final maxVal = getMax(i);
      if (p < minVal) {
        final d = minVal - p;
        sum += d * d;
      } else if (p > maxVal) {
        final d = p - maxVal;
        sum += d * d;
      }
    }
    return sum;
  }

  /// Computes the Euclidean distance squared between this bounding box and
  /// [other].
  double minDistanceToBoundsSquared(Bounds other) {
    assert(other.length == length, 'Bounds must have matching dimensions');
    var sum = 0.0;
    for (var i = 0; i < length; i++) {
      final thisMin = getMin(i);
      final otherMax = other.getMax(i);
      if (otherMax < thisMin) {
        final d = thisMin - otherMax;
        sum += d * d;
      } else {
        final thisMax = getMax(i);
        final otherMin = other.getMin(i);
        if (thisMax < otherMin) {
          final d = otherMin - thisMax;
          sum += d * d;
        }
      }
    }
    return sum;
  }

  /// Computes whether another bounding box is fully contained in this one.
  bool contains(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    for (var i = 0; i < length; i++) {
      if (other.getMin(i) < getMin(i) || getMax(i) < other.getMax(i)) {
        return false;
      }
    }
    return true;
  }

  /// Computes the union of this bounding box and another one.
  Bounds union(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    if (length == 2) {
      return RectangleBounds(
        math.min(getMin(0), other.getMin(0)),
        math.min(getMin(1), other.getMin(1)),
        math.max(getMax(0), other.getMax(0)),
        math.max(getMax(1), other.getMax(1)),
      );
    }
    final minList = Float64List(length);
    final maxList = Float64List(length);
    for (var i = 0; i < length; i++) {
      minList[i] = math.min(getMin(i), other.getMin(i));
      maxList[i] = math.max(getMax(i), other.getMax(i));
    }
    return ListBounds(minList, maxList);
  }

  /// Computes the hypervolume (area) of the union of this bounding box and
  /// [other] without allocating an intermediate [Bounds].
  double unionArea(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    var result =
        math.max(getMax(0), other.getMax(0)) -
        math.min(getMin(0), other.getMin(0));
    for (var i = 1; i < length; i++) {
      result *=
          math.max(getMax(i), other.getMax(i)) -
          math.min(getMin(i), other.getMin(i));
    }
    return result;
  }

  /// Computes if this bounding box and another one intersect.
  bool intersects(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    for (var i = 0; i < length; i++) {
      if (getMin(i) > other.getMax(i) || other.getMin(i) > getMax(i)) {
        return false;
      }
    }
    return true;
  }

  /// Computes the intersection of this bounding box and another one.
  Bounds? intersection(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    if (length == 2) {
      final minX = math.max(getMin(0), other.getMin(0));
      final maxX = math.min(getMax(0), other.getMax(0));
      if (minX > maxX) return null;
      final minY = math.max(getMin(1), other.getMin(1));
      final maxY = math.min(getMax(1), other.getMax(1));
      if (minY > maxY) return null;
      return RectangleBounds(minX, minY, maxX, maxY);
    }
    final minList = Float64List(length);
    final maxList = Float64List(length);
    for (var i = 0; i < length; i++) {
      final lower = math.max(getMin(i), other.getMin(i));
      final upper = math.min(getMax(i), other.getMax(i));
      if (lower > upper) return null;
      minList[i] = lower;
      maxList[i] = upper;
    }
    return ListBounds(minList, maxList);
  }

  /// Computes the hypervolume (area) of the intersection of this bounding box
  /// and [other], or `0.0` if they do not intersect, without allocating an
  /// intermediate [Bounds].
  double intersectionArea(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    var result = 1.0;
    for (var i = 0; i < length; i++) {
      final lower = math.max(getMin(i), other.getMin(i));
      final upper = math.min(getMax(i), other.getMax(i));
      if (lower >= upper) return 0.0;
      result *= upper - lower;
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Bounds || other.length != length) return false;
    for (var i = 0; i < length; i++) {
      if (other.getMin(i) != getMin(i) || other.getMax(i) != getMax(i)) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    var minHash = 0;
    var maxHash = 0;
    for (var i = 0; i < length; i++) {
      minHash = Object.hash(minHash, getMin(i));
      maxHash = Object.hash(maxHash, getMax(i));
    }
    return Object.hash(length, minHash, maxHash);
  }

  @override
  String toString() {
    final result = StringBuffer('Bounds(');
    for (var i = 0; i < length; i++) {
      if (i > 0) result.write(', ');
      result.write(getMin(i));
    }
    if (!isPoint) {
      result.write('; ');
      for (var i = 0; i < length; i++) {
        if (i > 0) result.write(', ');
        result.write(getMax(i));
      }
    }
    result.write(')');
    return result.toString();
  }

  /// Computes the union of all bounding boxes.
  ///
  /// Throws a [StateError] if [bounds] is empty.
  static Bounds unionAll(Iterable<Bounds> bounds) {
    final iterator = bounds.iterator;
    if (!iterator.moveNext()) throw StateError('Empty bounds: $bounds');
    final first = iterator.current;
    if (first.length == 2) {
      var minX = first.getMin(0);
      var minY = first.getMin(1);
      var maxX = first.getMax(0);
      var maxY = first.getMax(1);
      while (iterator.moveNext()) {
        final current = iterator.current;
        assert(current.length == 2, 'Bounds must have matching dimensions');
        minX = math.min(minX, current.getMin(0));
        minY = math.min(minY, current.getMin(1));
        maxX = math.max(maxX, current.getMax(0));
        maxY = math.max(maxY, current.getMax(1));
      }
      return RectangleBounds(minX, minY, maxX, maxY);
    }
    final dims = first.length;
    final minList = Float64List(dims);
    final maxList = Float64List(dims);
    for (var i = 0; i < dims; i++) {
      minList[i] = first.getMin(i);
      maxList[i] = first.getMax(i);
    }
    while (iterator.moveNext()) {
      final current = iterator.current;
      assert(current.length == dims, 'Bounds must have matching dimensions');
      for (var i = 0; i < dims; i++) {
        minList[i] = math.min(minList[i], current.getMin(i));
        maxList[i] = math.max(maxList[i], current.getMax(i));
      }
    }
    return ListBounds(minList, maxList);
  }

  /// Computes the intersection of all bounding boxes, or `null` if disjoint.
  ///
  /// Throws a [StateError] if [bounds] is empty.
  static Bounds? intersectionAll(Iterable<Bounds> bounds) {
    final iterator = bounds.iterator;
    if (!iterator.moveNext()) throw StateError('Empty bounds: $bounds');
    final first = iterator.current;
    if (first.length == 2) {
      var minX = first.getMin(0);
      var minY = first.getMin(1);
      var maxX = first.getMax(0);
      var maxY = first.getMax(1);
      while (iterator.moveNext()) {
        final current = iterator.current;
        assert(current.length == 2, 'Bounds must have matching dimensions');
        minX = math.max(minX, current.getMin(0));
        minY = math.max(minY, current.getMin(1));
        maxX = math.min(maxX, current.getMax(0));
        maxY = math.min(maxY, current.getMax(1));
        if (minX > maxX || minY > maxY) return null;
      }
      return RectangleBounds(minX, minY, maxX, maxY);
    }
    final dims = first.length;
    final minList = Float64List(dims);
    final maxList = Float64List(dims);
    for (var i = 0; i < dims; i++) {
      minList[i] = first.getMin(i);
      maxList[i] = first.getMax(i);
    }
    while (iterator.moveNext()) {
      final current = iterator.current;
      assert(current.length == dims, 'Bounds must have matching dimensions');
      for (var i = 0; i < dims; i++) {
        final lower = math.max(minList[i], current.getMin(i));
        final upper = math.min(maxList[i], current.getMax(i));
        if (lower > upper) return null;
        minList[i] = lower;
        maxList[i] = upper;
      }
    }
    return ListBounds(minList, maxList);
  }
}
