/// Extension methods on [Record] with 3 positional elements.
extension Tuple3<T1, T2, T3> on (T1, T2, T3) {
  /// List constructor.
  static (T, T, T) fromList<T>(List<T> list) {
    if (list.length != 3) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 3, but got ${list.length}');
    }
    return (list[0], list[1], list[2]);
  }

  /// Returns the number of elements in the tuple.
  int get length => 3;

  /// Returns the first element of this tuple.
  T1 get first => $1;

  /// Returns the second element of this tuple.
  T2 get second => $2;

  /// Returns the third element of this tuple.
  T3 get third => $3;

  /// Returns the last element of this tuple.
  T3 get last => $3;

  /// Returns a new tuple with the first element replaced by [value].
  (T, T2, T3) withFirst<T>(T value) => (value, $2, $3);

  /// Returns a new tuple with the second element replaced by [value].
  (T1, T, T3) withSecond<T>(T value) => ($1, value, $3);

  /// Returns a new tuple with the third element replaced by [value].
  (T1, T2, T) withThird<T>(T value) => ($1, $2, value);

  /// Returns a new tuple with the last element replaced by [value].
  (T1, T2, T) withLast<T>(T value) => ($1, $2, value);

  /// Returns a new tuple with [value] added at the first position.
  (T, T1, T2, T3) addFirst<T>(T value) => (value, $1, $2, $3);

  /// Returns a new tuple with [value] added at the second position.
  (T1, T, T2, T3) addSecond<T>(T value) => ($1, value, $2, $3);

  /// Returns a new tuple with [value] added at the third position.
  (T1, T2, T, T3) addThird<T>(T value) => ($1, $2, value, $3);

  /// Returns a new tuple with [value] added at the fourth position.
  (T1, T2, T3, T) addFourth<T>(T value) => ($1, $2, $3, value);

  /// Returns a new tuple with [value] added at the last position.
  (T1, T2, T3, T) addLast<T>(T value) => ($1, $2, $3, value);

  /// Returns a new tuple with the first element removed.
  (T2, T3) removeFirst() => ($2, $3);

  /// Returns a new tuple with the second element removed.
  (T1, T3) removeSecond() => ($1, $3);

  /// Returns a new tuple with the third element removed.
  (T1, T2) removeThird() => ($1, $2);

  /// Returns a new tuple with the last element removed.
  (T1, T2) removeLast() => ($1, $2);

  /// Applies the values of this tuple to an 3-ary function.
  R map<R>(R Function(T1 first, T2 second, T3 third) callback) =>
      callback($1, $2, $3);

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => toList();

  /// An (untyped) [List] with the values of this tuple.
  List<dynamic> toList() => [$1, $2, $3];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<dynamic> toSet() => {$1, $2, $3};
}
