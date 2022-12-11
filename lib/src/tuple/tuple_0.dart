import 'tuple.dart';
import 'tuple_1.dart';

/// Tuple with 0 elements.
class Tuple0 extends Tuple {
  /// Const constructor.
  const Tuple0();

  /// List constructor.
  static Tuple0 fromList<T>(List<T> list) {
    if (list.isNotEmpty) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 0, but got ${list.length}');
    }
    return const Tuple0();
  }

  @override
  int get length => 0;

  /// Returns a new tuple with [value] added at the first position.
  Tuple1<T> addFirst<T>(T value) => Tuple1(value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple1<T> addLast<T>(T value) => Tuple1(value);

  @override
  Iterable<Object?> get iterable sync* {}

  @override
  R map<R>(R Function() callback) => callback();

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Tuple0);

  @override
  int get hashCode => 2895809587;
}
