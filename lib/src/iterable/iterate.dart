/// One argument function returning an object of the same type.
typedef IterateCallback<E> = E Function(E value);

/// Returns a lazy infinite list of repeated applications of the [function] to
/// the initial [value].
///
/// For example, the expression
///
///     iterate(0, (n) => n + 1);
///
/// results in the infinite iterable of all natural numbers:
///
///     [0, 1, 2, 3, 4, ...]
///
Iterable<E> iterate<E>(E value, IterateCallback<E> function) sync* {
  while (true) {
    yield value;
    value = function(value);
  }
}
