// AUTO-GENERATED CODE: DO NOT EDIT

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

/// Extension methods on [Record].
extension Tuple on Record {
  /// List constructor.
  static Record fromList<T>(List<T> list) => switch (list.length) {
    0 => Tuple0.fromList(list),
    1 => Tuple1.fromList(list),
    2 => Tuple2.fromList(list),
    3 => Tuple3.fromList(list),
    4 => Tuple4.fromList(list),
    5 => Tuple5.fromList(list),
    6 => Tuple6.fromList(list),
    7 => Tuple7.fromList(list),
    8 => Tuple8.fromList(list),
    9 => Tuple9.fromList(list),
    _ =>
      throw ArgumentError.value(
        list,
        'list',
        'Length ${list.length} not in range 0..9',
      ),
  };
}
