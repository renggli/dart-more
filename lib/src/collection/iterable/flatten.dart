extension FlattenIterableExtension<E> on Iterable<Iterable<E>> {
  /// Flattens an [Iterable] of [Iterable]s to a flattened [Iterable].
  ///
  /// For example:
  ///
  ///     final input = [[1, 2], [3, 4]];
  ///     print(input.flatten());   // [1, 2, 3, 4]
  ///
  Iterable<E> flatten() => expand((values) => values);
}

extension DeepFlattenIterableExtension on Iterable<dynamic> {
  /// Flattens arbitrarily nested [Iterable]s with elements of type [E]. Throws
  /// an [ArgumentError] when encountering an value of an unexpected type.
  ///
  /// For example:
  ///
  ///     final input = [1, 2, [3, 4, [5, 6]]];
  ///     print(input.deepFlatten());   // [1, 2, 3, 4, 5, 6]
  ///
  Iterable<E> deepFlatten<E>() sync* {
    for (final value in this) {
      if (value is E) {
        yield value;
      } else if (value is Iterable) {
        yield* value.deepFlatten<E>();
      } else {
        throw ArgumentError.value(value, 'value', 'Invalid value');
      }
    }
  }
}
