import 'dart:math' as math;
import 'dart:typed_data';

/// Axis-aligned bounding box.
class Bounds {
  factory Bounds(int length) =>
      Bounds._(Float64List(length), Float64List(length));

  factory Bounds.fromLists(List<double> min, List<double> max) =>
      Bounds._(Float64List.fromList(min), Float64List.fromList(max));

  factory Bounds.fromPoint(List<double> point) {
    final shared = Float64List.fromList(point);
    return Bounds._(shared, shared);
  }

  Bounds._(this.min, this.max)
      : assert(min.isNotEmpty),
        assert(min.length == max.length);

  final Float64List min;
  final Float64List max;

  int get length => min.length;

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

  List<double> get edges {
    final result = Float64List(length);
    for (var i = 0; i < length; i++) {
      result[i] = max[i] - min[i];
    }
    return result;
  }

  double get area {
    var result = max[0] - min[0];
    for (var i = 1; i < length; i++) {
      result *= max[i] - min[i];
    }
    return result;
  }

  List<double> get center {
    final result = Float64List(length);
    for (var i = 0; i < length; i++) {
      result[i] = 0.5 * (min[i] + max[i]);
    }
    return result;
  }

  /// Computes whether another bounding box is fully contained in this one.
  bool contains(Bounds bounds) {
    for (var i = 0; i < length; i++) {
      if (bounds.min[i] < min[i] || max[i] < bounds.max[i]) {
        return false;
      }
    }
    return true;
  }

  /// Computes the union of this bounding box and another one.
  Bounds union(Bounds other) {
    final result = Bounds(length);
    for (var i = 0; i < length; i++) {
      result.min[i] = math.min(min[i], other.min[i]);
      result.max[i] = math.max(max[i], other.max[i]);
    }
    return result;
  }

  /// Computes if this bounding box and another one intersect.
  bool intersects(Bounds other) {
    for (var i = 0; i < length; i++) {
      final lower = math.max(min[i], other.min[i]);
      final upper = math.min(max[i], other.max[i]);
      if (lower > upper) {
        return false;
      }
    }
    return true;
  }

  /// Computes the intersection of this bounding box and another one.
  Bounds? intersection(Bounds other) {
    final result = Bounds(length);
    for (var i = 0; i < length; i++) {
      final lower = math.max(min[i], other.min[i]);
      final upper = math.min(max[i], other.max[i]);
      if (lower <= upper) {
        result.min[i] = lower;
        result.max[i] = upper;
      } else {
        return null;
      }
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
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
}
