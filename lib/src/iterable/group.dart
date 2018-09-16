library more.iterable.group;

/// Groups consecutive keys of [elements].
///
/// The [key] is a function computing a key value for each element. If none is
/// specified, the value itself is used as the key. Generally, the iterable
/// should be sorted on the same key function.
///
/// For example, the expression
///
///     groupBy(['a', 'a', 'a', 'b', 'b', 'c'])
///         .map((group) => '${group.key}: ${group.values}'
///         .join(', ')
///
/// returns
///
///     'a: aaa, b: bb, c: c'
///
Iterable<Group<K, V>> groupBy<K, V>(Iterable<V> elements,
    [K key(V element)]) sync* {
  final iterator = elements.iterator;
  if (iterator.moveNext()) {
    final grouper = key ?? (element) => element as K;
    var group = Group(grouper(iterator.current), <V>[iterator.current]);
    while (iterator.moveNext()) {
      final nextKey = grouper(iterator.current);
      if (group.key == nextKey) {
        group.values.add(iterator.current);
      } else {
        yield group;
        group = Group(grouper(iterator.current), <V>[iterator.current]);
      }
    }
    yield group;
  }
}

/// A group of values.
class Group<K, V> {
  final K key;
  final List<V> values;
  const Group(this.key, this.values);
}
