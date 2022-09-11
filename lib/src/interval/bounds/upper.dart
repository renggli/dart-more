import '../bound.dart';

/// Abstract base-class for upper bounds.
abstract class UpperBound<T> extends Bound<T> {}

class Below<T> extends UpperBound<T> {
  Below(this.comparator, this.endpoint);

  final Comparator<T> comparator;

  @override
  final T endpoint;

  @override
  bool get isBounded => true;

  @override
  bool contains(T value) => comparator(endpoint, value) > 0;

  @override
  int get hashCode => Object.hash(Below, endpoint);

  @override
  bool operator ==(Object other) =>
      other is Below<T> && endpoint == other.endpoint;

  @override
  String toString() => '$endpoint)';
}

class BelowOrEqual<T> extends UpperBound<T> {
  BelowOrEqual(this.comparator, this.endpoint);

  final Comparator<T> comparator;

  @override
  final T endpoint;

  @override
  bool get isBounded => true;

  @override
  bool get isOpen => false;

  @override
  bool contains(T value) => comparator(endpoint, value) >= 0;

  @override
  int get hashCode => Object.hash(BelowOrEqual, endpoint);

  @override
  bool operator ==(Object other) =>
      other is BelowOrEqual<T> && endpoint == other.endpoint;

  @override
  String toString() => '$endpoint]';
}

class BelowAll<T> extends UpperBound<T> {
  @override
  bool contains(T value) => true;

  @override
  int get hashCode => 9116336;

  @override
  bool operator ==(Object other) => other is BelowAll<T>;

  @override
  String toString() => '+∞)';
}
