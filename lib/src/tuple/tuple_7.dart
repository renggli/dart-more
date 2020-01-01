library more.tuple.tuple_7;

import '../../tuple.dart';

/// Tuple with 7 elements.
class Tuple7<T0, T1, T2, T3, T4, T5, T6> extends Tuple {
  /// Const constructor.
  const Tuple7(this.first, this.second, this.third, this.fourth, this.fifth,
      this.sixth, this.seventh);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple7<T, T, T, T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 7) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 7, but got ${list.length}.');
    }
    return Tuple7(
        list[0], list[1], list[2], list[3], list[4], list[5], list[6]);
  }

  @override
  int get length => 7;

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

  /// Returns the seventh element of this tuple.
  final T6 seventh;

  /// Returns the last element of this tuple.
  T6 get last => seventh;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple7<T, T1, T2, T3, T4, T5, T6> withFirst<T>(T value) =>
      Tuple7(value, second, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple7<T0, T, T2, T3, T4, T5, T6> withSecond<T>(T value) =>
      Tuple7(first, value, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple7<T0, T1, T, T3, T4, T5, T6> withThird<T>(T value) =>
      Tuple7(first, second, value, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple7<T0, T1, T2, T, T4, T5, T6> withFourth<T>(T value) =>
      Tuple7(first, second, third, value, fifth, sixth, seventh);

  /// Returns a new tuple with the fifth element replaced by [value].
  Tuple7<T0, T1, T2, T3, T, T5, T6> withFifth<T>(T value) =>
      Tuple7(first, second, third, fourth, value, sixth, seventh);

  /// Returns a new tuple with the sixth element replaced by [value].
  Tuple7<T0, T1, T2, T3, T4, T, T6> withSixth<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, value, seventh);

  /// Returns a new tuple with the seventh element replaced by [value].
  Tuple7<T0, T1, T2, T3, T4, T5, T> withSeventh<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, sixth, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple7<T0, T1, T2, T3, T4, T5, T> withLast<T>(T value) =>
      Tuple7(first, second, third, fourth, fifth, sixth, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple8<T, T0, T1, T2, T3, T4, T5, T6> addFirst<T>(T value) =>
      Tuple8(value, first, second, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with [value] added at the second position.
  Tuple8<T0, T, T1, T2, T3, T4, T5, T6> addSecond<T>(T value) =>
      Tuple8(first, value, second, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with [value] added at the third position.
  Tuple8<T0, T1, T, T2, T3, T4, T5, T6> addThird<T>(T value) =>
      Tuple8(first, second, value, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple8<T0, T1, T2, T, T3, T4, T5, T6> addFourth<T>(T value) =>
      Tuple8(first, second, third, value, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple8<T0, T1, T2, T3, T, T4, T5, T6> addFifth<T>(T value) =>
      Tuple8(first, second, third, fourth, value, fifth, sixth, seventh);

  /// Returns a new tuple with [value] added at the sixth position.
  Tuple8<T0, T1, T2, T3, T4, T, T5, T6> addSixth<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, value, sixth, seventh);

  /// Returns a new tuple with [value] added at the seventh position.
  Tuple8<T0, T1, T2, T3, T4, T5, T, T6> addSeventh<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, sixth, value, seventh);

  /// Returns a new tuple with [value] added at the eighth position.
  Tuple8<T0, T1, T2, T3, T4, T5, T6, T> addEighth<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple8<T0, T1, T2, T3, T4, T5, T6, T> addLast<T>(T value) =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, value);

  /// Returns a new tuple with the first element removed.
  Tuple6<T1, T2, T3, T4, T5, T6> removeFirst() =>
      Tuple6(second, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the second element removed.
  Tuple6<T0, T2, T3, T4, T5, T6> removeSecond() =>
      Tuple6(first, third, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the third element removed.
  Tuple6<T0, T1, T3, T4, T5, T6> removeThird() =>
      Tuple6(first, second, fourth, fifth, sixth, seventh);

  /// Returns a new tuple with the fourth element removed.
  Tuple6<T0, T1, T2, T4, T5, T6> removeFourth() =>
      Tuple6(first, second, third, fifth, sixth, seventh);

  /// Returns a new tuple with the fifth element removed.
  Tuple6<T0, T1, T2, T3, T5, T6> removeFifth() =>
      Tuple6(first, second, third, fourth, sixth, seventh);

  /// Returns a new tuple with the sixth element removed.
  Tuple6<T0, T1, T2, T3, T4, T6> removeSixth() =>
      Tuple6(first, second, third, fourth, fifth, seventh);

  /// Returns a new tuple with the seventh element removed.
  Tuple6<T0, T1, T2, T3, T4, T5> removeSeventh() =>
      Tuple6(first, second, third, fourth, fifth, sixth);

  /// Returns a new tuple with the last element removed.
  Tuple6<T0, T1, T2, T3, T4, T5> removeLast() =>
      Tuple6(first, second, third, fourth, fifth, sixth);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
    yield fourth;
    yield fifth;
    yield sixth;
    yield seventh;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple7 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth &&
          fifth == other.fifth &&
          sixth == other.sixth &&
          seventh == other.seventh);

  @override
  int get hashCode =>
      3505223485 ^
      first.hashCode ^
      second.hashCode ^
      third.hashCode ^
      fourth.hashCode ^
      fifth.hashCode ^
      sixth.hashCode ^
      seventh.hashCode;
}
