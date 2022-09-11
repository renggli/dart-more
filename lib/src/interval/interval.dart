import '../../comparator.dart';
import 'bounds/empty.dart';
import 'bounds/lower.dart';
import 'bounds/upper.dart';

/// An interval over an ordering of type [T].
///
/// See https://en.wikipedia.org/wiki/Interval_(mathematics).
class Interval<T> {
  /// Returns a interval containing `{ x ∈ T | lower < x < upper }`.
  factory Interval.open(T lower, T upper, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      Above<T>(comparator, lower),
      Below<T>(comparator, upper),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | lower <= x <= upper }`.
  factory Interval.closed(T lower, T upper, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveOrEqual<T>(comparator, lower),
      BelowOrEqual<T>(comparator, upper),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | lower < x <= upper }`.
  factory Interval.openClosed(T lower, T upper, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      Above<T>(comparator, lower),
      BelowOrEqual<T>(comparator, upper),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | lower <= x < upper }`.
  factory Interval.closedOpen(T lower, T upper, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveOrEqual<T>(comparator, lower),
      Below<T>(comparator, upper),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | x < upper }`.
  factory Interval.lessThan(T upper, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveAll<T>(),
      Below<T>(comparator, upper),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | x <= upper }`.
  factory Interval.atMost(T upper, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveAll<T>(),
      BelowOrEqual<T>(comparator, upper),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | lower < x }`.
  factory Interval.greaterThan(T lower, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      Above<T>(comparator, lower),
      BelowAll<T>(),
      comparator,
    );
  }

  /// Returns a interval containing `{ x ∈ T | lower <= x }`.
  factory Interval.atLeast(T lower, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveOrEqual<T>(comparator, lower),
      BelowAll<T>(),
      comparator,
    );
  }

  /// Returns an empty interval of type [T]: `{} = ∅`
  factory Interval.empty({Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      Empty<T>(),
      Empty<T>(),
      comparator,
    );
  }

  /// Returns an interval containing a single value of type [T]:
  /// `{ x ∈ T | x = value }`.
  factory Interval.single(T value, {Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveOrEqual<T>(comparator, value),
      BelowOrEqual<T>(comparator, value),
      comparator,
    );
  }

  /// Returns a interval containing all values of type [T]: `{ x ∈ T }`
  factory Interval.all({Comparator<T>? comparator}) {
    comparator ??= naturalComparator<T>();
    return Interval<T>._(
      AboveAll<T>(),
      BelowAll<T>(),
      comparator,
    );
  }

  /// Constructs an interval from a [lower] and [upper] bound.
  Interval._(this.lower, this.upper, this.comparator)
      : assert(
            lower.isBounded && upper.isBounded
                ? comparator(lower.endpoint, upper.endpoint) <= 0
                : true,
            'Invalid endpoints for $lower..$upper'),
        assert(
            lower.isBounded &&
                    upper.isBounded &&
                    comparator(lower.endpoint, upper.endpoint) == 0
                ? lower.isClosed && upper.isClosed
                : true,
            'Invalid bounds $lower..$upper');

  /// Returns the upper bound of this interval.
  final LowerBound<T> lower;

  /// Returns the lower bound of this interval.
  final UpperBound<T> upper;

  /// Returns the underlying comparator of this interval.
  final Comparator<T> comparator;

  /// Returns `true`, if this is an empty interval.
  bool get isEmpty => lower is Empty<T> || upper is Empty<T>;

  /// Returns `true`, if this is a degenerated interval with a single value.
  bool get isSingle =>
      lower.isClosed &&
      lower.isBounded &&
      upper.isClosed &&
      upper.isBounded &&
      lower.endpoint == upper.endpoint;

  /// Returns true if the [value] is included in this interval.
  bool contains(T value) => lower.contains(value) && upper.contains(value);

  /// Returns the interaction of this interval and [other].
  Interval<T> intersection(Interval<T> other) {
    if (isEmpty) {
      return this;
    } else if (other.isEmpty) {
      return other;
    }
    // Find lower bound.
    var newLower = lower;
    if (lower.isUnbounded) {
      newLower = other.lower;
    } else if (other.lower.isBounded) {
      final cmp = comparator(lower.endpoint, other.lower.endpoint);
      if (cmp < 0 || (cmp == 0 && other.lower.isOpen)) {
        newLower = other.lower;
      }
    }
    // Find upper bound.
    var newUpper = upper;
    if (upper.isUnbounded) {
      newUpper = other.upper;
    } else if (other.upper.isBounded) {
      final cmp = comparator(upper.endpoint, other.upper.endpoint);
      if (cmp > 0 || (cmp == 0 && other.upper.isOpen)) {
        newUpper = other.upper;
      }
    }
    // Swap bounds if necessary.
    if (newLower.isBounded && newUpper.isBounded) {
      final cmp = comparator(newLower.endpoint, newUpper.endpoint);
      if (cmp > 0 || (cmp == 0 && (newLower.isOpen || newUpper.isOpen))) {
        return Interval<T>.empty();
      } else if (cmp == 0) {
        return Interval<T>.single(newLower.endpoint);
      }
    }
    return Interval<T>._(newLower, newUpper, comparator);
  }

  /// Returns the minimal interval enclosing this interval and [other].
  Interval<T> span(Interval<T> other) {
    if (isEmpty) {
      return other;
    } else if (other.isEmpty) {
      return this;
    }
    // Find lower bound.
    var newLower = lower;
    if (other.lower.isUnbounded) {
      newLower = other.lower;
    } else if (lower.isBounded) {
      final cmp = comparator(lower.endpoint, other.lower.endpoint);
      if (cmp > 0 || (cmp == 0 && other.lower.isClosed)) {
        newLower = other.lower;
      }
    }
    // Find upper bound.
    var newUpper = upper;
    if (other.upper.isUnbounded) {
      newUpper = other.upper;
    } else if (upper.isBounded) {
      final cmp = comparator(upper.endpoint, other.upper.endpoint);
      if (cmp < 0 || (cmp == 0 && other.upper.isClosed)) {
        newUpper = other.upper;
      }
    }
    return Interval<T>._(newLower, newUpper, comparator);
  }

  @override
  bool operator ==(Object other) =>
      other is Interval<T> && lower == other.lower && upper == other.upper;

  @override
  int get hashCode => Object.hash(lower, upper);

  @override
  String toString() => isEmpty ? '$lower' : '$lower..$upper';
}
