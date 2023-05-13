/// A container that may or may not contain a value.
import 'package:meta/meta.dart';

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
sealed class Optional<T> {
  /// Internal const constructor.
  const Optional._();

  /// Returns a present [Optional] of the given [value].
  const factory Optional.of(T value) = PresentOptional<T>._;

  /// Returns an absent [Optional] instance.
  const factory Optional.absent() = AbsentOptional<T>._;

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

/// Implementation of an [Optional] with a value.
class PresentOptional<T> extends Optional<T> {
  const PresentOptional._(this.value) : super._();

  @override
  final T value;

  @override
  Iterable<T> get iterable => <T>[value];

  @override
  bool get isPresent => true;

  @override
  void ifPresent(Callback1<T> function) => function(value);

  @override
  bool get isAbsent => false;

  @override
  void ifAbsent(Callback0 function) {}

  @override
  Optional<T> where(Predicate1<T> function) =>
      function(value) ? this : Optional<T>.absent();

  @override
  Optional<R> whereType<R>() =>
      value is R ? Optional<R>.of(value as R) : Optional<R>.absent();

  @override
  Optional<R> map<R>(Map1<T, R> function) => Optional<R>.of(function(value));

  @override
  Optional<R> flatMap<R>(Map1<T, Optional<R>> function) => function(value);

  @override
  Optional<T> or(Map0<Optional<T>> function) => this;

  @override
  T orElse(T value) => this.value;

  @override
  T orElseGet(Map0<T> function) => value;

  @override
  T orElseThrow([Object? error]) => value;

  @override
  bool operator ==(Object other) =>
      other is PresentOptional<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '${super.toString()}[$value]';
}

/// Implementation of an [Optional] without a value.
class AbsentOptional<T> extends Optional<T> {
  const AbsentOptional._() : super._();

  @override
  T get value => throw noSuchElementError;

  @override
  Iterable<T> get iterable => const [];

  @override
  bool get isPresent => false;

  @override
  void ifPresent(Callback1<T> function) {}

  @override
  bool get isAbsent => true;

  @override
  void ifAbsent(Callback0 function) => function();

  @override
  Optional<T> where(Predicate1<T> function) => this;

  @override
  Optional<R> whereType<R>() => Optional<R>.absent();

  @override
  Optional<R> map<R>(Map1<T, R> function) => Optional<R>.absent();

  @override
  Optional<R> flatMap<R>(Map1<T, Optional<R>> function) => Optional<R>.absent();

  @override
  Optional<T> or(Map0<Optional<T>> function) => function();

  @override
  T orElse(T value) => value;

  @override
  T orElseGet(Map0<T> function) => function();

  @override
  T orElseThrow([Object? error]) => throw error ?? noSuchElementError;

  @override
  bool operator ==(Object other) => other is AbsentOptional<T>;

  @override
  int get hashCode => T.hashCode;
}

final noSuchElementError = StateError('No such element');
