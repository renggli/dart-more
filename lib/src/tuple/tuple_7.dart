library more.tuple.tuple_7;

import 'package:more/tuple.dart';

/// Tuple with 7 elements.
class Tuple7<T0, T1, T2, T3, T4, T5, T6> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;
  final T3 value3;
  final T4 value4;
  final T5 value5;
  final T6 value6;

  const Tuple7(this.value0, this.value1, this.value2, this.value3, this.value4,
      this.value5, this.value6);

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

  Tuple7<T, T1, T2, T3, T4, T5, T6> with0<T>(T value) =>
      Tuple7(value, value1, value2, value3, value4, value5, value6);

  Tuple7<T0, T, T2, T3, T4, T5, T6> with1<T>(T value) =>
      Tuple7(value0, value, value2, value3, value4, value5, value6);

  Tuple7<T0, T1, T, T3, T4, T5, T6> with2<T>(T value) =>
      Tuple7(value0, value1, value, value3, value4, value5, value6);

  Tuple7<T0, T1, T2, T, T4, T5, T6> with3<T>(T value) =>
      Tuple7(value0, value1, value2, value, value4, value5, value6);

  Tuple7<T0, T1, T2, T3, T, T5, T6> with4<T>(T value) =>
      Tuple7(value0, value1, value2, value3, value, value5, value6);

  Tuple7<T0, T1, T2, T3, T4, T, T6> with5<T>(T value) =>
      Tuple7(value0, value1, value2, value3, value4, value, value6);

  Tuple7<T0, T1, T2, T3, T4, T5, T> with6<T>(T value) =>
      Tuple7(value0, value1, value2, value3, value4, value5, value);

  @override
  Tuple8<T, T0, T1, T2, T3, T4, T5, T6> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple8<T0, T1, T2, T3, T4, T5, T6, T> addLast<T>(T value) => addAt7(value);

  Tuple8<T, T0, T1, T2, T3, T4, T5, T6> addAt0<T>(T value) =>
      Tuple8(value, value0, value1, value2, value3, value4, value5, value6);

  Tuple8<T0, T, T1, T2, T3, T4, T5, T6> addAt1<T>(T value) =>
      Tuple8(value0, value, value1, value2, value3, value4, value5, value6);

  Tuple8<T0, T1, T, T2, T3, T4, T5, T6> addAt2<T>(T value) =>
      Tuple8(value0, value1, value, value2, value3, value4, value5, value6);

  Tuple8<T0, T1, T2, T, T3, T4, T5, T6> addAt3<T>(T value) =>
      Tuple8(value0, value1, value2, value, value3, value4, value5, value6);

  Tuple8<T0, T1, T2, T3, T, T4, T5, T6> addAt4<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value, value4, value5, value6);

  Tuple8<T0, T1, T2, T3, T4, T, T5, T6> addAt5<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value4, value, value5, value6);

  Tuple8<T0, T1, T2, T3, T4, T5, T, T6> addAt6<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value4, value5, value, value6);

  Tuple8<T0, T1, T2, T3, T4, T5, T6, T> addAt7<T>(T value) =>
      Tuple8(value0, value1, value2, value3, value4, value5, value6, value);

  @override
  Tuple6<T1, T2, T3, T4, T5, T6> removeFirst() => removeAt0();

  @override
  Tuple6<T0, T1, T2, T3, T4, T5> removeLast() => removeAt6();

  Tuple6<T1, T2, T3, T4, T5, T6> removeAt0() =>
      Tuple6(value1, value2, value3, value4, value5, value6);

  Tuple6<T0, T2, T3, T4, T5, T6> removeAt1() =>
      Tuple6(value0, value2, value3, value4, value5, value6);

  Tuple6<T0, T1, T3, T4, T5, T6> removeAt2() =>
      Tuple6(value0, value1, value3, value4, value5, value6);

  Tuple6<T0, T1, T2, T4, T5, T6> removeAt3() =>
      Tuple6(value0, value1, value2, value4, value5, value6);

  Tuple6<T0, T1, T2, T3, T5, T6> removeAt4() =>
      Tuple6(value0, value1, value2, value3, value5, value6);

  Tuple6<T0, T1, T2, T3, T4, T6> removeAt5() =>
      Tuple6(value0, value1, value2, value3, value4, value6);

  Tuple6<T0, T1, T2, T3, T4, T5> removeAt6() =>
      Tuple6(value0, value1, value2, value3, value4, value5);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
    yield value2;
    yield value3;
    yield value4;
    yield value5;
    yield value6;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple7 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3 &&
          value4 == other.value4 &&
          value5 == other.value5 &&
          value6 == other.value6);

  @override
  int get hashCode =>
      3505223485 ^
      value0.hashCode ^
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode ^
      value4.hashCode ^
      value5.hashCode ^
      value6.hashCode;
}
