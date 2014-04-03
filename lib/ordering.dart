/**
 * Provides a first-class model of comparators, their composition
 * and operations on iterables.
 *
 * The implementation closely follows [Guava](http://goo.gl/xXROX), the Google
 * collection of libraries for Java-based projects.
 */
library ordering;

import 'dart:collection';

/**
 * An ordering implements a [Comparator] function that can be modified
 * using a fluent interface.
 *
 * The [Ordering] defines a total order on objects of type [T]. For example,
 * the natural order of two objects can be determined using:
 *
 *     var natural = new Ordering.natural();
 *     natural.compare(1, 2);  // 1
 *
 * However, the low-level [compare] function rarely needs to be used
 * directly. [Ordering] implements various fluent helpers that create new
 * orderings
 *
 *     natural.reverse();  // a reverse ordering
 *     natural.nullsFirst();  // orders null values before other values
 *     natural.compount(other);  // breaks ties of natural with other order
 *
 * and that allow the user to perform common tasks on an ordering:
 *
 *     natural.min(1, 2);  // 1
 *     natural.maxOf([8, 2, 9, 1]);  // 9
 *     natural.sort(['dog', 'cat', 'ape']);  // ['ape', 'cat', 'dog']
 *     natural.isOrdered(['ape', 'cat', 'dog']);  // true
 *
 */
abstract class Ordering<T> {

  /**
   * Returns a natural ordering of objects.
   */
  factory Ordering.natural() => const _NaturalOrdering();

  /**
   * Returns an ordering based on a [comparator] function.
   */
  factory Ordering.from(Comparator<T> comparator) => new _ComparatorOrdering<T>(comparator);

  /**
   * Returns an explicit ordering based on a [list] of elements.
   */
  factory Ordering.explicit(List<T> list) {
    var ranking = new LinkedHashMap();
    for (var rank = 0; rank < list.length; rank++) {
      ranking[list[rank]] = rank;
    }
    return new _ExplicitOrdering<T>(ranking);
  }

  /**
   * Internal default constructor for subclasses.
   */
  const Ordering();

  /**
   * Compares two objects [a] and [b] with each other and returns
   *
   * * a negative integer if [a] is smaller than [b],
   * * zero if [a] is equal to [b], and
   * * a positive integer if [a] is greater than [b].
   */
  int compare(T a, T b);

  /**
   * Returns the reverse ordering.
   */
  Ordering<T> reverse() => new _ReverseOrdering<T>(this);

  /**
   * Returns an ordering that breaks the tie of the receiver by using [other].
   */
  Ordering<T> compound(Ordering<T> other) => new _CompoundOrdering<T>([this, other]);

  /**
   * Returns an ordering that orders iterables lexicographically by
   * their elements.
   */
  Ordering<Iterable<T>> lexicographical() => new _LexicographicalOrdering<T>(this);

  /**
   * Returns an ordering that orders [null] values before non-null values.
   */
  Ordering<T> nullsFirst() => new _NullsFirstOrdering<T>(this);

  /**
   * Returns an ordering that orders [null] values after non-null values.
   */
  Ordering<T> nullsLast() => new _NullsLastOrdering<T>(this);

  /**
   * Returns an ordering that uses the provided [function] to transform the result.
   */
  Ordering onResultOf(T function(argument)) => new _FunctionOrdering(this, function);

  /**
   * Searches the sorted [list] for the specified [value] using binary search.
   *
   * The search can be optinally limited to a range between [low] and [high].
   *
   * The method returns the index of the element, or a negative value if the key
   * was not found. The result is undefined if the list is not sorted.
   */
  int binarySearch(List<T> list, T value, {low, high}) {
    if (low == null) {
      low = 0;
    }
    if (high == null) {
      high = list.length - 1;
    }
    while (low <= high) {
      var mid = low + (high - low) ~/ 2;
      var cmp = compare(list[mid], value);
      if (cmp > 0) {
        high = mid - 1;
      } else if (cmp < 0) {
        low = mid + 1;
      } else {
        return mid;
      }
    }
    return -low - 1;
  }

  /**
   * Sorts the provided [list] in place.
   */
  void sort(List<T> list) {
    list.sort(compare);
  }

  /**
   * Returns a sorted copy of the provided [iterable].
   */
  List<T> sorted(Iterable<T> iterable) {
    var list = new List.from(iterable, growable: false);
    sort(list);
    return list;
  }

  /**
   * Tests if the specified [iterable] is in increasing order.
   */
  bool isOrdered(Iterable<T> iterable) {
    var iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var previous = iterator.current;
      while (iterator.moveNext()) {
        if (compare(previous, iterator.current) > 0) {
          return false;
        }
        previous = iterator.current;
      }
    }
    return true;
  }

  /**
   * Tests if the specified [Iterable] is in strict increasing order.
   */
  bool isStrictlyOrdered(Iterable<T> iterable) {
    var iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var previous = iterator.current;
      while (iterator.moveNext()) {
        if (compare(previous, iterator.current) >= 0) {
          return false;
        }
        previous = iterator.current;
      }
    }
    return true;
  }

  /**
   * Returns the maximum of the two arguments [a] and [b].
   */
  T max(T a, T b) {
    return compare(a, b) > 0 ? a : b;
  }

  /**
   * Returns the maximum of the provided [iterable].
   */
  T maxOf(Iterable<T> iterable, {T orElse()}) {
    var iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        value = max(value, iterator.current);
      }
      return value;
    }
    if (orElse == null) {
      throw new StateError('Unable to find maximum in $iterable.');
    }
    return orElse();
  }

  /**
   * Returns the minimum of the two arguments [a] and [b].
   */
  T min(T a, T b) {
    return compare(a, b) < 0 ? a : b;
  }

  /**
   * Returns the minimum of the provided [iterable].
   */
  T minOf(Iterable<T> iterable, {T orElse()}) {
    var iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        value = min(value, iterator.current);
      }
      return value;
    }
    if (orElse == null) {
      throw new StateError('Unable to find minimum in $iterable.');
    }
    return orElse();
  }

}

class _NaturalOrdering<T> extends Ordering<T> {

  const _NaturalOrdering();

  @override
  int compare(a, b) => a.compareTo(b);

}

class _ComparatorOrdering<T> extends Ordering<T> {

  final Comparator<T> _comparator;

  _ComparatorOrdering(this._comparator);

  @override
  int compare(T a, T b) => _comparator(a, b);

}

class _ExplicitOrdering<T> extends Ordering<T> {

  final Map<T, int> _ranking;

  _ExplicitOrdering(this._ranking);

  @override
  int compare(T a, T b) => _rank(a) - _rank(b);

  int _rank(T element) {
    var rank = _ranking[element];
    if (rank == null) {
      throw new StateError('Unable to compare $element with $this');
    }
    return rank;
  }

}

class _ReverseOrdering<T> extends Ordering<T> {

  final Ordering<T> _other;

  _ReverseOrdering(this._other);

  @override
  int compare(T a, T b) => _other.compare(b, a);

  @override
  Ordering<T> reverse() => _other;

}

class _CompoundOrdering<T> extends Ordering<T> {

  final List<Ordering<T>> _orderings;

  _CompoundOrdering(this._orderings);

  @override
  int compare(T a, T b) {
    for (var ordering in _orderings) {
      var result = ordering.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }

  @override
  Ordering<T> compound(Ordering<T> other) {
    var orderings = new List.from(_orderings)..add(other);
    return new _CompoundOrdering(new List.from(orderings, growable: false));
  }

}

class _LexicographicalOrdering<T> extends Ordering<Iterable<T>> {

  final Ordering<T> _other;

  _LexicographicalOrdering(this._other);

  @override
  int compare(Iterable<T> a, Iterable<T> b) {
    var ia = a.iterator, ib = b.iterator;
    while (ia.moveNext()) {
      if (!ib.moveNext()) {
        return 1;
      }
      var result = _other.compare(ia.current, ib.current);
      if (result != 0) {
        return result;
      }
    }
    return ib.moveNext() ? -1 : 0;
  }

}

class _NullsFirstOrdering<T> extends Ordering<T> {

  final Ordering<T> _ordering;

  _NullsFirstOrdering(this._ordering);

  @override
  int compare(T a, T b) {
    if (identical(a, b)) {
      return 0;
    } else if (identical(a, null)) {
      return -1;
    } else if (identical(b, null)) {
      return 1;
    } else {
      return _ordering.compare(a, b);
    }
  }

}

class _NullsLastOrdering<T> extends Ordering<T> {

  final Ordering<T> _ordering;

  _NullsLastOrdering(this._ordering);

  @override
  int compare(T a, T b) {
    if (identical(a, b)) {
      return 0;
    } else if (identical(a, null)) {
      return 1;
    } else if (identical(b, null)) {
      return -1;
    } else {
      return _ordering.compare(a, b);
    }
  }

}

class _FunctionOrdering<T> extends Ordering<T> {

  final Ordering _ordering;

  final Function _function;

  _FunctionOrdering(this._ordering, this._function);

  @override
  int compare(a, b) => _ordering.compare(_function(a), _function(b));

}
