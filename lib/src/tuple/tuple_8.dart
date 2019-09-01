library more.tuple.tuple_8;

import 'package:more/tuple.dart';

/// Tuple with 8 elements.
class Tuple8<T0, T1, T2, T3, T4, T5, T6, T7> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;
  final T3 value3;
  final T4 value4;
  final T5 value5;
  final T6 value6;
  final T7 value7;

  const Tuple8(this.value0, this.value1, this.value2, this.value3, this.value4,
      this.value5, this.value6, this.value7);

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

  Tuple8<T, T1, T2, T3, T4, T5, T6, T7> with0<T>(T value) =>
      Tuple8(value, value1, value2, value3, value4, value5, value6, value7);

  Tuple8<T0, T, T2, T3, T4, T5, T6, T7> with1<T>(T value) =>
      Tuple8(value0, value, value2, value3, value4, value5, value6, value7);

  Tuple8<T0, T1, T, T3, T4, T5, T6, T7> with2<T>(T value) =>
      Tuple8(value0, value1, value, value3, value4, value5, value6, value7);

  Tuple8<T0, T1, T2, T, T4, T5, T6, T7> with3<T>(T value) =>
      Tuple8(value0, value1, value2, value, value4, value5, value6, value7);

  Tuple8<T0, T1, T2, T3, T, T5, T6, T7> with4<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value, value5, value6, value7);

  Tuple8<T0, T1, T2, T3, T4, T, T6, T7> with5<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value4, value, value6, value7);

  Tuple8<T0, T1, T2, T3, T4, T5, T, T7> with6<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value4, value5, value, value7);

  Tuple8<T0, T1, T2, T3, T4, T5, T6, T> with7<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value4, value5, value6, value);

  @override
  Tuple9<T, T0, T1, T2, T3, T4, T5, T6, T7> addFirst<T>(T value) =>
      addAt0(value);

  @override
  Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T> addLast<T>(T value) =>
      addAt8(value);

  Tuple9<T, T0, T1, T2, T3, T4, T5, T6, T7> addAt0<T>(T value) => Tuple9(
      value, value0, value1, value2, value3, value4, value5, value6, value7);

  Tuple9<T0, T, T1, T2, T3, T4, T5, T6, T7> addAt1<T>(T value) => Tuple9(
      value0, value, value1, value2, value3, value4, value5, value6, value7);

  Tuple9<T0, T1, T, T2, T3, T4, T5, T6, T7> addAt2<T>(T value) => Tuple9(
      value0, value1, value, value2, value3, value4, value5, value6, value7);

  Tuple9<T0, T1, T2, T, T3, T4, T5, T6, T7> addAt3<T>(T value) => Tuple9(
      value0, value1, value2, value, value3, value4, value5, value6, value7);

  Tuple9<T0, T1, T2, T3, T, T4, T5, T6, T7> addAt4<T>(T value) => Tuple9(
      value0, value1, value2, value3, value, value4, value5, value6, value7);

  Tuple9<T0, T1, T2, T3, T4, T, T5, T6, T7> addAt5<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value, value5, value6, value7);

  Tuple9<T0, T1, T2, T3, T4, T5, T, T6, T7> addAt6<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value5, value, value6, value7);

  Tuple9<T0, T1, T2, T3, T4, T5, T6, T, T7> addAt7<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value5, value6, value, value7);

  Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T> addAt8<T>(T value) => Tuple9(
      value0, value1, value2, value3, value4, value5, value6, value7, value);

  @override
  Tuple7<T1, T2, T3, T4, T5, T6, T7> removeFirst() => removeAt0();

  @override
  Tuple7<T0, T1, T2, T3, T4, T5, T6> removeLast() => removeAt7();

  Tuple7<T1, T2, T3, T4, T5, T6, T7> removeAt0() =>
      Tuple7(value1, value2, value3, value4, value5, value6, value7);

  Tuple7<T0, T2, T3, T4, T5, T6, T7> removeAt1() =>
      Tuple7(value0, value2, value3, value4, value5, value6, value7);

  Tuple7<T0, T1, T3, T4, T5, T6, T7> removeAt2() =>
      Tuple7(value0, value1, value3, value4, value5, value6, value7);

  Tuple7<T0, T1, T2, T4, T5, T6, T7> removeAt3() =>
      Tuple7(value0, value1, value2, value4, value5, value6, value7);

  Tuple7<T0, T1, T2, T3, T5, T6, T7> removeAt4() =>
      Tuple7(value0, value1, value2, value3, value5, value6, value7);

  Tuple7<T0, T1, T2, T3, T4, T6, T7> removeAt5() =>
      Tuple7(value0, value1, value2, value3, value4, value6, value7);

  Tuple7<T0, T1, T2, T3, T4, T5, T7> removeAt6() =>
      Tuple7(value0, value1, value2, value3, value4, value5, value7);

  Tuple7<T0, T1, T2, T3, T4, T5, T6> removeAt7() =>
      Tuple7(value0, value1, value2, value3, value4, value5, value6);

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
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple8 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3 &&
          value4 == other.value4 &&
          value5 == other.value5 &&
          value6 == other.value6 &&
          value7 == other.value7);

  @override
  int get hashCode =>
      4213795120 ^
      value0.hashCode ^
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode ^
      value4.hashCode ^
      value5.hashCode ^
      value6.hashCode ^
      value7.hashCode;
}
