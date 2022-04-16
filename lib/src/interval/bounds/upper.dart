import '../bound.dart';

/// Abstract base-class for upper bounds.
abstract class UpperBound<T extends Comparable<T>> extends Bound<T> {}

class Below<T extends Comparable<T>> extends UpperBound<T> {
  Below(this.endpoint);

  @override
  final T endpoint;

  @override
  bool contains(T value) => endpoint.compareTo(value) > 0;

  @override
  int get hashCode => Object.hash(Below, endpoint);

  @override
  bool operator ==(Object other) =>
      other is Below<T> && endpoint == other.endpoint;

  @override
  String toString() => '$endpoint)';
}

class BelowOrEqual<T extends Comparable<T>> extends UpperBound<T> {
  BelowOrEqual(this.endpoint);

  @override
  final T endpoint;

  @override
  bool get isOpen => false;

  @override
  bool contains(T value) => endpoint.compareTo(value) >= 0;

  @override
  int get hashCode => Object.hash(BelowOrEqual, endpoint);

  @override
  bool operator ==(Object other) =>
      other is BelowOrEqual<T> && endpoint == other.endpoint;

  @override
  String toString() => '$endpoint]';
}

class BelowAll<T extends Comparable<T>> extends UpperBound<T> {
  @override
  bool contains(T value) => true;

  @override
  int get hashCode => 9116336;

  @override
  bool operator ==(Object other) => other is BelowAll<T>;

  @override
  String toString() => '+∞)';
}
