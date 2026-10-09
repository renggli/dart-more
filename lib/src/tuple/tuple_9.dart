// AUTO-GENERATED CODE: DO NOT EDIT

/// Extension methods on [Record] with 9 positional elements.
extension Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on (T1, T2, T3, T4, T5, T6, T7, T8, T9) {
  /// Creates a tuple from the elements in [list].
  static (T, T, T, T, T, T, T, T, T) fromList<T>(List<T> list) {
    if (list.length != 9) {
      throw ArgumentError.value(
        list,
        'list',
        'Expected list of length 9, but got ${list.length}',
      );
    }
    return (
      list[0],
      list[1],
      list[2],
      list[3],
      list[4],
      list[5],
      list[6],
      list[7],
      list[8],
    );
  }

  /// The number of elements in the tuple.
  int get length => 9;

  /// The first element of this tuple.
  T1 get first => $1;

  /// The second element of this tuple.
  T2 get second => $2;

  /// The third element of this tuple.
  T3 get third => $3;

  /// The fourth element of this tuple.
  T4 get fourth => $4;

  /// The fifth element of this tuple.
  T5 get fifth => $5;

  /// The sixth element of this tuple.
  T6 get sixth => $6;

  /// The seventh element of this tuple.
  T7 get seventh => $7;

  /// The eighth element of this tuple.
  T8 get eighth => $8;

  /// The ninth element of this tuple.
  T9 get ninth => $9;

  /// The last element of this tuple.
  T9 get last => $9;

  /// Returns a new tuple with the first element replaced by [value].
  (T, T2, T3, T4, T5, T6, T7, T8, T9) withFirst<T>(T value) =>
      (value, $2, $3, $4, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the second element replaced by [value].
  (T1, T, T3, T4, T5, T6, T7, T8, T9) withSecond<T>(T value) =>
      ($1, value, $3, $4, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the third element replaced by [value].
  (T1, T2, T, T4, T5, T6, T7, T8, T9) withThird<T>(T value) =>
      ($1, $2, value, $4, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the fourth element replaced by [value].
  (T1, T2, T3, T, T5, T6, T7, T8, T9) withFourth<T>(T value) =>
      ($1, $2, $3, value, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the fifth element replaced by [value].
  (T1, T2, T3, T4, T, T6, T7, T8, T9) withFifth<T>(T value) =>
      ($1, $2, $3, $4, value, $6, $7, $8, $9);

  /// Returns a new tuple with the sixth element replaced by [value].
  (T1, T2, T3, T4, T5, T, T7, T8, T9) withSixth<T>(T value) =>
      ($1, $2, $3, $4, $5, value, $7, $8, $9);

  /// Returns a new tuple with the seventh element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T, T8, T9) withSeventh<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, value, $8, $9);

  /// Returns a new tuple with the eighth element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T7, T, T9) withEighth<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, value, $9);

  /// Returns a new tuple with the ninth element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T7, T8, T) withNinth<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, value);

  /// Returns a new tuple with the last element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T7, T8, T) withLast<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, value);

  /// Returns a new tuple with the first element removed.
  (T2, T3, T4, T5, T6, T7, T8, T9) removeFirst() =>
      ($2, $3, $4, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the second element removed.
  (T1, T3, T4, T5, T6, T7, T8, T9) removeSecond() =>
      ($1, $3, $4, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the third element removed.
  (T1, T2, T4, T5, T6, T7, T8, T9) removeThird() =>
      ($1, $2, $4, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the fourth element removed.
  (T1, T2, T3, T5, T6, T7, T8, T9) removeFourth() =>
      ($1, $2, $3, $5, $6, $7, $8, $9);

  /// Returns a new tuple with the fifth element removed.
  (T1, T2, T3, T4, T6, T7, T8, T9) removeFifth() =>
      ($1, $2, $3, $4, $6, $7, $8, $9);

  /// Returns a new tuple with the sixth element removed.
  (T1, T2, T3, T4, T5, T7, T8, T9) removeSixth() =>
      ($1, $2, $3, $4, $5, $7, $8, $9);

  /// Returns a new tuple with the seventh element removed.
  (T1, T2, T3, T4, T5, T6, T8, T9) removeSeventh() =>
      ($1, $2, $3, $4, $5, $6, $8, $9);

  /// Returns a new tuple with the eighth element removed.
  (T1, T2, T3, T4, T5, T6, T7, T9) removeEighth() =>
      ($1, $2, $3, $4, $5, $6, $7, $9);

  /// Returns a new tuple with the ninth element removed.
  (T1, T2, T3, T4, T5, T6, T7, T8) removeNinth() =>
      ($1, $2, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the last element removed.
  (T1, T2, T3, T4, T5, T6, T7, T8) removeLast() =>
      ($1, $2, $3, $4, $5, $6, $7, $8);

  /// Transforms the elements of this tuple using [callback].
  R map<R>(
    R Function(
      T1 first,
      T2 second,
      T3 third,
      T4 fourth,
      T5 fifth,
      T6 sixth,
      T7 seventh,
      T8 eighth,
      T9 ninth,
    )
    callback,
  ) => callback($1, $2, $3, $4, $5, $6, $7, $8, $9);

  /// An untyped [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => toList();

  /// Converts this tuple to an untyped [List].
  List<dynamic> toList() => [$1, $2, $3, $4, $5, $6, $7, $8, $9];

  /// Converts this tuple to an untyped [Set] of unique values.
  Set<dynamic> toSet() => {$1, $2, $3, $4, $5, $6, $7, $8, $9};
}
