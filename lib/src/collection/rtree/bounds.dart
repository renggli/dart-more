import 'dart:math' as math;
import 'dart:typed_data';

/// Axis-aligned bounding box.
class Bounds {
  /// Creates a bounding box with the given number of dimensions [length].
  factory(int length) => Bounds._(Float64List(length), Float64List(length));

  /// Creates a bounding box from coordinate lists [min] and [max].
  factory fromLists(List<double> min, List<double> max) =>
      Bounds._(Float64List.fromList(min), Float64List.fromList(max));

  /// Creates a zero-volume point bounding box at the given [point].
  factory fromPoint(List<double> point) =>
      Bounds._(Float64List.fromList(point), Float64List.fromList(point));

  new _(this.min, this.max)
    : assert(min.isNotEmpty, 'min must not be empty'),
      assert(min.length == max.length, 'min and max must have the same length'),
      assert(() {
        for (var i = 0; i < min.length; i++) {
          assert(min[i] <= max[i], 'min must be less than or equal to max');
        }
        return true;
      }());

  /// Minimum coordinate values for each dimension.
  final Float64List min;

  /// Maximum coordinate values for each dimension.
  final Float64List max;

  /// Number of dimensions.
  int get length => min.length;

  /// Whether this bounding box represents a single point (all dimensions zero).
  bool get isPoint {
    if (min == max) {
      return true;
    }
    for (var i = 0; i < length; i++) {
      if (min[i] != max[i]) {
        return false;
      }
    }
    return true;
  }

  /// Edge lengths of each dimension.
  List<double> get edges {
    final result = Float64List(length);
    for (var i = 0; i < length; i++) {
      result[i] = max[i] - min[i];
    }
    return result;
  }

  /// Hypervolume (area) of this bounding box.
  double get area {
    var result = max[0] - min[0];
    for (var i = 1; i < length; i++) {
      result *= max[i] - min[i];
    }
    return result;
  }

  /// Center coordinates of this bounding box.
  List<double> get center {
    final result = Float64List(length);
    for (var i = 0; i < length; i++) {
      result[i] = 0.5 * (min[i] + max[i]);
    }
    return result;
  }

  /// Computes whether another bounding box is fully contained in this one.
  bool contains(Bounds bounds) {
    assert(length == bounds.length, 'Bounds must have matching dimensions');
    for (var i = 0; i < length; i++) {
      if (bounds.min[i] < min[i] || max[i] < bounds.max[i]) {
        return false;
      }
    }
    return true;
  }

  /// Computes the union of this bounding box and another one.
  Bounds union(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    final result = Bounds(length);
    for (var i = 0; i < length; i++) {
      result.min[i] = math.min(min[i], other.min[i]);
      result.max[i] = math.max(max[i], other.max[i]);
    }
    return result;
  }

  /// Computes if this bounding box and another one intersect.
  bool intersects(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    for (var i = 0; i < length; i++) {
      final lower = math.max(min[i], other.min[i]);
      final upper = math.min(max[i], other.max[i]);
      if (lower > upper) return false;
    }
    return true;
  }

  /// Computes the intersection of this bounding box and another one.
  Bounds? intersection(Bounds other) {
    assert(length == other.length, 'Bounds must have matching dimensions');
    final result = Bounds(length);
    for (var i = 0; i < length; i++) {
      final lower = math.max(min[i], other.min[i]);
      final upper = math.min(max[i], other.max[i]);
      if (lower > upper) return null;
      result.min[i] = lower;
      result.max[i] = upper;
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Bounds) return false;
    if (other.length != length) return false;
    for (var i = 0; i < length; i++) {
      if (other.min[i] != min[i] || other.max[i] != max[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(min), Object.hashAll(max));

  @override
  String toString() {
    final result = StringBuffer('Bounds(');
    result.writeAll(min, ', ');
    if (!isPoint) {
      result.write('; ');
      result.writeAll(max, ', ');
    }
    result.write(')');
    return result.toString();
  }

  /// Computes the union of all bounding boxes.
  static Bounds unionAll(Iterable<Bounds> bounds) {
    final iterator = bounds.iterator;
    if (!iterator.moveNext()) throw StateError('Empty bounds: $bounds');
    final result = Bounds.fromLists(iterator.current.min, iterator.current.max);
    while (iterator.moveNext()) {
      final current = iterator.current;
      for (var i = 0; i < result.length; i++) {
        result.min[i] = math.min(result.min[i], current.min[i]);
        result.max[i] = math.max(result.max[i], current.max[i]);
      }
    }
    return result;
  }

  /// Computes the intersection of all bounding boxes.
  static Bounds? intersectionAll(Iterable<Bounds> bounds) {
    final iterator = bounds.iterator;
    if (!iterator.moveNext()) throw StateError('Empty bounds: $bounds');
    final result = Bounds.fromLists(iterator.current.min, iterator.current.max);
    while (iterator.moveNext()) {
      final current = iterator.current;
      for (var i = 0; i < result.length; i++) {
        final lower = math.max(result.min[i], current.min[i]);
        final upper = math.min(result.max[i], current.max[i]);
        if (lower > upper) return null;
        result.min[i] = lower;
        result.max[i] = upper;
      }
    }
    return result;
  }
}
