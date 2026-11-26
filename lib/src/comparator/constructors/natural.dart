/// Natural dynamic [Comparator] function.
int naturalCompare(Object? a, Object? b) =>
    (a as Comparable<Object?>).compareTo(b);

/// Natural static [Comparator] function using [Comparable] arguments.
int naturalComparable<T extends Comparable<Object?>>(T a, T b) =>
    a.compareTo(b);
