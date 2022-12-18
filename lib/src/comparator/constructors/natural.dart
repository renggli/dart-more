/// Returns a natural [Comparator] for objects of type `T`.
@Deprecated('Use `naturalCompare` or `naturalComparable<T>` instead')
Comparator<T> naturalComparator<T>() => naturalCompare;

/// Natural dynamic [Comparator] function.
int naturalCompare(Object? a, Object? b) =>
    (a as Comparable<Object?>).compareTo(b);

/// Natural static [Comparator] function using [Comparable] arguments.
int naturalComparable<T extends Comparable<T>>(T a, T b) => a.compareTo(b);
