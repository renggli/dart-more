import 'package:meta/meta.dart';

/// Abstract base-class for bounds.
abstract class Bound<T> {
  /// Returns `true`, if the [value] satisfies these bounds.
  bool contains(T value);

  /// Returns `true`, if the endpoint is excluded from these bounds.
  bool get isOpen => true;

  /// Returns `true`, if the endpoint is included from these bounds.
  @nonVirtual
  bool get isClosed => !isOpen;

  /// Returns `true` if this is bounded endpoint.
  bool get isBounded => false;

  /// Returns `true`, if this is an unbounded endpoint.
  @nonVirtual
  bool get isUnbounded => !isBounded;

  /// Returns the endpoint, or throws a [StateError] if unbounded.
  T get endpoint => throw StateError('$this is not bounded.');
}
