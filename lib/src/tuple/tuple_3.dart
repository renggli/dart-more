import 'tuple.dart';
import 'tuple_2.dart';
import 'tuple_4.dart';

/// Tuple with 3 elements.
class Tuple3<T1, T2, T3> extends Tuple {
  /// Const constructor.
  const Tuple3(this.first, this.second, this.third);

  /// List constructor.
  static Tuple3<T, T, T> fromList<T>(List<T> list) {
    if (list.length != 3) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 3, but got ${list.length}.');
    }
    return Tuple3(list[0], list[1], list[2]);
  }

  @override
  int get length => 3;

  /// Returns the first element of this tuple.
  final T1 first;

  /// Returns the second element of this tuple.
  final T2 second;

  /// Returns the third element of this tuple.
  final T3 third;

  /// Returns the last element of this tuple.
  T3 get last => third;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple3<T, T2, T3> withFirst<T>(T value) => Tuple3(value, second, third);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple3<T1, T, T3> withSecond<T>(T value) => Tuple3(first, value, third);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple3<T1, T2, T> withThird<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple3<T1, T2, T> withLast<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple4<T, T1, T2, T3> addFirst<T>(T value) =>
      Tuple4(value, first, second, third);

  /// Returns a new tuple with [value] added at the second position.
  Tuple4<T1, T, T2, T3> addSecond<T>(T value) =>
      Tuple4(first, value, second, third);

  /// Returns a new tuple with [value] added at the third position.
  Tuple4<T1, T2, T, T3> addThird<T>(T value) =>
      Tuple4(first, second, value, third);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple4<T1, T2, T3, T> addFourth<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple4<T1, T2, T3, T> addLast<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with the first element removed.
  Tuple2<T2, T3> removeFirst() => Tuple2(second, third);

  /// Returns a new tuple with the second element removed.
  Tuple2<T1, T3> removeSecond() => Tuple2(first, third);

  /// Returns a new tuple with the third element removed.
  Tuple2<T1, T2> removeThird() => Tuple2(first, second);

  /// Returns a new tuple with the last element removed.
  Tuple2<T1, T2> removeLast() => Tuple2(first, second);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
  }

  @override
  R map<R>(R Function(T1 first, T2 second, T3 third) callback) =>
      callback(first, second, third);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple3 &&
          first == other.first &&
          second == other.second &&
          third == other.third);

  @override
  int get hashCode => Object.hash(first, second, third);
}
