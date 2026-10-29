/// Extension on [Iterable] to group consecutive elements.
extension GroupIterableExtension<V> on Iterable<V> {
  /// Groups consecutive keys of this [Iterable].
  ///
  /// The [key] is a function computing a key value for each element. If none is
  /// specified, the value itself is used as the key. Generally, the iterable
  /// should be sorted on the same key function.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = ['a', 'a', 'a', 'b', 'b', 'c'];
  /// print(input.groupBy());  // [a: [a, a, a], b: [b, b], c: [c]]
  /// ```
  Iterable<Group<K, V>> groupBy<K>([K Function(V element)? key]) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      final grouper = key ?? (element) => element as K;
      var currentKey = grouper(iterator.current);
      var currentValues = <V>[iterator.current];
      while (iterator.moveNext()) {
        final nextKey = grouper(iterator.current);
        if (currentKey == nextKey) {
          currentValues.add(iterator.current);
        } else {
          yield Group<K, V>(currentKey, currentValues);
          currentKey = nextKey;
          currentValues = <V>[iterator.current];
        }
      }
      yield Group<K, V>(currentKey, currentValues);
    }
  }
}

/// A group of values.
typedef Group<K, V> = MapEntry<K, List<V>>;

/// Extension to access the index on the [Group] values.
extension GroupMapEntryExtension<K, V> on Group<K, V> {
  /// The values of the group.
  List<V> get values => value;
}
