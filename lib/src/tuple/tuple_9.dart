library more.tuple.tuple_9;

import 'package:more/tuple.dart';

/// Tuple with 9 elements.
class Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;
  final T3 value3;
  final T4 value4;
  final T5 value5;
  final T6 value6;
  final T7 value7;
  final T8 value8;

  const Tuple9(this.value0, this.value1, this.value2, this.value3, this.value4,
      this.value5, this.value6, this.value7, this.value8);

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

  Tuple9<T, T1, T2, T3, T4, T5, T6, T7, T8> with0<T>(T value) => Tuple9(
      value, value1, value2, value3, value4, value5, value6, value7, value8);

  Tuple9<T0, T, T2, T3, T4, T5, T6, T7, T8> with1<T>(T value) => Tuple9(
      value0, value, value2, value3, value4, value5, value6, value7, value8);

  Tuple9<T0, T1, T, T3, T4, T5, T6, T7, T8> with2<T>(T value) => Tuple9(
      value0, value1, value, value3, value4, value5, value6, value7, value8);

  Tuple9<T0, T1, T2, T, T4, T5, T6, T7, T8> with3<T>(T value) => Tuple9(
      value0, value1, value2, value, value4, value5, value6, value7, value8);

  Tuple9<T0, T1, T2, T3, T, T5, T6, T7, T8> with4<T>(T value) => Tuple9(
      value0, value1, value2, value3, value, value5, value6, value7, value8);

  Tuple9<T0, T1, T2, T3, T4, T, T6, T7, T8> with5<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value, value6, value7, value8);

  Tuple9<T0, T1, T2, T3, T4, T5, T, T7, T8> with6<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value5, value, value7, value8);

  Tuple9<T0, T1, T2, T3, T4, T5, T6, T, T8> with7<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value5, value6, value, value8);

  Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T> with8<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value5, value6, value7, value);

  @override
  Tuple addFirst<T>(T value) => throw StateError('Too many');

  @override
  Tuple addLast<T>(T value) => throw StateError('Too many');

  @override
  Tuple8<T1, T2, T3, T4, T5, T6, T7, T8> removeFirst() => removeAt0();

  @override
  Tuple8<T0, T1, T2, T3, T4, T5, T6, T7> removeLast() => removeAt8();

  Tuple8<T1, T2, T3, T4, T5, T6, T7, T8> removeAt0() =>
      Tuple8(value1, value2, value3, value4, value5, value6, value7, value8);

  Tuple8<T0, T2, T3, T4, T5, T6, T7, T8> removeAt1() =>
      Tuple8(value0, value2, value3, value4, value5, value6, value7, value8);

  Tuple8<T0, T1, T3, T4, T5, T6, T7, T8> removeAt2() =>
      Tuple8(value0, value1, value3, value4, value5, value6, value7, value8);

  Tuple8<T0, T1, T2, T4, T5, T6, T7, T8> removeAt3() =>
      Tuple8(value0, value1, value2, value4, value5, value6, value7, value8);

  Tuple8<T0, T1, T2, T3, T5, T6, T7, T8> removeAt4() =>
      Tuple8(value0, value1, value2, value3, value5, value6, value7, value8);

  Tuple8<T0, T1, T2, T3, T4, T6, T7, T8> removeAt5() =>
      Tuple8(value0, value1, value2, value3, value4, value6, value7, value8);

  Tuple8<T0, T1, T2, T3, T4, T5, T7, T8> removeAt6() =>
      Tuple8(value0, value1, value2, value3, value4, value5, value7, value8);

  Tuple8<T0, T1, T2, T3, T4, T5, T6, T8> removeAt7() =>
      Tuple8(value0, value1, value2, value3, value4, value5, value6, value8);

  Tuple8<T0, T1, T2, T3, T4, T5, T6, T7> removeAt8() =>
      Tuple8(value0, value1, value2, value3, value4, value5, value6, value7);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
    yield value2;
    yield value3;
    yield value4;
    yield value5;
    yield value6;
    yield value7;
    yield value8;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple9 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3 &&
          value4 == other.value4 &&
          value5 == other.value5 &&
          value6 == other.value6 &&
          value7 == other.value7 &&
          value8 == other.value8);

  @override
  int get hashCode =>
      3590394808 ^
      value0.hashCode ^
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode ^
      value4.hashCode ^
      value5.hashCode ^
      value6.hashCode ^
      value7.hashCode ^
      value8.hashCode;
}
