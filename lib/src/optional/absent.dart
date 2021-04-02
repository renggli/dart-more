import 'package:meta/meta.dart';

import '../../optional.dart';

@sealed
class AbsentOptional<T> extends Optional<T> {
  const AbsentOptional();

  @override
  T get value => throw noSuchElementError;

  @override
  Iterable<T> get iterable => const [];

  @override
  bool get isPresent => false;

  @override
  void ifPresent(void Function(T value) function) {}

  @override
  bool get isAbsent => true;

  @override
  void ifAbsent(void Function() function) => function();

  @override
  Optional<T> where(bool Function(T value) function) => this;

  @override
  Optional<R> whereType<R>() => AbsentOptional<R>();

  @override
  Optional<R> map<R>(R Function(T value) function) => AbsentOptional<R>();

  @override
  Optional<R> flatMap<R>(Optional<R> Function(T value) function) =>
      AbsentOptional<R>();

  @override
  Optional<T> or(Optional<T> Function() function) => function();

  @override
  T orElse(T value) => value;

  @override
  T orElseGet(T Function() function) => function();

  @override
  // ignore: only_throw_errors
  T orElseThrow([Object? error]) => throw error ?? noSuchElementError;

  @override
  bool operator ==(Object other) => other is AbsentOptional<T>;

  @override
  int get hashCode => T.hashCode;
}

final noSuchElementError = StateError('No such element');
