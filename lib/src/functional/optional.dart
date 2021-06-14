/// A container that may or may not contain a value.
import 'package:meta/meta.dart';

import 'optional/absent.dart';
import 'optional/present.dart';
import 'types/callback.dart';
import 'types/mapping.dart';
import 'types/predicate.dart';

/// A container object which may or may not contain a value of type [T].
///
/// Note that depending on the nullability of type [T], a `null` value can be
/// a perfectly valid present value.
///
/// Also see https://en.wikipedia.org/wiki/Option_type.
@immutable
@sealed
abstract class Optional<T> {
  /// Internal const constructor.
  @internal
  const Optional();

  /// Returns a present [Optional] of the given [value].
  const factory Optional.of(T value) = PresentOptional<T>;

  /// Returns an absent [Optional] instance.
  const factory Optional.absent() = AbsentOptional<T>;

  /// Returns a present [Optional] of the given [value] if the value is
  /// non-null, otherwise an absent [Optional] instance.
  factory Optional.ofNullable(T? value) =>
      value != null ? Optional<T>.of(value) : Optional<T>.absent();

  /// Returns the present value, otherwise throws a [StateError].
  T get value;

  /// Returns an [Iterable] with the single present value, otherwise an empty
  /// iterable.
  Iterable<T> get iterable;

  /// Returns whether the value is present.
  bool get isPresent;

  /// Evaluates the callback [function] with the present value, otherwise
  /// does nothing.
  void ifPresent(Callback1<T> function);

  /// Returns whether the value is absent.
  bool get isAbsent;

  /// Evaluates the callback [function] if the value is absent, otherwise does
  /// nothing.
  void ifAbsent(Callback0 function);

  /// Returns this [Optional] if the provided predicate [function] evaluates
  /// to `true`, otherwise returns an absent [Optional].
  Optional<T> where(Predicate1<T> function);

  /// Casts the present value of this [Optional] to [R], otherwise returns an
  /// absent [Optional].
  Optional<R> whereType<R>();

  /// Transforms the present value of this [Optional] with the provided
  /// mapping [function], otherwise returns an absent [Optional].
  Optional<R> map<R>(Map1<T, R> function);

  /// Transforms the present value of this [Optional] with the provided
  /// mapping [function], otherwise returns an absent [Optional].
  Optional<R> flatMap<R>(Map1<T, Optional<R>> function);

  /// Returns the current optional if present, otherwise evaluates the
  /// [function] callback and returns its optional.
  Optional<T> or(Map0<Optional<T>> function);

  /// Returns the current value if present, otherwise the argument [value].
  T orElse(T value);

  /// Returns the current value if present, otherwise evaluates the callback
  /// [function] and returns its value.
  T orElseGet(Map0<T> function);

  /// Returns the current value if present, otherwise throws the provided
  /// [error] or a [StateError].
  T orElseThrow([Object? error]);
}
