import 'tuple.dart';
import 'tuple_5.dart';
import 'tuple_7.dart';

/// Tuple with 6 elements.
class Tuple6<T1, T2, T3, T4, T5, T6> extends Tuple {
  /// Const constructor.
  const Tuple6(
      this.first, this.second, this.third, this.fourth, this.fifth, this.sixth);

  /// List constructor.
  static Tuple6<T, T, T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 6) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 6, but got ${list.length}');
    }
    return Tuple6(list[0], list[1], list[2], list[3], list[4], list[5]);
  }

  @override
  int get length => 6;

  /// Returns the first element of this tuple.
  final T1 first;

  /// Returns the second element of this tuple.
  final T2 second;

  /// Returns the third element of this tuple.
  final T3 third;

  /// Returns the fourth element of this tuple.
  final T4 fourth;

  /// Returns the fifth element of this tuple.
  final T5 fifth;

  /// Returns the sixth element of this tuple.
  final T6 sixth;

  /// Returns the last element of this tuple.
  T6 get last => sixth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple6<T, T2, T3, T4, T5, T6> withFirst<T>(T value) =>
      Tuple6(value, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple6<T1, T, T3, T4, T5, T6> withSecond<T>(T value) =>
      Tuple6(first, value, third, fourth, fifth, sixth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple6<T1, T2, T, T4, T5, T6> withThird<T>(T value) =>
      Tuple6(first, second, value, fourth, fifth, sixth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple6<T1, T2, T3, T, T5, T6> withFourth<T>(T value) =>
      Tuple6(first, second, third, value, fifth, sixth);

  /// Returns a new tuple with the fifth element replaced by [value].
  Tuple6<T1, T2, T3, T4, T, T6> withFifth<T>(T value) =>
      Tuple6(first, second, third, fourth, value, sixth);

  /// Returns a new tuple with the sixth element replaced by [value].
  Tuple6<T1, T2, T3, T4, T5, T> withSixth<T>(T value) =>
      Tuple6(first, second, third, fourth, fifth, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple6<T1, T2, T3, T4, T5, T> withLast<T>(T value) =>
      Tuple6(first, second, third, fourth, fifth, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple7<T, T1, T2, T3, T4, T5, T6> addFirst<T>(T value) =>
      Tuple7(value, first, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the second position.
  Tuple7<T1, T, T2, T3, T4, T5, T6> addSecond<T>(T value) =>
      Tuple7(first, value, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the third position.
  Tuple7<T1, T2, T, T3, T4, T5, T6> addThird<T>(T value) =>
      Tuple7(first, second, value, third, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple7<T1, T2, T3, T, T4, T5, T6> addFourth<T>(T value) =>
      Tuple7(first, second, third, value, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple7<T1, T2, T3, T4, T, T5, T6> addFifth<T>(T value) =>
      Tuple7(first, second, third, fourth, value, fifth, sixth);

  /// Returns a new tuple with [value] added at the sixth position.
  Tuple7<T1, T2, T3, T4, T5, T, T6> addSixth<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, value, sixth);

  /// Returns a new tuple with [value] added at the seventh position.
  Tuple7<T1, T2, T3, T4, T5, T6, T> addSeventh<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, sixth, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple7<T1, T2, T3, T4, T5, T6, T> addLast<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, sixth, value);

  /// Returns a new tuple with the first element removed.
  Tuple5<T2, T3, T4, T5, T6> removeFirst() =>
      Tuple5(second, third, fourth, fifth, sixth);

  /// Returns a new tuple with the second element removed.
  Tuple5<T1, T3, T4, T5, T6> removeSecond() =>
      Tuple5(first, third, fourth, fifth, sixth);

  /// Returns a new tuple with the third element removed.
  Tuple5<T1, T2, T4, T5, T6> removeThird() =>
      Tuple5(first, second, fourth, fifth, sixth);

  /// Returns a new tuple with the fourth element removed.
  Tuple5<T1, T2, T3, T5, T6> removeFourth() =>
      Tuple5(first, second, third, fifth, sixth);

  /// Returns a new tuple with the fifth element removed.
  Tuple5<T1, T2, T3, T4, T6> removeFifth() =>
      Tuple5(first, second, third, fourth, sixth);

  /// Returns a new tuple with the sixth element removed.
  Tuple5<T1, T2, T3, T4, T5> removeSixth() =>
      Tuple5(first, second, third, fourth, fifth);

  /// Returns a new tuple with the last element removed.
  Tuple5<T1, T2, T3, T4, T5> removeLast() =>
      Tuple5(first, second, third, fourth, fifth);

  @override
  Iterable<Object?> get iterable sync* {
    yield first;
    yield second;
    yield third;
    yield fourth;
    yield fifth;
    yield sixth;
  }

  @override
  R map<R>(
          R Function(
                  T1 first, T2 second, T3 third, T4 fourth, T5 fifth, T6 sixth)
              callback) =>
      callback(first, second, third, fourth, fifth, sixth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple6 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth &&
          fifth == other.fifth &&
          sixth == other.sixth);

  @override
  int get hashCode => Object.hash(first, second, third, fourth, fifth, sixth);
}
