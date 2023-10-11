/// Extension methods on [Record] with 1 positional element.
extension Tuple1<T1> on (T1,) {
  /// List constructor.
  static (T,) fromList<T>(List<T> list) {
    if (list.length != 1) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 1, but got ${list.length}');
    }
    return (list[0],);
  }

  /// Returns the number of elements in the tuple.
  int get length => 1;

  /// Returns the first element of this tuple.
  T1 get first => $1;

  /// Returns the last element of this tuple.
  T1 get last => $1;

  /// Returns a new tuple with the first element replaced by [value].
  (T,) withFirst<T>(T value) => (value,);

  /// Returns a new tuple with the last element replaced by [value].
  (T,) withLast<T>(T value) => (value,);

  /// Returns a new tuple with [value] added at the first position.
  (T, T1) addFirst<T>(T value) => (value, $1);

  /// Returns a new tuple with [value] added at the second position.
  (T1, T) addSecond<T>(T value) => ($1, value);

  /// Returns a new tuple with [value] added at the last position.
  (T1, T) addLast<T>(T value) => ($1, value);

  /// Returns a new tuple with the first element removed.
  () removeFirst() => ();

  /// Returns a new tuple with the last element removed.
  () removeLast() => ();

  /// Applies the values of this tuple to an 1-ary function.
  R map<R>(R Function(T1 first) callback) => callback($1);

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => toList();

  /// An (untyped) [List] with the values of this tuple.
  List<dynamic> toList() => [$1];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<dynamic> toSet() => {$1};
}
