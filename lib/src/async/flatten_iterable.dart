extension FlattenStreamIterableExtension<E> on Stream<Iterable<E>> {
  /// Flattens a [Stream] of [Iterable]s to a flattened [Stream].
  Stream<E> flatten() => expand<E>((iterable) => iterable);
}
