extension LexicographicalComparator<T> on Comparator<T> {
  /// Returns a [Comparator] that orders iterables of type [T] lexicographically
  /// by their elements.
  Comparator<Iterable<T>> get lexicographical => (a, b) {
    final ia = a.iterator, ib = b.iterator;
    while (ia.moveNext()) {
      if (!ib.moveNext()) {
        return 1;
      }
      final result = this(ia.current, ib.current);
      if (result != 0) {
        return result;
      }
    }
    return ib.moveNext() ? -1 : 0;
  };
}
