import 'package:meta/meta.dart';

import '../optional.dart';
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
  void ifPresent(void Function(T value) function) => function(value);

  @override
  bool get isAbsent => false;

  @override
  void ifAbsent(void Function() function) {}

  @override
  Optional<T> where(bool Function(T value) function) =>
      function(value) ? this : AbsentOptional<T>();

  @override
  Optional<R> whereType<R>() =>
      value is R ? PresentOptional<R>(value as R) : AbsentOptional<R>();

  @override
  Optional<R> map<R>(R Function(T value) function) =>
      PresentOptional<R>(function(value));

  @override
  Optional<R> flatMap<R>(Optional<R> Function(T value) function) =>
      function(value);

  @override
  Optional<T> or(Optional<T> Function() function) => this;

  @override
  T orElse(T value) => this.value;

  @override
  T orElseGet(T Function() function) => value;

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
