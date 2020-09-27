import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 6 elements.
class Tuple6<T0, T1, T2, T3, T4, T5> extends Tuple {
  /// Const constructor.
  const Tuple6(
      this.first, this.second, this.third, this.fourth, this.fifth, this.sixth);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple6<T, T, T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 6) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 6, but got ${list.length}.');
    }
    return Tuple6(list[0], list[1], list[2], list[3], list[4], list[5]);
  }

  @override
  int get length => 6;

  /// Returns the first element of this tuple.
  final T0 first;

  /// Returns the second element of this tuple.
  final T1 second;

  /// Returns the third element of this tuple.
  final T2 third;

  /// Returns the fourth element of this tuple.
  final T3 fourth;

  /// Returns the fifth element of this tuple.
  final T4 fifth;

  /// Returns the sixth element of this tuple.
  final T5 sixth;

  /// Returns the last element of this tuple.
  T5 get last => sixth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple6<T, T1, T2, T3, T4, T5> withFirst<T>(T value) =>
      Tuple6(value, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple6<T0, T, T2, T3, T4, T5> withSecond<T>(T value) =>
      Tuple6(first, value, third, fourth, fifth, sixth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple6<T0, T1, T, T3, T4, T5> withThird<T>(T value) =>
      Tuple6(first, second, value, fourth, fifth, sixth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple6<T0, T1, T2, T, T4, T5> withFourth<T>(T value) =>
      Tuple6(first, second, third, value, fifth, sixth);

  /// Returns a new tuple with the fifth element replaced by [value].
  Tuple6<T0, T1, T2, T3, T, T5> withFifth<T>(T value) =>
      Tuple6(first, second, third, fourth, value, sixth);

  /// Returns a new tuple with the sixth element replaced by [value].
  Tuple6<T0, T1, T2, T3, T4, T> withSixth<T>(T value) =>
      Tuple6(first, second, third, fourth, fifth, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple6<T0, T1, T2, T3, T4, T> withLast<T>(T value) =>
      Tuple6(first, second, third, fourth, fifth, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple7<T, T0, T1, T2, T3, T4, T5> addFirst<T>(T value) =>
      Tuple7(value, first, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the second position.
  Tuple7<T0, T, T1, T2, T3, T4, T5> addSecond<T>(T value) =>
      Tuple7(first, value, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the third position.
  Tuple7<T0, T1, T, T2, T3, T4, T5> addThird<T>(T value) =>
      Tuple7(first, second, value, third, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple7<T0, T1, T2, T, T3, T4, T5> addFourth<T>(T value) =>
      Tuple7(first, second, third, value, fourth, fifth, sixth);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple7<T0, T1, T2, T3, T, T4, T5> addFifth<T>(T value) =>
      Tuple7(first, second, third, fourth, value, fifth, sixth);

  /// Returns a new tuple with [value] added at the sixth position.
  Tuple7<T0, T1, T2, T3, T4, T, T5> addSixth<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, value, sixth);

  /// Returns a new tuple with [value] added at the seventh position.
  Tuple7<T0, T1, T2, T3, T4, T5, T> addSeventh<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, sixth, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple7<T0, T1, T2, T3, T4, T5, T> addLast<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, sixth, value);

  /// Returns a new tuple with the first element removed.
  Tuple5<T1, T2, T3, T4, T5> removeFirst() =>
      Tuple5(second, third, fourth, fifth, sixth);

  /// Returns a new tuple with the second element removed.
  Tuple5<T0, T2, T3, T4, T5> removeSecond() =>
      Tuple5(first, third, fourth, fifth, sixth);

  /// Returns a new tuple with the third element removed.
  Tuple5<T0, T1, T3, T4, T5> removeThird() =>
      Tuple5(first, second, fourth, fifth, sixth);

  /// Returns a new tuple with the fourth element removed.
  Tuple5<T0, T1, T2, T4, T5> removeFourth() =>
      Tuple5(first, second, third, fifth, sixth);

  /// Returns a new tuple with the fifth element removed.
  Tuple5<T0, T1, T2, T3, T5> removeFifth() =>
      Tuple5(first, second, third, fourth, sixth);

  /// Returns a new tuple with the sixth element removed.
  Tuple5<T0, T1, T2, T3, T4> removeSixth() =>
      Tuple5(first, second, third, fourth, fifth);

  /// Returns a new tuple with the last element removed.
  Tuple5<T0, T1, T2, T3, T4> removeLast() =>
      Tuple5(first, second, third, fourth, fifth);

  @override
  Iterable get iterable sync* {
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
                  T0 first, T1 second, T2 third, T3 fourth, T4 fifth, T5 sixth)
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
  int get hashCode => hash6(first, second, third, fourth, fifth, sixth);
}
