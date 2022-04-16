import '../bound.dart';

/// Abstract base-class for lower bounds.
abstract class LowerBound<T extends Comparable<T>> extends Bound<T> {}

class Above<T extends Comparable<T>> extends LowerBound<T> {
  Above(this.endpoint);

  @override
  final T endpoint;

  @override
  bool contains(T value) => endpoint.compareTo(value) < 0;

  @override
  int get hashCode => Object.hash(Above, endpoint);

  @override
  bool operator ==(Object other) =>
      other is Above<T> && endpoint == other.endpoint;

  @override
  String toString() => '($endpoint';
}

class AboveOrEqual<T extends Comparable<T>> extends LowerBound<T> {
  AboveOrEqual(this.endpoint);

  @override
  final T endpoint;

  @override
  bool contains(T value) => endpoint.compareTo(value) <= 0;

  @override
  bool get isOpen => false;

  @override
  int get hashCode => Object.hash(AboveOrEqual, endpoint);

  @override
  bool operator ==(Object other) =>
      other is AboveOrEqual<T> && endpoint == other.endpoint;

  @override
  String toString() => '[$endpoint';
}

class AboveAll<T extends Comparable<T>> extends LowerBound<T> {
  @override
  bool contains(T value) => true;

  @override
  int get hashCode => 9859154;

  @override
  bool operator ==(Object other) => other is AboveAll<T>;

  @override
  String toString() => '(-∞';
}
