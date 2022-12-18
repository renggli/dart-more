extension FlattenExtension<E> on Iterable<Iterable<E>> {
  /// Flattens an [Iterable] of [Iterable]s to a flattened [Iterable].
  Iterable<E> flatten() => expand((values) => values);
}
