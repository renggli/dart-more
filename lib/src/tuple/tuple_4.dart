import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 4 elements.
class Tuple4<T1, T2, T3, T4> extends Tuple {
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
  final T1 first;

  /// Returns the second element of this tuple.
  final T2 second;

  /// Returns the third element of this tuple.
  final T3 third;

  /// Returns the fourth element of this tuple.
  final T4 fourth;

  /// Returns the last element of this tuple.
  T4 get last => fourth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple4<T, T2, T3, T4> withFirst<T>(T value) =>
      Tuple4(value, second, third, fourth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple4<T1, T, T3, T4> withSecond<T>(T value) =>
      Tuple4(first, value, third, fourth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple4<T1, T2, T, T4> withThird<T>(T value) =>
      Tuple4(first, second, value, fourth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple4<T1, T2, T3, T> withFourth<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple4<T1, T2, T3, T> withLast<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple5<T, T1, T2, T3, T4> addFirst<T>(T value) =>
      Tuple5(value, first, second, third, fourth);

  /// Returns a new tuple with [value] added at the second position.
  Tuple5<T1, T, T2, T3, T4> addSecond<T>(T value) =>
      Tuple5(first, value, second, third, fourth);

  /// Returns a new tuple with [value] added at the third position.
  Tuple5<T1, T2, T, T3, T4> addThird<T>(T value) =>
      Tuple5(first, second, value, third, fourth);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple5<T1, T2, T3, T, T4> addFourth<T>(T value) =>
      Tuple5(first, second, third, value, fourth);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple5<T1, T2, T3, T4, T> addFifth<T>(T value) =>
      Tuple5(first, second, third, fourth, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple5<T1, T2, T3, T4, T> addLast<T>(T value) =>
      Tuple5(first, second, third, fourth, value);

  /// Returns a new tuple with the first element removed.
  Tuple3<T2, T3, T4> removeFirst() => Tuple3(second, third, fourth);

  /// Returns a new tuple with the second element removed.
  Tuple3<T1, T3, T4> removeSecond() => Tuple3(first, third, fourth);

  /// Returns a new tuple with the third element removed.
  Tuple3<T1, T2, T4> removeThird() => Tuple3(first, second, fourth);

  /// Returns a new tuple with the fourth element removed.
  Tuple3<T1, T2, T3> removeFourth() => Tuple3(first, second, third);

  /// Returns a new tuple with the last element removed.
  Tuple3<T1, T2, T3> removeLast() => Tuple3(first, second, third);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
    yield fourth;
  }

  @override
  R map<R>(R Function(T1 first, T2 second, T3 third, T4 fourth) callback) =>
      callback(first, second, third, fourth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple4 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth);

  @override
  int get hashCode => hash4(first, second, third, fourth);
}
