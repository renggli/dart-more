extension FlatMapExtension<E> on Iterable<E> {
  /// Maps each element of this [Iterable] using a mapping function to zero or
  /// more elements, then flattens the result into a continuous iterable.
  ///
  /// This is an alias for [Iterable.expand].
  Iterable<T> flatMap<T>(Iterable<T> Function(E element) callback) =>
      expand<T>(callback);
}
