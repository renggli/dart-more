/// Tuple with 8 elements.
extension Tuple8<T1, T2, T3, T4, T5, T6, T7, T8> on (
  T1,
  T2,
  T3,
  T4,
  T5,
  T6,
  T7,
  T8
) {
  /// List constructor.
  static (T, T, T, T, T, T, T, T) fromList<T>(List<T> list) {
    if (list.length != 8) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 8, but got ${list.length}');
    }
    return (
      list[0],
      list[1],
      list[2],
      list[3],
      list[4],
      list[5],
      list[6],
      list[7]
    );
  }

  /// Returns the number of elements in the tuple.
  int get length => 8;

  /// Returns the first element of this tuple.
  T1 get first => $1;

  /// Returns the second element of this tuple.
  T2 get second => $2;

  /// Returns the third element of this tuple.
  T3 get third => $3;

  /// Returns the fourth element of this tuple.
  T4 get fourth => $4;

  /// Returns the fifth element of this tuple.
  T5 get fifth => $5;

  /// Returns the sixth element of this tuple.
  T6 get sixth => $6;

  /// Returns the seventh element of this tuple.
  T7 get seventh => $7;

  /// Returns the eighth element of this tuple.
  T8 get eighth => $8;

  /// Returns the last element of this tuple.
  T8 get last => $8;

  /// Returns a new tuple with the first element replaced by [value].
  (T, T2, T3, T4, T5, T6, T7, T8) withFirst<T>(T value) =>
      (value, $2, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the second element replaced by [value].
  (T1, T, T3, T4, T5, T6, T7, T8) withSecond<T>(T value) =>
      ($1, value, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the third element replaced by [value].
  (T1, T2, T, T4, T5, T6, T7, T8) withThird<T>(T value) =>
      ($1, $2, value, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the fourth element replaced by [value].
  (T1, T2, T3, T, T5, T6, T7, T8) withFourth<T>(T value) =>
      ($1, $2, $3, value, $5, $6, $7, $8);

  /// Returns a new tuple with the fifth element replaced by [value].
  (T1, T2, T3, T4, T, T6, T7, T8) withFifth<T>(T value) =>
      ($1, $2, $3, $4, value, $6, $7, $8);

  /// Returns a new tuple with the sixth element replaced by [value].
  (T1, T2, T3, T4, T5, T, T7, T8) withSixth<T>(T value) =>
      ($1, $2, $3, $4, $5, value, $7, $8);

  /// Returns a new tuple with the seventh element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T, T8) withSeventh<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, value, $8);

  /// Returns a new tuple with the eighth element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T7, T) withEighth<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, value);

  /// Returns a new tuple with the last element replaced by [value].
  (T1, T2, T3, T4, T5, T6, T7, T) withLast<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, value);

  /// Returns a new tuple with [value] added at the first position.
  (T, T1, T2, T3, T4, T5, T6, T7, T8) addFirst<T>(T value) =>
      (value, $1, $2, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with [value] added at the second position.
  (T1, T, T2, T3, T4, T5, T6, T7, T8) addSecond<T>(T value) =>
      ($1, value, $2, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with [value] added at the third position.
  (T1, T2, T, T3, T4, T5, T6, T7, T8) addThird<T>(T value) =>
      ($1, $2, value, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with [value] added at the fourth position.
  (T1, T2, T3, T, T4, T5, T6, T7, T8) addFourth<T>(T value) =>
      ($1, $2, $3, value, $4, $5, $6, $7, $8);

  /// Returns a new tuple with [value] added at the fifth position.
  (T1, T2, T3, T4, T, T5, T6, T7, T8) addFifth<T>(T value) =>
      ($1, $2, $3, $4, value, $5, $6, $7, $8);

  /// Returns a new tuple with [value] added at the sixth position.
  (T1, T2, T3, T4, T5, T, T6, T7, T8) addSixth<T>(T value) =>
      ($1, $2, $3, $4, $5, value, $6, $7, $8);

  /// Returns a new tuple with [value] added at the seventh position.
  (T1, T2, T3, T4, T5, T6, T, T7, T8) addSeventh<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, value, $7, $8);

  /// Returns a new tuple with [value] added at the eighth position.
  (T1, T2, T3, T4, T5, T6, T7, T, T8) addEighth<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, value, $8);

  /// Returns a new tuple with [value] added at the ninth position.
  (T1, T2, T3, T4, T5, T6, T7, T8, T) addNinth<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, value);

  /// Returns a new tuple with [value] added at the last position.
  (T1, T2, T3, T4, T5, T6, T7, T8, T) addLast<T>(T value) =>
      ($1, $2, $3, $4, $5, $6, $7, $8, value);

  /// Returns a new tuple with the first element removed.
  (T2, T3, T4, T5, T6, T7, T8) removeFirst() => ($2, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the second element removed.
  (T1, T3, T4, T5, T6, T7, T8) removeSecond() => ($1, $3, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the third element removed.
  (T1, T2, T4, T5, T6, T7, T8) removeThird() => ($1, $2, $4, $5, $6, $7, $8);

  /// Returns a new tuple with the fourth element removed.
  (T1, T2, T3, T5, T6, T7, T8) removeFourth() => ($1, $2, $3, $5, $6, $7, $8);

  /// Returns a new tuple with the fifth element removed.
  (T1, T2, T3, T4, T6, T7, T8) removeFifth() => ($1, $2, $3, $4, $6, $7, $8);

  /// Returns a new tuple with the sixth element removed.
  (T1, T2, T3, T4, T5, T7, T8) removeSixth() => ($1, $2, $3, $4, $5, $7, $8);

  /// Returns a new tuple with the seventh element removed.
  (T1, T2, T3, T4, T5, T6, T8) removeSeventh() => ($1, $2, $3, $4, $5, $6, $8);

  /// Returns a new tuple with the eighth element removed.
  (T1, T2, T3, T4, T5, T6, T7) removeEighth() => ($1, $2, $3, $4, $5, $6, $7);

  /// Returns a new tuple with the last element removed.
  (T1, T2, T3, T4, T5, T6, T7) removeLast() => ($1, $2, $3, $4, $5, $6, $7);

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<Object?> get iterable sync* {
    yield $1;
    yield $2;
    yield $3;
    yield $4;
    yield $5;
    yield $6;
    yield $7;
    yield $8;
  }

  /// An (untyped) [List] with the values of this tuple.
  List<Object?> toList() => [$1, $2, $3, $4, $5, $6, $7, $8];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<Object?> toSet() => {$1, $2, $3, $4, $5, $6, $7, $8};

  /// Applies the values of this tuple to an 8-ary function.
  R map<R>(
          R Function(T1 first, T2 second, T3 third, T4 fourth, T5 fifth,
                  T6 sixth, T7 seventh, T8 eighth)
              callback) =>
      callback($1, $2, $3, $4, $5, $6, $7, $8);
}
