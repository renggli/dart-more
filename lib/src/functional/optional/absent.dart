import 'package:meta/meta.dart';

import '../optional.dart';
import '../types/callback.dart';
import '../types/mapping.dart';
import '../types/predicate.dart';

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
  void ifPresent(Callback1<T> function) {}

  @override
  bool get isAbsent => true;

  @override
  void ifAbsent(Callback0 function) => function();

  @override
  Optional<T> where(Predicate1<T> function) => this;

  @override
  Optional<R> whereType<R>() => AbsentOptional<R>();

  @override
  Optional<R> map<R>(Map1<T, R> function) => AbsentOptional<R>();

  @override
  Optional<R> flatMap<R>(Map1<T, Optional<R>> function) => AbsentOptional<R>();

  @override
  Optional<T> or(Map0<Optional<T>> function) => function();

  @override
  T orElse(T value) => value;

  @override
  T orElseGet(Map0<T> function) => function();

  @override
  // ignore: only_throw_errors
  T orElseThrow([Object? error]) => throw error ?? noSuchElementError;

  @override
  bool operator ==(Object other) => other is AbsentOptional<T>;

  @override
  int get hashCode => T.hashCode;
}

final noSuchElementError = StateError('No such element');
