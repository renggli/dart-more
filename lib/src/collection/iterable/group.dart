extension GroupExtension<V> on Iterable<V> {
  /// Groups consecutive keys of this [Iterable].
  ///
  /// The [key] is a function computing a key value for each element. If none is
  /// specified, the value itself is used as the key. Generally, the iterable
  /// should be sorted on the same key function.
  ///
  /// For example, the expression
  ///
  ///     ['a', 'a', 'a', 'b', 'b', 'c'].groupBy()
  ///         .map((group) => '${group.key}: ${group.values}'
  ///         .join(', ')
  ///
  /// returns
  ///
  ///     'a: aaa, b: bb, c: c'
  ///
  Iterable<Group<K, V>> groupBy<K>([K Function(V element)? key]) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      final grouper = key ?? (element) => element as K;
      var group = Group<K, V>(grouper(iterator.current), <V>[iterator.current]);
      while (iterator.moveNext()) {
        final nextKey = grouper(iterator.current);
        if (group.key == nextKey) {
          group.value.add(iterator.current);
        } else {
          yield group;
          group = Group<K, V>(grouper(iterator.current), <V>[iterator.current]);
        }
      }
      yield group;
    }
  }
}

/// A group of values.
typedef Group<K, V> = MapEntry<K, List<V>>;
