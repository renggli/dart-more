/// Extension methods on [Record] with 4 positional elements.
extension Tuple4<T1, T2, T3, T4> on (T1, T2, T3, T4) {
  /// List constructor.
  static (T, T, T, T) fromList<T>(List<T> list) {
    if (list.length != 4) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 4, but got ${list.length}');
    }
    return (list[0], list[1], list[2], list[3]);
  }

  /// Returns the number of elements in the tuple.
  int get length => 4;

  /// Returns the first element of this tuple.
  T1 get first => $1;

  /// Returns the second element of this tuple.
  T2 get second => $2;

  /// Returns the third element of this tuple.
  T3 get third => $3;

  /// Returns the fourth element of this tuple.
  T4 get fourth => $4;

  /// Returns the last element of this tuple.
  T4 get last => $4;

  /// Returns a new tuple with the first element replaced by [value].
  (T, T2, T3, T4) withFirst<T>(T value) => (value, $2, $3, $4);

  /// Returns a new tuple with the second element replaced by [value].
  (T1, T, T3, T4) withSecond<T>(T value) => ($1, value, $3, $4);

  /// Returns a new tuple with the third element replaced by [value].
  (T1, T2, T, T4) withThird<T>(T value) => ($1, $2, value, $4);

  /// Returns a new tuple with the fourth element replaced by [value].
  (T1, T2, T3, T) withFourth<T>(T value) => ($1, $2, $3, value);

  /// Returns a new tuple with the last element replaced by [value].
  (T1, T2, T3, T) withLast<T>(T value) => ($1, $2, $3, value);

  /// Returns a new tuple with [value] added at the first position.
  (T, T1, T2, T3, T4) addFirst<T>(T value) => (value, $1, $2, $3, $4);

  /// Returns a new tuple with [value] added at the second position.
  (T1, T, T2, T3, T4) addSecond<T>(T value) => ($1, value, $2, $3, $4);

  /// Returns a new tuple with [value] added at the third position.
  (T1, T2, T, T3, T4) addThird<T>(T value) => ($1, $2, value, $3, $4);

  /// Returns a new tuple with [value] added at the fourth position.
  (T1, T2, T3, T, T4) addFourth<T>(T value) => ($1, $2, $3, value, $4);

  /// Returns a new tuple with [value] added at the fifth position.
  (T1, T2, T3, T4, T) addFifth<T>(T value) => ($1, $2, $3, $4, value);

  /// Returns a new tuple with [value] added at the last position.
  (T1, T2, T3, T4, T) addLast<T>(T value) => ($1, $2, $3, $4, value);

  /// Returns a new tuple with the first element removed.
  (T2, T3, T4) removeFirst() => ($2, $3, $4);

  /// Returns a new tuple with the second element removed.
  (T1, T3, T4) removeSecond() => ($1, $3, $4);

  /// Returns a new tuple with the third element removed.
  (T1, T2, T4) removeThird() => ($1, $2, $4);

  /// Returns a new tuple with the fourth element removed.
  (T1, T2, T3) removeFourth() => ($1, $2, $3);

  /// Returns a new tuple with the last element removed.
  (T1, T2, T3) removeLast() => ($1, $2, $3);

  /// Applies the values of this tuple to an 4-ary function.
  R map<R>(R Function(T1 first, T2 second, T3 third, T4 fourth) callback) =>
      callback($1, $2, $3, $4);

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable sync* {
    yield $1;
    yield $2;
    yield $3;
    yield $4;
  }

  /// An (untyped) [List] with the values of this tuple.
  List<dynamic> toList() => [$1, $2, $3, $4];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<dynamic> toSet() => {$1, $2, $3, $4};
}
