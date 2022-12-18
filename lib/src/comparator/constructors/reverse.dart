/// Returns a reversed [Comparator] for objects of type `T`.
@Deprecated('Use `reverseCompare` or `reverseComparable<T>` instead')
Comparator<T> reverseComparator<T>() => reverseCompare;

/// Reversed dynamic [Comparator] function.
int reverseCompare(Object? a, Object? b) =>
    (b as Comparable<Object?>).compareTo(a);

/// Reversed static [Comparator] function using [Comparable] arguments.
int reverseComparable<T extends Comparable<T>>(T a, T b) => b.compareTo(a);
