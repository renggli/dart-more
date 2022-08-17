extension ReversedComparator<T> on Comparator<T> {
  /// Returns a [Comparator] that orders elements in reverse order.
  Comparator<T> get reversed => (a, b) => this(b, a);
}
