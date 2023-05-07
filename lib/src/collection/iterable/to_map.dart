extension ToMapIterableExtension<E> on Iterable<E> {
  /// Returns an [Map] from an [Iterable].
  ///
  /// For example, the expression
  ///
  ///     ['a', 'bb', 'ccc'].toMap(
  ///       key: (each) => each[0],
  ///       value: (each) => each.length,
  ///     )
  ///
  /// converts the input [Iterable] to a [Map]:
  ///
  ///     {'a': 1, 'b': 2, 'c': 3}
  ///
  Map<K, V> toMap<K, V>(
      {K Function(E element)? key, V Function(E element)? value}) {
    final keyProvider = key ?? (element) => element as K;
    final valueProvider = value ?? (element) => element as V;
    return {
      for (var element in this) keyProvider(element): valueProvider(element),
    };
  }
}
