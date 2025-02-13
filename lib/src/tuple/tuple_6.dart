// AUTO-GENERATED CODE: DO NOT EDIT

/// Extension methods on [Record] with 6 positional elements.
extension Tuple6<T1, T2, T3, T4, T5, T6> on (T1, T2, T3, T4, T5, T6) {
  /// List constructor.
  static (T, T, T, T, T, T) fromList<T>(List<T> list) {
    if (list.length != 6) {
      throw ArgumentError.value(
        list,
        'list',
        'Expected list of length 6, but got ${list.length}',
      );
    }
    return (list[0], list[1], list[2], list[3], list[4], list[5]);
  }

  /// Returns the number of elements in the tuple.
  int get length => 6;

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

  /// Returns the last element of this tuple.
  T6 get last => $6;

  /// Returns a new tuple with the first element replaced by [value].
  (T, T2, T3, T4, T5, T6) withFirst<T>(T value) => (value, $2, $3, $4, $5, $6);

  /// Returns a new tuple with the second element replaced by [value].
  (T1, T, T3, T4, T5, T6) withSecond<T>(T value) => ($1, value, $3, $4, $5, $6);

  /// Returns a new tuple with the third element replaced by [value].
  (T1, T2, T, T4, T5, T6) withThird<T>(T value) => ($1, $2, value, $4, $5, $6);

  /// Returns a new tuple with the fourth element replaced by [value].
  (T1, T2, T3, T, T5, T6) withFourth<T>(T value) => ($1, $2, $3, value, $5, $6);

  /// Returns a new tuple with the fifth element replaced by [value].
  (T1, T2, T3, T4, T, T6) withFifth<T>(T value) => ($1, $2, $3, $4, value, $6);

  /// Returns a new tuple with the sixth element replaced by [value].
  (T1, T2, T3, T4, T5, T) withSixth<T>(T value) => ($1, $2, $3, $4, $5, value);

  /// Returns a new tuple with the last element replaced by [value].
  (T1, T2, T3, T4, T5, T) withLast<T>(T value) => ($1, $2, $3, $4, $5, value);

  /// Returns a new tuple with [value] added at the first position.
  (T, T1, T2, T3, T4, T5, T6) addFirst<T>(T value) => (
    value,
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
  );

  /// Returns a new tuple with [value] added at the second position.
  (T1, T, T2, T3, T4, T5, T6) addSecond<T>(T value) => (
    $1,
    value,
    $2,
    $3,
    $4,
    $5,
    $6,
  );

  /// Returns a new tuple with [value] added at the third position.
  (T1, T2, T, T3, T4, T5, T6) addThird<T>(T value) => (
    $1,
    $2,
    value,
    $3,
    $4,
    $5,
    $6,
  );

  /// Returns a new tuple with [value] added at the fourth position.
  (T1, T2, T3, T, T4, T5, T6) addFourth<T>(T value) => (
    $1,
    $2,
    $3,
    value,
    $4,
    $5,
    $6,
  );

  /// Returns a new tuple with [value] added at the fifth position.
  (T1, T2, T3, T4, T, T5, T6) addFifth<T>(T value) => (
    $1,
    $2,
    $3,
    $4,
    value,
    $5,
    $6,
  );

  /// Returns a new tuple with [value] added at the sixth position.
  (T1, T2, T3, T4, T5, T, T6) addSixth<T>(T value) => (
    $1,
    $2,
    $3,
    $4,
    $5,
    value,
    $6,
  );

  /// Returns a new tuple with [value] added at the seventh position.
  (T1, T2, T3, T4, T5, T6, T) addSeventh<T>(T value) => (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    value,
  );

  /// Returns a new tuple with [value] added at the last position.
  (T1, T2, T3, T4, T5, T6, T) addLast<T>(T value) => (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    value,
  );

  /// Returns a new tuple with the first element removed.
  (T2, T3, T4, T5, T6) removeFirst() => ($2, $3, $4, $5, $6);

  /// Returns a new tuple with the second element removed.
  (T1, T3, T4, T5, T6) removeSecond() => ($1, $3, $4, $5, $6);

  /// Returns a new tuple with the third element removed.
  (T1, T2, T4, T5, T6) removeThird() => ($1, $2, $4, $5, $6);

  /// Returns a new tuple with the fourth element removed.
  (T1, T2, T3, T5, T6) removeFourth() => ($1, $2, $3, $5, $6);

  /// Returns a new tuple with the fifth element removed.
  (T1, T2, T3, T4, T6) removeFifth() => ($1, $2, $3, $4, $6);

  /// Returns a new tuple with the sixth element removed.
  (T1, T2, T3, T4, T5) removeSixth() => ($1, $2, $3, $4, $5);

  /// Returns a new tuple with the last element removed.
  (T1, T2, T3, T4, T5) removeLast() => ($1, $2, $3, $4, $5);

  /// Applies the values of this tuple to an 6-ary function.
  R map<R>(
    R Function(T1 first, T2 second, T3 third, T4 fourth, T5 fifth, T6 sixth)
    callback,
  ) => callback($1, $2, $3, $4, $5, $6);

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => toList();

  /// An (untyped) [List] with the values of this tuple.
  List<dynamic> toList() => [$1, $2, $3, $4, $5, $6];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<dynamic> toSet() => {$1, $2, $3, $4, $5, $6};
}
