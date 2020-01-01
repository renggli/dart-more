library more.tuple.tuple_4;

import '../../tuple.dart';

/// Tuple with 4 elements.
class Tuple4<T0, T1, T2, T3> extends Tuple {
  /// Const constructor.
  const Tuple4(this.first, this.second, this.third, this.fourth);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple4<T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 4) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 4, but got ${list.length}.');
    }
    return Tuple4(list[0], list[1], list[2], list[3]);
  }

  @override
  int get length => 4;

  /// Returns the first element of this tuple.
  final T0 first;

  /// Returns the second element of this tuple.
  final T1 second;

  /// Returns the third element of this tuple.
  final T2 third;

  /// Returns the fourth element of this tuple.
  final T3 fourth;

  /// Returns the last element of this tuple.
  T3 get last => fourth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple4<T, T1, T2, T3> withFirst<T>(T value) =>
      Tuple4(value, second, third, fourth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple4<T0, T, T2, T3> withSecond<T>(T value) =>
      Tuple4(first, value, third, fourth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple4<T0, T1, T, T3> withThird<T>(T value) =>
      Tuple4(first, second, value, fourth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple4<T0, T1, T2, T> withFourth<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple4<T0, T1, T2, T> withLast<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple5<T, T0, T1, T2, T3> addFirst<T>(T value) =>
      Tuple5(value, first, second, third, fourth);

  /// Returns a new tuple with [value] added at the second position.
  Tuple5<T0, T, T1, T2, T3> addSecond<T>(T value) =>
      Tuple5(first, value, second, third, fourth);

  /// Returns a new tuple with [value] added at the third position.
  Tuple5<T0, T1, T, T2, T3> addThird<T>(T value) =>
      Tuple5(first, second, value, third, fourth);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple5<T0, T1, T2, T, T3> addFourth<T>(T value) =>
      Tuple5(first, second, third, value, fourth);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple5<T0, T1, T2, T3, T> addFifth<T>(T value) =>
      Tuple5(first, second, third, fourth, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple5<T0, T1, T2, T3, T> addLast<T>(T value) =>
      Tuple5(first, second, third, fourth, value);

  /// Returns a new tuple with the first element removed.
  Tuple3<T1, T2, T3> removeFirst() => Tuple3(second, third, fourth);

  /// Returns a new tuple with the second element removed.
  Tuple3<T0, T2, T3> removeSecond() => Tuple3(first, third, fourth);

  /// Returns a new tuple with the third element removed.
  Tuple3<T0, T1, T3> removeThird() => Tuple3(first, second, fourth);

  /// Returns a new tuple with the fourth element removed.
  Tuple3<T0, T1, T2> removeFourth() => Tuple3(first, second, third);

  /// Returns a new tuple with the last element removed.
  Tuple3<T0, T1, T2> removeLast() => Tuple3(first, second, third);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
    yield fourth;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple4 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth);

  @override
  int get hashCode =>
      1319473077 ^
      first.hashCode ^
      second.hashCode ^
      third.hashCode ^
      fourth.hashCode;
}
