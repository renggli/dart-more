/// Returns a natural [Comparator] for objects of type `T`.
Comparator<T> naturalComparator<T>() => _compare;

int _compare(Object? a, Object? b) => (a as Comparable<Object?>).compareTo(b);
