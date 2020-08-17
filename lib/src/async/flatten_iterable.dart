extension FlattenIterableExtension<T> on Stream<Iterable<T>> {
  /// Flattens a [Stream] of [Iterable]s to a flattened [Stream].
  Stream<T> flatten() => expand((iterable) => iterable);
}
