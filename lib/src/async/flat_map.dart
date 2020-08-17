extension FlatMapExtension<T> on Stream<T> {
  /// Maps each element of this [Stream] using a mapping function to zero or
  /// more elements, then flattens the result into a continuous stream.
  ///
  /// This is an alias for [Stream.expand].
  Stream<S> flatMap<S>(Iterable<S> Function(T element) callback) =>
      expand<S>(callback);

  /// Maps each element of this [Stream] using a mapping function to a stream,
  /// then flattens the result into a continuous stream.
  ///
  /// This is an alias for [Stream.asyncExpand].
  Stream<S> asyncFlatMap<S>(Stream<S> Function(T element) callback) =>
      asyncExpand<S>(callback);
}
