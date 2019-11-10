library more.tuple.tuple_2;

import 'package:more/tuple.dart';

/// Tuple with 2 elements.
class Tuple2<T0, T1> extends Tuple {
  final T0 value0;
  final T1 value1;

  /// Const constructor.
  const Tuple2(this.value0, this.value1);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple2<T, T> fromList<T>(List<T> list) {
    if (list.length != 2) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 2, but got ${list.length}.');
    }
    return Tuple2(list[0], list[1]);
  }

  @override
  int get length => 2;

  /// Returns a new tuple with index 0 replaced by [value].
  Tuple2<T, T1> with0<T>(T value) => Tuple2(value, value1);

  /// Returns a new tuple with index 1 replaced by [value].
  Tuple2<T0, T> with1<T>(T value) => Tuple2(value0, value);

  @override
  Tuple3<T, T0, T1> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple3<T0, T1, T> addLast<T>(T value) => addAt2(value);

  /// Returns a new tuple with [value] added at index 0.
  Tuple3<T, T0, T1> addAt0<T>(T value) => Tuple3(value, value0, value1);

  /// Returns a new tuple with [value] added at index 1.
  Tuple3<T0, T, T1> addAt1<T>(T value) => Tuple3(value0, value, value1);

  /// Returns a new tuple with [value] added at index 2.
  Tuple3<T0, T1, T> addAt2<T>(T value) => Tuple3(value0, value1, value);

  @override
  Tuple1<T1> removeFirst() => removeAt0();

  @override
  Tuple1<T0> removeLast() => removeAt1();

  /// Returns a new tuple with index 0 removed.
  Tuple1<T1> removeAt0() => Tuple1(value1);

  /// Returns a new tuple with index 1 removed.
  Tuple1<T0> removeAt1() => Tuple1(value0);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple2 && value0 == other.value0 && value1 == other.value1);

  @override
  int get hashCode => 376088004 ^ value0.hashCode ^ value1.hashCode;
}
