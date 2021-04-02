import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 9 elements.
class Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T9> extends Tuple {
  /// Const constructor.
  const Tuple9(this.first, this.second, this.third, this.fourth, this.fifth,
      this.sixth, this.seventh, this.eighth, this.ninth);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple9<T, T, T, T, T, T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 9) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 9, but got ${list.length}.');
    }
    return Tuple9(list[0], list[1], list[2], list[3], list[4], list[5], list[6],
        list[7], list[8]);
  }

  @override
  int get length => 9;

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

  /// Returns the ninth element of this tuple.
  final T9 ninth;

  /// Returns the last element of this tuple.
  T9 get last => ninth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple9<T, T2, T3, T4, T5, T6, T7, T8, T9> withFirst<T>(T value) => Tuple9(
      value, second, third, fourth, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple9<T1, T, T3, T4, T5, T6, T7, T8, T9> withSecond<T>(T value) =>
      Tuple9(first, value, third, fourth, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple9<T1, T2, T, T4, T5, T6, T7, T8, T9> withThird<T>(T value) => Tuple9(
      first, second, value, fourth, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple9<T1, T2, T3, T, T5, T6, T7, T8, T9> withFourth<T>(T value) =>
      Tuple9(first, second, third, value, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the fifth element replaced by [value].
  Tuple9<T1, T2, T3, T4, T, T6, T7, T8, T9> withFifth<T>(T value) => Tuple9(
      first, second, third, fourth, value, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the sixth element replaced by [value].
  Tuple9<T1, T2, T3, T4, T5, T, T7, T8, T9> withSixth<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, value, seventh, eighth, ninth);

  /// Returns a new tuple with the seventh element replaced by [value].
  Tuple9<T1, T2, T3, T4, T5, T6, T, T8, T9> withSeventh<T>(T value) =>
      Tuple9(first, second, third, fourth, fifth, sixth, value, eighth, ninth);

  /// Returns a new tuple with the eighth element replaced by [value].
  Tuple9<T1, T2, T3, T4, T5, T6, T7, T, T9> withEighth<T>(T value) =>
      Tuple9(first, second, third, fourth, fifth, sixth, seventh, value, ninth);

  /// Returns a new tuple with the ninth element replaced by [value].
  Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T> withNinth<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, sixth, seventh, eighth, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T> withLast<T>(T value) => Tuple9(
      first, second, third, fourth, fifth, sixth, seventh, eighth, value);

  /// Returns a new tuple with the first element removed.
  Tuple8<T2, T3, T4, T5, T6, T7, T8, T9> removeFirst() =>
      Tuple8(second, third, fourth, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the second element removed.
  Tuple8<T1, T3, T4, T5, T6, T7, T8, T9> removeSecond() =>
      Tuple8(first, third, fourth, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the third element removed.
  Tuple8<T1, T2, T4, T5, T6, T7, T8, T9> removeThird() =>
      Tuple8(first, second, fourth, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the fourth element removed.
  Tuple8<T1, T2, T3, T5, T6, T7, T8, T9> removeFourth() =>
      Tuple8(first, second, third, fifth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the fifth element removed.
  Tuple8<T1, T2, T3, T4, T6, T7, T8, T9> removeFifth() =>
      Tuple8(first, second, third, fourth, sixth, seventh, eighth, ninth);

  /// Returns a new tuple with the sixth element removed.
  Tuple8<T1, T2, T3, T4, T5, T7, T8, T9> removeSixth() =>
      Tuple8(first, second, third, fourth, fifth, seventh, eighth, ninth);

  /// Returns a new tuple with the seventh element removed.
  Tuple8<T1, T2, T3, T4, T5, T6, T8, T9> removeSeventh() =>
      Tuple8(first, second, third, fourth, fifth, sixth, eighth, ninth);

  /// Returns a new tuple with the eighth element removed.
  Tuple8<T1, T2, T3, T4, T5, T6, T7, T9> removeEighth() =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, ninth);

  /// Returns a new tuple with the ninth element removed.
  Tuple8<T1, T2, T3, T4, T5, T6, T7, T8> removeNinth() =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, eighth);

  /// Returns a new tuple with the last element removed.
  Tuple8<T1, T2, T3, T4, T5, T6, T7, T8> removeLast() =>
      Tuple8(first, second, third, fourth, fifth, sixth, seventh, eighth);

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
    yield ninth;
  }

  @override
  R map<R>(
          R Function(T1 first, T2 second, T3 third, T4 fourth, T5 fifth,
                  T6 sixth, T7 seventh, T8 eighth, T9 ninth)
              callback) =>
      callback(
          first, second, third, fourth, fifth, sixth, seventh, eighth, ninth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple9 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth &&
          fifth == other.fifth &&
          sixth == other.sixth &&
          seventh == other.seventh &&
          eighth == other.eighth &&
          ninth == other.ninth);

  @override
  int get hashCode =>
      hash9(first, second, third, fourth, fifth, sixth, seventh, eighth, ninth);
}
