/// Tuple data type.
import 'package:meta/meta.dart' show immutable;

import 'src/tuple/tuple_0.dart';
import 'src/tuple/tuple_1.dart';
import 'src/tuple/tuple_2.dart';
import 'src/tuple/tuple_3.dart';
import 'src/tuple/tuple_4.dart';
import 'src/tuple/tuple_5.dart';
import 'src/tuple/tuple_6.dart';
import 'src/tuple/tuple_7.dart';
import 'src/tuple/tuple_8.dart';
import 'src/tuple/tuple_9.dart';

export 'src/tuple/tuple_0.dart';
export 'src/tuple/tuple_1.dart';
export 'src/tuple/tuple_2.dart';
export 'src/tuple/tuple_3.dart';
export 'src/tuple/tuple_4.dart';
export 'src/tuple/tuple_5.dart';
export 'src/tuple/tuple_6.dart';
export 'src/tuple/tuple_7.dart';
export 'src/tuple/tuple_8.dart';
export 'src/tuple/tuple_9.dart';

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
            list, 'list', 'Length ${list.length} not in range 0..9.');
    }
  }

  /// The number of elements in the tuple.
  int get length;

  /// An [Iterable] over the values of this tuple.
  Iterable get iterable;

  /// A (untyped) [List] with the values of this tuple.
  List toList({bool growable = false}) =>
      List.from(iterable, growable: growable);

  /// A (untyped) [Set] with the unique values of this tuple.
  Set toSet() => Set.from(iterable);

  /// A string representation of this tuple.
  @override
  String toString() => '(${iterable.join(', ')})';
}
