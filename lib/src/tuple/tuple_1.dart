import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 1 element.
class Tuple1<T0> extends Tuple {
  /// Const constructor.
  const Tuple1(this.first);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple1<T> fromList<T>(List<T> list) {
    if (list.length != 1) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 1, but got ${list.length}.');
    }
    return Tuple1(list[0]);
  }

  @override
  int get length => 1;

  /// Returns the first element of this tuple.
  final T0 first;

  /// Returns the last element of this tuple.
  T0 get last => first;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple1<T> withFirst<T>(T value) => Tuple1(value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple1<T> withLast<T>(T value) => Tuple1(value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple2<T, T0> addFirst<T>(T value) => Tuple2(value, first);

  /// Returns a new tuple with [value] added at the second position.
  Tuple2<T0, T> addSecond<T>(T value) => Tuple2(first, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple2<T0, T> addLast<T>(T value) => Tuple2(first, value);

  /// Returns a new tuple with the first element removed.
  Tuple0 removeFirst() => const Tuple0();

  /// Returns a new tuple with the last element removed.
  Tuple0 removeLast() => const Tuple0();

  @override
  Iterable get iterable sync* {
    yield first;
  }

  @override
  R map<R>(R Function(T0 first) callback) => callback(first);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Tuple1 && first == other.first);

  @override
  int get hashCode => hash1(first);
}
