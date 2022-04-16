import 'package:meta/meta.dart';

/// Abstract base-class for bounds.
abstract class Bound<T extends Comparable<T>> {
  /// Returns `true`, if the [value] satisfies these bounds.
  bool contains(T value);

  /// Returns `true`, if the endpoint is excluded from these bounds.
  bool get isOpen => true;

  /// Returns `true`, if the endpoint is included from these bounds.
  @nonVirtual
  bool get isClosed => !isOpen;

  /// Returns `true` if this is bounded endpoint.
  @nonVirtual
  bool get isBounded => endpoint != null;

  /// Returns `true`, if this is an unbounded endpoint.
  @nonVirtual
  bool get isUnbounded => endpoint == null;

  /// Returns the endpoint, or `null`.
  T? get endpoint => null;
}
