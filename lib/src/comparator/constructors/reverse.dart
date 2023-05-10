/// Reversed dynamic [Comparator] function.
int reverseCompare(Object? a, Object? b) =>
    (b as Comparable<Object?>).compareTo(a);

/// Reversed static [Comparator] function using [Comparable] arguments.
int reverseComparable<T extends Comparable<T>>(T a, T b) => b.compareTo(a);
