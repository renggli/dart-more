// AUTO-GENERATED CODE: DO NOT EDIT

/// Extension methods on [Record] with 0 positional elements.
extension Tuple0 on () {
  /// Creates a tuple from the elements in [list].
  static () fromList<T>(List<T> list) {
    if (list.isNotEmpty) {
      throw ArgumentError.value(
        list,
        'list',
        'Expected list of length 0, but got ${list.length}',
      );
    }
    return ();
  }

  /// The number of elements in the tuple.
  int get length => 0;

  /// Returns a new tuple with [value] added at the first position.
  (T,) addFirst<T>(T value) => (value,);

  /// Returns a new tuple with [value] added at the last position.
  (T,) addLast<T>(T value) => (value,);

  /// Transforms the elements of this tuple using [callback].
  R map<R>(R Function() callback) => callback();

  /// An untyped [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => toList();

  /// Converts this tuple to an untyped [List].
  List<dynamic> toList() => const [];

  /// Converts this tuple to an untyped [Set] of unique values.
  Set<dynamic> toSet() => const {};
}
