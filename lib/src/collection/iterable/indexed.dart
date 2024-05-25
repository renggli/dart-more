extension IndexedIterableExtension<E> on Iterable<E> {
  /// Returns a iterable that combines the index and value of this [Iterable].
  ///
  /// By default the index is zero based, but an arbitrary [offset] can be
  /// provided.
  ///
  /// For example, the following expression returns `'1: a, 2: b'`:
  ///
  /// ```dart
  /// ['a', 'b'].indexed(start: 1)
  ///   .map((each) => '${each.index}: ${each.value}')
  ///   .join(', ');
  /// ```
  Iterable<Indexed<E>> indexed({
    int start = 0,
    int step = 1,
    @Deprecated('Use `start` instead of `offset`') int? offset,
  }) sync* {
    var index = offset ?? start;
    for (final element in this) {
      yield Indexed<E>(index, element);
      index += step;
    }
  }
}

/// An indexed value.
typedef Indexed<E> = MapEntry<int, E>;

/// Extension to access the index on a [Indexed] value.
extension IndexedMapEntryExtension<E> on Indexed<E> {
  /// The index of the entry.
  int get index => key;
}
