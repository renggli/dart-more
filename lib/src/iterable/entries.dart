extension EntriesExtension<E> on Iterable<E> {
  /// Returns an [Iterable] of [MapEntry] objects which the index of each
  /// element as its key and the element itself as its value.
  ///
  /// For example, the expression
  ///
  ///     ['a', 'b'].entries.toMap()
  ///
  /// converts the input [Iterable] to a [Map]:
  ///
  ///     {0: a, 1: b}
  ///
  Iterable<MapEntry<int, E>> get entries sync* {
    var offset = 0;
    for (final element in this) {
      yield MapEntry<int, E>(offset++, element);
    }
  }
}
