import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 3 elements.
class Tuple3<T0, T1, T2> extends Tuple {
  /// Const constructor.
  const Tuple3(this.first, this.second, this.third);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
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
  final T0 first;

  /// Returns the second element of this tuple.
  final T1 second;

  /// Returns the third element of this tuple.
  final T2 third;

  /// Returns the last element of this tuple.
  T2 get last => third;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple3<T, T1, T2> withFirst<T>(T value) => Tuple3(value, second, third);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple3<T0, T, T2> withSecond<T>(T value) => Tuple3(first, value, third);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple3<T0, T1, T> withThird<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple3<T0, T1, T> withLast<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple4<T, T0, T1, T2> addFirst<T>(T value) =>
      Tuple4(value, first, second, third);

  /// Returns a new tuple with [value] added at the second position.
  Tuple4<T0, T, T1, T2> addSecond<T>(T value) =>
      Tuple4(first, value, second, third);

  /// Returns a new tuple with [value] added at the third position.
  Tuple4<T0, T1, T, T2> addThird<T>(T value) =>
      Tuple4(first, second, value, third);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple4<T0, T1, T2, T> addFourth<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple4<T0, T1, T2, T> addLast<T>(T value) =>
      Tuple4(first, second, third, value);

  /// Returns a new tuple with the first element removed.
  Tuple2<T1, T2> removeFirst() => Tuple2(second, third);

  /// Returns a new tuple with the second element removed.
  Tuple2<T0, T2> removeSecond() => Tuple2(first, third);

  /// Returns a new tuple with the third element removed.
  Tuple2<T0, T1> removeThird() => Tuple2(first, second);

  /// Returns a new tuple with the last element removed.
  Tuple2<T0, T1> removeLast() => Tuple2(first, second);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
  }

  @override
  R map<R>(R Function(T0 first, T1 second, T2 third) callback) =>
      callback(first, second, third);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple3 &&
          first == other.first &&
          second == other.second &&
          third == other.third);

  @override
  int get hashCode => hash3(first, second, third);
}
