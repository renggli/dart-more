extension FlattenStreamStreamExtension<E> on Stream<Stream<E>> {
  /// Flattens a [Stream] of [Stream]s to a flattened [Stream].
  Stream<E> flatten() => asyncExpand<E>((stream) => stream);
}
