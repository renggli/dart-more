extension CompoundComparator<T> on Comparator<T> {
  /// Returns a [Comparator] that breaks a tie of this comparator by delegating
  /// to another `comparator`.
  Comparator<T> compound(Comparator<T> comparator) => (a, b) {
        final result = this(a, b);
        if (result != 0) return result;
        return comparator(a, b);
      };
}

extension CompoundIterableComparator<T> on Iterable<Comparator<T>> {
  /// Returns a [Comparator] that tries each of the comparators in this
  /// iterable and returns the first result that doesn't end up in a tie.
  Comparator<T> toComparator() => (a, b) {
        for (var comparator in this) {
          final result = comparator(a, b);
          if (result != 0) return result;
        }
        return 0;
      };
}
