library more.tuple.tuple_6;

import '../../tuple.dart';

/// Tuple with 6 elements.
class Tuple6<T0, T1, T2, T3, T4, T5> extends Tuple {
  final T0 value0;
  final T1 value1;
  final T2 value2;
  final T3 value3;
  final T4 value4;
  final T5 value5;

  /// Const constructor.
  const Tuple6(this.value0, this.value1, this.value2, this.value3, this.value4,
      this.value5);

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

  /// Returns a new tuple with index 0 replaced by [value].
  Tuple6<T, T1, T2, T3, T4, T5> with0<T>(T value) =>
      Tuple6(value, value1, value2, value3, value4, value5);

  /// Returns a new tuple with index 1 replaced by [value].
  Tuple6<T0, T, T2, T3, T4, T5> with1<T>(T value) =>
      Tuple6(value0, value, value2, value3, value4, value5);

  /// Returns a new tuple with index 2 replaced by [value].
  Tuple6<T0, T1, T, T3, T4, T5> with2<T>(T value) =>
      Tuple6(value0, value1, value, value3, value4, value5);

  /// Returns a new tuple with index 3 replaced by [value].
  Tuple6<T0, T1, T2, T, T4, T5> with3<T>(T value) =>
      Tuple6(value0, value1, value2, value, value4, value5);

  /// Returns a new tuple with index 4 replaced by [value].
  Tuple6<T0, T1, T2, T3, T, T5> with4<T>(T value) =>
      Tuple6(value0, value1, value2, value3, value, value5);

  /// Returns a new tuple with index 5 replaced by [value].
  Tuple6<T0, T1, T2, T3, T4, T> with5<T>(T value) =>
      Tuple6(value0, value1, value2, value3, value4, value);

  @override
  Tuple7<T, T0, T1, T2, T3, T4, T5> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple7<T0, T1, T2, T3, T4, T5, T> addLast<T>(T value) => addAt6(value);

  /// Returns a new tuple with [value] added at index 0.
  Tuple7<T, T0, T1, T2, T3, T4, T5> addAt0<T>(T value) =>
      Tuple7(value, value0, value1, value2, value3, value4, value5);

  /// Returns a new tuple with [value] added at index 1.
  Tuple7<T0, T, T1, T2, T3, T4, T5> addAt1<T>(T value) =>
      Tuple7(value0, value, value1, value2, value3, value4, value5);

  /// Returns a new tuple with [value] added at index 2.
  Tuple7<T0, T1, T, T2, T3, T4, T5> addAt2<T>(T value) =>
      Tuple7(value0, value1, value, value2, value3, value4, value5);

  /// Returns a new tuple with [value] added at index 3.
  Tuple7<T0, T1, T2, T, T3, T4, T5> addAt3<T>(T value) =>
      Tuple7(value0, value1, value2, value, value3, value4, value5);

  /// Returns a new tuple with [value] added at index 4.
  Tuple7<T0, T1, T2, T3, T, T4, T5> addAt4<T>(T value) =>
      Tuple7(value0, value1, value2, value3, value, value4, value5);

  /// Returns a new tuple with [value] added at index 5.
  Tuple7<T0, T1, T2, T3, T4, T, T5> addAt5<T>(T value) =>
      Tuple7(value0, value1, value2, value3, value4, value, value5);

  /// Returns a new tuple with [value] added at index 6.
  Tuple7<T0, T1, T2, T3, T4, T5, T> addAt6<T>(T value) =>
      Tuple7(value0, value1, value2, value3, value4, value5, value);

  @override
  Tuple5<T1, T2, T3, T4, T5> removeFirst() => removeAt0();

  @override
  Tuple5<T0, T1, T2, T3, T4> removeLast() => removeAt5();

  /// Returns a new tuple with index 0 removed.
  Tuple5<T1, T2, T3, T4, T5> removeAt0() =>
      Tuple5(value1, value2, value3, value4, value5);

  /// Returns a new tuple with index 1 removed.
  Tuple5<T0, T2, T3, T4, T5> removeAt1() =>
      Tuple5(value0, value2, value3, value4, value5);

  /// Returns a new tuple with index 2 removed.
  Tuple5<T0, T1, T3, T4, T5> removeAt2() =>
      Tuple5(value0, value1, value3, value4, value5);

  /// Returns a new tuple with index 3 removed.
  Tuple5<T0, T1, T2, T4, T5> removeAt3() =>
      Tuple5(value0, value1, value2, value4, value5);

  /// Returns a new tuple with index 4 removed.
  Tuple5<T0, T1, T2, T3, T5> removeAt4() =>
      Tuple5(value0, value1, value2, value3, value5);

  /// Returns a new tuple with index 5 removed.
  Tuple5<T0, T1, T2, T3, T4> removeAt5() =>
      Tuple5(value0, value1, value2, value3, value4);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
    yield value2;
    yield value3;
    yield value4;
    yield value5;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple6 &&
          value0 == other.value0 &&
          value1 == other.value1 &&
          value2 == other.value2 &&
          value3 == other.value3 &&
          value4 == other.value4 &&
          value5 == other.value5);

  @override
  int get hashCode =>
      283265935 ^
      value0.hashCode ^
      value1.hashCode ^
      value2.hashCode ^
      value3.hashCode ^
      value4.hashCode ^
      value5.hashCode;
}
