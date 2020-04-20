library more.tuple.tuple_2;

import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 2 elements.
class Tuple2<T0, T1> extends Tuple {
  /// Const constructor.
  const Tuple2(this.first, this.second);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple2<T, T> fromList<T>(List<T> list) {
    if (list.length != 2) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 2, but got ${list.length}.');
    }
    return Tuple2(list[0], list[1]);
  }

  @override
  int get length => 2;

  /// Returns the first element of this tuple.
  final T0 first;

  /// Returns the second element of this tuple.
  final T1 second;

  /// Returns the last element of this tuple.
  T1 get last => second;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple2<T, T1> withFirst<T>(T value) => Tuple2(value, second);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple2<T0, T> withSecond<T>(T value) => Tuple2(first, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple2<T0, T> withLast<T>(T value) => Tuple2(first, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple3<T, T0, T1> addFirst<T>(T value) => Tuple3(value, first, second);

  /// Returns a new tuple with [value] added at the second position.
  Tuple3<T0, T, T1> addSecond<T>(T value) => Tuple3(first, value, second);

  /// Returns a new tuple with [value] added at the third position.
  Tuple3<T0, T1, T> addThird<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple3<T0, T1, T> addLast<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with the first element removed.
  Tuple1<T1> removeFirst() => Tuple1(second);

  /// Returns a new tuple with the second element removed.
  Tuple1<T0> removeSecond() => Tuple1(first);

  /// Returns a new tuple with the last element removed.
  Tuple1<T0> removeLast() => Tuple1(first);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple2 && first == other.first && second == other.second);

  @override
  int get hashCode => hash2(first, second);
}
