extension FlatMapStreamExtension<E> on Stream<E> {
  /// Maps each element of this [Stream] using a mapping function to zero or
  /// more elements, then flattens the result into a continuous stream.
  ///
  /// This is an alias for [Stream.expand].
  Stream<T> flatMap<T>(Iterable<T> Function(E element) callback) =>
      expand<T>(callback);

  /// Maps each element of this [Stream] using a mapping function to a stream,
  /// then flattens the result into a continuous stream.
  ///
  /// This is an alias for [Stream.asyncExpand].
  Stream<T> asyncFlatMap<T>(Stream<T> Function(E element) callback) =>
      asyncExpand<T>(callback);
}
