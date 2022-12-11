import 'package:meta/meta.dart' show immutable;

import 'tuple_0.dart';
import 'tuple_1.dart';
import 'tuple_2.dart';
import 'tuple_3.dart';
import 'tuple_4.dart';
import 'tuple_5.dart';
import 'tuple_6.dart';
import 'tuple_7.dart';
import 'tuple_8.dart';
import 'tuple_9.dart';

/// Abstract tuple class.
@immutable
abstract class Tuple {
  /// Const constructor.
  const Tuple();

  /// List constructor.
  static Tuple fromList<T>(List<T> list) {
    switch (list.length) {
      case 0:
        return const Tuple0();
      case 1:
        return Tuple1.fromList(list);
      case 2:
        return Tuple2.fromList(list);
      case 3:
        return Tuple3.fromList(list);
      case 4:
        return Tuple4.fromList(list);
      case 5:
        return Tuple5.fromList(list);
      case 6:
        return Tuple6.fromList(list);
      case 7:
        return Tuple7.fromList(list);
      case 8:
        return Tuple8.fromList(list);
      case 9:
        return Tuple9.fromList(list);
      default:
        throw ArgumentError.value(
            list, 'list', 'Length ${list.length} not in range 0..9');
    }
  }

  /// The number of elements in the tuple.
  int get length;

  /// An [Iterable] over the values of this tuple.
  Iterable<Object?> get iterable;

  /// A (untyped) [List] with the values of this tuple.
  List<Object?> toList({bool growable = false}) =>
      List.from(iterable, growable: growable);

  /// A (untyped) [Set] with the unique values of this tuple.
  Set<Object?> toSet() => Set.from(iterable);

  /// Applies the values of this tuple to an n-ary function.
  R map<R>(covariant Function callback);

  /// A string representation of this tuple.
  @override
  String toString() => '(${iterable.join(', ')})';
}
