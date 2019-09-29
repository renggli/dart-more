library more.tuple.tuple_4;

import 'package:more/tuple.dart';

/// Tuple with 4 elements.
class Tuple4<T0, T1, T2, T3> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;
  final T3 value3;

  const Tuple4(this.value0, this.value1, this.value2, this.value3);

  // ignore: prefer_constructors_over_static_methods
  static Tuple4<T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 4) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 4, but got ${list.length}.');
    }
    return Tuple4(list[0], list[1], list[2], list[3]);
  }

  @override
  int get length => 4;

  Tuple4<T, T1, T2, T3> with0<T>(T value) =>
      Tuple4(value, value1, value2, value3);

  Tuple4<T0, T, T2, T3> with1<T>(T value) =>
      Tuple4(value0, value, value2, value3);

  Tuple4<T0, T1, T, T3> with2<T>(T value) =>
      Tuple4(value0, value1, value, value3);

  Tuple4<T0, T1, T2, T> with3<T>(T value) =>
      Tuple4(value0, value1, value2, value);

  @override
  Tuple5<T, T0, T1, T2, T3> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple5<T0, T1, T2, T3, T> addLast<T>(T value) => addAt4(value);

  Tuple5<T, T0, T1, T2, T3> addAt0<T>(T value) =>
      Tuple5(value, value0, value1, value2, value3);

  Tuple5<T0, T, T1, T2, T3> addAt1<T>(T value) =>
      Tuple5(value0, value, value1, value2, value3);

  Tuple5<T0, T1, T, T2, T3> addAt2<T>(T value) =>
      Tuple5(value0, value1, value, value2, value3);

  Tuple5<T0, T1, T2, T, T3> addAt3<T>(T value) =>
      Tuple5(value0, value1, value2, value, value3);

  Tuple5<T0, T1, T2, T3, T> addAt4<T>(T value) =>
      Tuple5(value0, value1, value2, value3, value);

  @override
  Tuple3<T1, T2, T3> removeFirst() => removeAt0();

  @override
  Tuple3<T0, T1, T2> removeLast() => removeAt3();

  Tuple3<T1, T2, T3> removeAt0() => Tuple3(value1, value2, value3);

  Tuple3<T0, T2, T3> removeAt1() => Tuple3(value0, value2, value3);

  Tuple3<T0, T1, T3> removeAt2() => Tuple3(value0, value1, value3);

  Tuple3<T0, T1, T2> removeAt3() => Tuple3(value0, value1, value2);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
    yield value2;
    yield value3;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple4 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3);

  @override
  int get hashCode =>
      1319473077 ^
      value0.hashCode ^
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode;
}
