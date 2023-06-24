/// Extension methods on [Record] with 0 positional elements.
extension Tuple0 on () {
  /// List constructor.
  static () fromList<T>(List<T> list) {
    if (list.isNotEmpty) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 0, but got ${list.length}');
    }
    return ();
  }

  /// Returns the number of elements in the tuple.
  int get length => 0;

  /// Returns a new tuple with [value] added at the first position.
  (T,) addFirst<T>(T value) => (value,);

  /// Returns a new tuple with [value] added at the last position.
  (T,) addLast<T>(T value) => (value,);

  /// Applies the values of this tuple to an 0-ary function.
  R map<R>(R Function() callback) => callback();

  /// An (untyped) [Iterable] over the values of this tuple.
  Iterable<dynamic> get iterable => const [];

  /// An (untyped) [List] with the values of this tuple.
  List<dynamic> toList() => const [];

  /// An (untyped) [Set] with the unique values of this tuple.
  Set<dynamic> toSet() => const {};
}
