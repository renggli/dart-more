import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 8 elements.
class Tuple8<T1, T2, T3, T4, T5, T6, T7, T8> extends Tuple {
  /// Const constructor.
  const Tuple8(this.first, this.second, this.third, this.fourth, this.fifth,
      this.sixth, this.seventh, this.eighth);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple8<T, T, T, T, T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 8) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 8, but got ${list.length}.');
    }
    return Tuple8(
        list[0], list[1], list[2], list[3], list[4], list[5], list[6], list[7]);
  }

  @override
  int get length => 8;

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

  /// Returns the seventh element of this tuple.
  final T7 seventh;

  /// Returns the eighth element of this tuple.
  final T8 eighth;

  /// Returns the last element of this tuple.
  T8 get last => eighth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple8<T, T2, T3, T4, T5, T6, T7, T8> withFirst<T>(T value) =>
      Tuple8(value, second, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple8<T1, T, T3, T4, T5, T6, T7, T8> withSecond<T>(T value) =>
      Tuple8(first, value, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple8<T1, T2, T, T4, T5, T6, T7, T8> withThird<T>(T value) =>
      Tuple8(first, second, value, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple8<T1, T2, T3, T, T5, T6, T7, T8> withFourth<T>(T value) =>
      Tuple8(first, second, third, value, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the fifth element replaced by [value].
  Tuple8<T1, T2, T3, T4, T, T6, T7, T8> withFifth<T>(T value) =>
      Tuple8(first, second, third, fourth, value, sixth, seventh, eighth);

  /// Returns a new tuple with the sixth element replaced by [value].
  Tuple8<T1, T2, T3, T4, T5, T, T7, T8> withSixth<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, value, seventh, eighth);

  /// Returns a new tuple with the seventh element replaced by [value].
  Tuple8<T1, T2, T3, T4, T5, T6, T, T8> withSeventh<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, sixth, value, eighth);

  /// Returns a new tuple with the eighth element replaced by [value].
  Tuple8<T1, T2, T3, T4, T5, T6, T7, T> withEighth<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple8<T1, T2, T3, T4, T5, T6, T7, T> withLast<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple9<T, T1, T2, T3, T4, T5, T6, T7, T8> addFirst<T>(T value) => Tuple9(
      value, first, second, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with [value] added at the second position.
  Tuple9<T1, T, T2, T3, T4, T5, T6, T7, T8> addSecond<T>(T value) => Tuple9(
      first, value, second, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with [value] added at the third position.
  Tuple9<T1, T2, T, T3, T4, T5, T6, T7, T8> addThird<T>(T value) => Tuple9(
      first, second, value, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple9<T1, T2, T3, T, T4, T5, T6, T7, T8> addFourth<T>(T value) => Tuple9(
      first, second, third, value, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple9<T1, T2, T3, T4, T, T5, T6, T7, T8> addFifth<T>(T value) => Tuple9(
      first, second, third, fourth, value, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with [value] added at the sixth position.
  Tuple9<T1, T2, T3, T4, T5, T, T6, T7, T8> addSixth<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, value, sixth, seventh, eighth);

  /// Returns a new tuple with [value] added at the seventh position.
  Tuple9<T1, T2, T3, T4, T5, T6, T, T7, T8> addSeventh<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, sixth, value, seventh, eighth);

  /// Returns a new tuple with [value] added at the eighth position.
  Tuple9<T1, T2, T3, T4, T5, T6, T7, T, T8> addEighth<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, sixth, seventh, value, eighth);

  /// Returns a new tuple with [value] added at the ninth position.
  Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T> addNinth<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, sixth, seventh, eighth, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T> addLast<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, sixth, seventh, eighth, value);

  /// Returns a new tuple with the first element removed.
  Tuple7<T2, T3, T4, T5, T6, T7, T8> removeFirst() =>
      Tuple7(second, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the second element removed.
  Tuple7<T1, T3, T4, T5, T6, T7, T8> removeSecond() =>
      Tuple7(first, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the third element removed.
  Tuple7<T1, T2, T4, T5, T6, T7, T8> removeThird() =>
      Tuple7(first, second, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the fourth element removed.
  Tuple7<T1, T2, T3, T5, T6, T7, T8> removeFourth() =>
      Tuple7(first, second, third, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the fifth element removed.
  Tuple7<T1, T2, T3, T4, T6, T7, T8> removeFifth() =>
      Tuple7(first, second, third, fourth, sixth, seventh, eighth);

  /// Returns a new tuple with the sixth element removed.
  Tuple7<T1, T2, T3, T4, T5, T7, T8> removeSixth() =>
      Tuple7(first, second, third, fourth, fifth, seventh, eighth);

  /// Returns a new tuple with the seventh element removed.
  Tuple7<T1, T2, T3, T4, T5, T6, T8> removeSeventh() =>
      Tuple7(first, second, third, fourth, fifth, sixth, eighth);

  /// Returns a new tuple with the eighth element removed.
  Tuple7<T1, T2, T3, T4, T5, T6, T7> removeEighth() =>
      Tuple7(first, second, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the last element removed.
  Tuple7<T1, T2, T3, T4, T5, T6, T7> removeLast() =>
      Tuple7(first, second, third, fourth, fifth, sixth, seventh);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
    yield fourth;
    yield fifth;
    yield sixth;
    yield seventh;
    yield eighth;
  }

  @override
  R map<R>(
          R Function(T1 first, T2 second, T3 third, T4 fourth, T5 fifth,
                  T6 sixth, T7 seventh, T8 eighth)
              callback) =>
      callback(first, second, third, fourth, fifth, sixth, seventh, eighth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple8 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth &&
          fifth == other.fifth &&
          sixth == other.sixth &&
          seventh == other.seventh &&
          eighth == other.eighth);

  @override
  int get hashCode =>
      hash8(first, second, third, fourth, fifth, sixth, seventh, eighth);
}
