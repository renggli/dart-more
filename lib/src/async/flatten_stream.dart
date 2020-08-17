extension FlattenStreamExtension<T> on Stream<Stream<T>> {
  /// Flattens a [Stream] of [Stream]s to a flattened [Stream].
  Stream<T> flatten() => asyncExpand((stream) => stream);
}
