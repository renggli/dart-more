// AUTO-GENERATED CODE: DO NOT EDIT

/// Extension methods on [Record] with 1 positional element.
extension Tuple1<T1> on (T1,) {
  /// Creates a tuple from the elements in [list].
  static (T,) fromList<T>(List<T> list) {
    if (list.length != 1) {
      throw ArgumentError.value(
        list,
        'list',
        'Expected list of length 1, but got ${list.length}',
      );
    }
    return (list[0],);
  }

  /// The number of elements in the tuple.
  int get length => 1;

  /// The first element of this tuple.
  T1 get first => $1;

  /// The last element of this tuple.
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

  /// Transforms the elements of this tuple using [callback].
  R map<R>(R Function(T1 first) callback) => callback($1);

  /// An untyped [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => toList();

  /// Converts this tuple to an untyped [List].
  List<dynamic> toList() => [$1];

  /// Converts this tuple to an untyped [Set] of unique values.
  Set<dynamic> toSet() => {$1};
}
