library more.tuple.tuple_3;

import '../../tuple.dart';

/// Tuple with 3 elements.
class Tuple3<T0, T1, T2> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;

  /// Const constructor.
  const Tuple3(this.value0, this.value1, this.value2);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple3<T, T, T> fromList<T>(List<T> list) {
    if (list.length != 3) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 3, but got ${list.length}.');
    }
    return Tuple3(list[0], list[1], list[2]);
  }

  @override
  int get length => 3;

  /// Returns a new tuple with index 0 replaced by [value].
  Tuple3<T, T1, T2> with0<T>(T value) => Tuple3(value, value1, value2);

  /// Returns a new tuple with index 1 replaced by [value].
  Tuple3<T0, T, T2> with1<T>(T value) => Tuple3(value0, value, value2);

  /// Returns a new tuple with index 2 replaced by [value].
  Tuple3<T0, T1, T> with2<T>(T value) => Tuple3(value0, value1, value);

  @override
  Tuple4<T, T0, T1, T2> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple4<T0, T1, T2, T> addLast<T>(T value) => addAt3(value);

  /// Returns a new tuple with [value] added at index 0.
  Tuple4<T, T0, T1, T2> addAt0<T>(T value) =>
      Tuple4(value, value0, value1, value2);

  /// Returns a new tuple with [value] added at index 1.
  Tuple4<T0, T, T1, T2> addAt1<T>(T value) =>
      Tuple4(value0, value, value1, value2);

  /// Returns a new tuple with [value] added at index 2.
  Tuple4<T0, T1, T, T2> addAt2<T>(T value) =>
      Tuple4(value0, value1, value, value2);

  /// Returns a new tuple with [value] added at index 3.
  Tuple4<T0, T1, T2, T> addAt3<T>(T value) =>
      Tuple4(value0, value1, value2, value);

  @override
  Tuple2<T1, T2> removeFirst() => removeAt0();

  @override
  Tuple2<T0, T1> removeLast() => removeAt2();

  /// Returns a new tuple with index 0 removed.
  Tuple2<T1, T2> removeAt0() => Tuple2(value1, value2);

  /// Returns a new tuple with index 1 removed.
  Tuple2<T0, T2> removeAt1() => Tuple2(value0, value2);

  /// Returns a new tuple with index 2 removed.
  Tuple2<T0, T1> removeAt2() => Tuple2(value0, value1);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
    yield value2;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple3 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2);

  @override
  int get hashCode =>
      3372193885 ^ value0.hashCode ^ value1.hashCode ^ value2.hashCode;
}
