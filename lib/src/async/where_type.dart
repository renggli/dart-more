extension WhereTypeExtension<E> on Stream<E> {
  /// Returns a [Stream] with all elements that have type [T].
  Stream<T> whereType<T>() => where((value) => value is T).cast<T>();
}
