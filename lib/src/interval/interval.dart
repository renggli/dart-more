import 'package:meta/meta.dart';

import '../collection/range.dart';

/// An interval over a continuous ordering of type [T].
///
/// Contrary to the [Range] collection, this object includes both the lower and
/// upper endpoint; and provides efficient means to compute the [intersection]
/// and [union] between objects.
///
/// See https://en.wikipedia.org/wiki/Interval_(mathematics).
@immutable
class Interval<T extends Comparable<T>> {
  /// Returns a interval between [lower] and [upper] (inclusive):
  /// `{ x ∈ T | lower <= x <= upper }`.
  ///
  /// If the [upper] argument is omitted, this interval is assumed to contain
  /// the single element [lower].
  Interval(T lower, [T? upper]) : this._(lower, upper ?? lower);

  Interval._(this.lower, this.upper)
      : assert(
          lower.compareTo(upper) <= 0,
          'Invalid endpoints for $lower..$upper',
        );

  /// Returns the lower bound of this interval.
  final T lower;

  /// Returns the upper bound of this interval.
  final T upper;

  /// Returns `true`, if this is an interval with a single value.
  bool get isSingle => lower == upper;

  /// Whether [value] is included in this interval.
  bool contains(T value) =>
      lower.compareTo(value) <= 0 && value.compareTo(upper) <= 0;

  /// Whether this interval and [other] overlap.
  bool intersects(Interval<T> other) =>
      lower.compareTo(other.upper) <= 0 && other.lower.compareTo(upper) <= 0;

  /// Whether this interval completely covers [other].
  bool encloses(Interval<T> other) =>
      lower.compareTo(other.lower) <= 0 && other.upper.compareTo(upper) <= 0;

  /// Returns the interval where this and [other] interval overlap. If the
  /// intervals do not intersect, return `null`.
  Interval<T>? intersection(Interval<T> other) {
    if (!intersects(other)) return null;
    final newLower = lower.compareTo(other.lower) >= 0 ? lower : other.lower;
    final newUpper = upper.compareTo(other.upper) <= 0 ? upper : other.upper;
    return Interval<T>(newLower, newUpper);
  }

  /// Returns the minimal interval enclosing this and [other] interval.
  Interval<T> union(Interval<T> other) => Interval<T>(
        lower.compareTo(other.lower) < 0 ? lower : other.lower,
        upper.compareTo(other.upper) > 0 ? upper : other.upper,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Interval && lower == other.lower && upper == other.upper);

  @override
  int get hashCode => Object.hash(lower, upper);

  @override
  String toString() => '$lower..$upper';
}


