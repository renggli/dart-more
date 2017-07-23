library more.iterable.unique;

import 'dart:collection' show IterableBase, HashSet;

typedef bool Equality<E>(E a, E b);
typedef int Hash<E>(E a);

/// Returns a lazy iterable that filters out duplicates from the [Iterator].
/// If [equals] and [hashCode] are omitted, the iterator uses the objects'
/// intrinsic [Object.operator==] and [Object.hashCode] for comparison.
///
/// The following expression iterates over 1, 2, 3, and 4:
///
///     unique([1, 2, 3, 2, 4])
///
Iterable<E> unique<E>(Iterable<E> iterable, {Equality<E> equals, Hash<E> hashCode}) {
  return new UniqueIterable<E>(iterable, equals, hashCode);
}

class UniqueIterable<E> extends IterableBase<E> {
  final Iterable<E> iterable;
  final Equality<E> equals;
  final Hash<E> hash;

  UniqueIterable(this.iterable, this.equals, this.hash);

  @override
  Iterator<E> get iterator {
    var uniques = new HashSet(equals: equals, hashCode: hash);
    return iterable.where((element) => uniques.add(element)).iterator;
  }
}
