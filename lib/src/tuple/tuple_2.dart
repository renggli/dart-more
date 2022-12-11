import 'tuple.dart';
import 'tuple_1.dart';
import 'tuple_3.dart';

/// Tuple with 2 elements.
class Tuple2<T1, T2> extends Tuple {
  /// Const constructor.
  const Tuple2(this.first, this.second);

  /// List constructor.
  static Tuple2<T, T> fromList<T>(List<T> list) {
    if (list.length != 2) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 2, but got ${list.length}');
    }
    return Tuple2(list[0], list[1]);
  }

  @override
  int get length => 2;

  /// Returns the first element of this tuple.
  final T1 first;

  /// Returns the second element of this tuple.
  final T2 second;

  /// Returns the last element of this tuple.
  T2 get last => second;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple2<T, T2> withFirst<T>(T value) => Tuple2(value, second);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple2<T1, T> withSecond<T>(T value) => Tuple2(first, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple2<T1, T> withLast<T>(T value) => Tuple2(first, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple3<T, T1, T2> addFirst<T>(T value) => Tuple3(value, first, second);

  /// Returns a new tuple with [value] added at the second position.
  Tuple3<T1, T, T2> addSecond<T>(T value) => Tuple3(first, value, second);

  /// Returns a new tuple with [value] added at the third position.
  Tuple3<T1, T2, T> addThird<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple3<T1, T2, T> addLast<T>(T value) => Tuple3(first, second, value);

  /// Returns a new tuple with the first element removed.
  Tuple1<T2> removeFirst() => Tuple1(second);

  /// Returns a new tuple with the second element removed.
  Tuple1<T1> removeSecond() => Tuple1(first);

  /// Returns a new tuple with the last element removed.
  Tuple1<T1> removeLast() => Tuple1(first);

  @override
  Iterable<Object?> get iterable sync* {
    yield first;
    yield second;
  }

  @override
  R map<R>(R Function(T1 first, T2 second) callback) => callback(first, second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple2 && first == other.first && second == other.second);

  @override
  int get hashCode => Object.hash(first, second);
}
