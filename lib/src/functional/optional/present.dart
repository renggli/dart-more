import 'package:meta/meta.dart';

import '../optional.dart';
import '../types/callback.dart';
import '../types/mapping.dart';
import '../types/predicate.dart';
import 'absent.dart';

@sealed
class PresentOptional<T> extends Optional<T> {
  const PresentOptional(this.value);

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
      function(value) ? this : AbsentOptional<T>();

  @override
  Optional<R> whereType<R>() =>
      value is R ? PresentOptional<R>(value as R) : AbsentOptional<R>();

  @override
  Optional<R> map<R>(Map1<T, R> function) =>
      PresentOptional<R>(function(value));

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
