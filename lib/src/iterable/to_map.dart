extension ToMapIterableExtension<E> on Iterable<E> {
  /// Returns an [Map] from an [Iterable] of [MapEntry] objects.
  ///
  /// For example, the expression
  ///
  ///     ['a', 'b'].entries.toMap()
  ///
  /// converts the input [Iterable] to a [Map]:
  ///
  ///     {0: a, 1: b}
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

extension ToMapIterableMapEntryExtension<K, V> on Iterable<MapEntry<K, V>> {
  /// Returns an [Map] from an [Iterable] of [MapEntry] objects.
  ///
  /// For example, the expression
  ///
  ///     ['a', 'b'].entries.toMap()
  ///
  /// converts the input [Iterable] to a [Map]:
  ///
  ///     {0: a, 1: b}
  ///
  Map<K, V> toMap() => Map.fromEntries(this);
}
