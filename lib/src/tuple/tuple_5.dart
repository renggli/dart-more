library more.tuple.tuple_5;

import 'package:more/tuple.dart';

/// Tuple with 5 elements.
class Tuple5<T0, T1, T2, T3, T4> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;
  final T3 value3;
  final T4 value4;

  const Tuple5(this.value0, this.value1, this.value2, this.value3, this.value4);

  static Tuple5<T, T, T, T, T> fromList<T>(List<T> list) =>
      Tuple5(list[0], list[1], list[2], list[3], list[4]);

  @override
  int get length => 5;

  Tuple5<T, T1, T2, T3, T4> with0<T>(T value) =>
      Tuple5(value, value1, value2, value3, value4);

  Tuple5<T0, T, T2, T3, T4> with1<T>(T value) =>
      Tuple5(value0, value, value2, value3, value4);

  Tuple5<T0, T1, T, T3, T4> with2<T>(T value) =>
      Tuple5(value0, value1, value, value3, value4);

  Tuple5<T0, T1, T2, T, T4> with3<T>(T value) =>
      Tuple5(value0, value1, value2, value, value4);

  Tuple5<T0, T1, T2, T3, T> with4<T>(T value) =>
      Tuple5(value0, value1, value2, value3, value);

  @override
  Tuple6<T, T0, T1, T2, T3, T4> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple6<T0, T1, T2, T3, T4, T> addLast<T>(T value) => addAt5(value);

  Tuple6<T, T0, T1, T2, T3, T4> addAt0<T>(T value) =>
      Tuple6(value, value0, value1, value2, value3, value4);

  Tuple6<T0, T, T1, T2, T3, T4> addAt1<T>(T value) =>
      Tuple6(value0, value, value1, value2, value3, value4);

  Tuple6<T0, T1, T, T2, T3, T4> addAt2<T>(T value) =>
      Tuple6(value0, value1, value, value2, value3, value4);

  Tuple6<T0, T1, T2, T, T3, T4> addAt3<T>(T value) =>
      Tuple6(value0, value1, value2, value, value3, value4);

  Tuple6<T0, T1, T2, T3, T, T4> addAt4<T>(T value) =>
      Tuple6(value0, value1, value2, value3, value, value4);

  Tuple6<T0, T1, T2, T3, T4, T> addAt5<T>(T value) =>
      Tuple6(value0, value1, value2, value3, value4, value);

  @override
  Tuple4<T1, T2, T3, T4> removeFirst() => removeAt0();

  @override
  Tuple4<T0, T1, T2, T3> removeLast() => removeAt4();

  Tuple4<T1, T2, T3, T4> removeAt0() => Tuple4(value1, value2, value3, value4);

  Tuple4<T0, T2, T3, T4> removeAt1() => Tuple4(value0, value2, value3, value4);

  Tuple4<T0, T1, T3, T4> removeAt2() => Tuple4(value0, value1, value3, value4);

  Tuple4<T0, T1, T2, T4> removeAt3() => Tuple4(value0, value1, value2, value4);

  Tuple4<T0, T1, T2, T3> removeAt4() => Tuple4(value0, value1, value2, value3);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
    yield value2;
    yield value3;
    yield value4;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple5 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3 &&
          value4 == other.value4);

  @override
  int get hashCode =>
      40243304 ^
      value0.hashCode ^
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode ^
      value4.hashCode;
}
