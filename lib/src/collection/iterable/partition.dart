extension PartitionIterableExtension<E> on Iterable<E> {
  /// Splits this iterable into two lists: the `truthy` list where the [test] predicate
  /// is `true` and the `falsey` list where the [test] predicate is `false`.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = [1, 2, 3, 4];
  /// final output = partition((each) => each.isEven);
  /// print(output);  // (truthy: [2, 4], falsey: [1, 3])
  /// ```
  ({List<E> truthy, List<E> falsey}) partition(bool Function(E element) test) {
    final truthy = <E>[], falsey = <E>[];
    for (final element in this) {
      if (test(element)) {
        truthy.add(element);
      } else {
        falsey.add(element);
      }
    }
    return (truthy: truthy, falsey: falsey);
  }
}
