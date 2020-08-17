extension WhereTypeExtension<T> on Stream<T> {
  /// Returns a [Stream] with all elements that have type [S].
  Stream<S> whereType<S>() => where((value) => value is S).cast<S>();
}
