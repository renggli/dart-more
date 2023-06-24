/// Extension methods on [Record] with 2 positional elements.
extension Tuple2<T1, T2> on (T1, T2) {
  /// List constructor.
  static (T, T) fromList<T>(List<T> list) {
    if (list.length != 2) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 2, but got ${list.length}');
    }
    return (list[0], list[1]);
  }

  /// Returns the number of elements in the tuple.
  int get length => 2;

  /// Returns the first element of this tuple.
  T1 get first => $1;

  /// Returns the second element of this tuple.
  T2 get second => $2;

  /// Returns the last element of this tuple.
  T2 get last => $2;

  /// Returns a new tuple with the first element replaced by [value].
  (T, T2) withFirst<T>(T value) => (value, $2);

  /// Returns a new tuple with the second element replaced by [value].
  (T1, T) withSecond<T>(T value) => ($1, value);

  /// Returns a new tuple with the last element replaced by [value].
  (T1, T) withLast<T>(T value) => ($1, value);

  /// Returns a new tuple with [value] added at the first position.
  (T, T1, T2) addFirst<T>(T value) => (value, $1, $2);

  /// Returns a new tuple with [value] added at the second position.
  (T1, T, T2) addSecond<T>(T value) => ($1, value, $2);

  /// Returns a new tuple with [value] added at the third position.
  (T1, T2, T) addThird<T>(T value) => ($1, $2, value);

  /// Returns a new tuple with [value] added at the last position.
  (T1, T2, T) addLast<T>(T value) => ($1, $2, value);

  /// Returns a new tuple with the first element removed.
  (T2,) removeFirst() => ($2,);

  /// Returns a new tuple with the second element removed.
  (T1,) removeSecond() => ($1,);

  /// Returns a new tuple with the last element removed.
  (T1,) removeLast() => ($1,);

  /// Applies the values of this tuple to an 2-ary function.
  R map<R>(R Function(T1 first, T2 second) callback) => callback($1, $2);

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable sync* {
    yield $1;
    yield $2;
  }

  /// An (untyped) [List] with the values of this tuple.
  List<dynamic> toList() => [$1, $2];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<dynamic> toSet() => {$1, $2};
}
