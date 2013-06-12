// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

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
 * Abstract ordering.
 *
 * The [Ordering] defines an order on elements of type [T]. The order of
 * two elements can be determined using [compare].
 *
 *     WHITESPACE(' '.codeUnitAt(0)); // true
 *     DIGIT('a'.codeUnitAt(0)); // false
 *
 * A large collection of helper methods let you perform string operations on
 * the occurences of the specified class of characters: trimming, collapsing,
 * replacing, removing, retaining, etc. For example:
 *
 *     String withoutWhitespace = WHITESPACE.removeFrom(string);
 *     String onlyDigits = DIGIT.retainFrom(string);
 *
 */
abstract class Ordering<T> {

  /**
   * Returns a natural ordering of objects.
   */
  factory Ordering.natural() => new _NaturalOrdering<T>();

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
  Ordering();

  /**
   * Compares two objects with another. Returns -1 if [:a < b:], 0 if
   * [:a == b:], and 1 if [:a > b:].
   */
  int compare(T a, T b);

  /**
   * Returns a [Comparator] function.
   */
  Comparator<T> get comparator => (T a, T b) => compare(a, b);

  /**
   * Returns the reverse ordering.
   */
  Ordering<T> operator ~ () => new _ReverseOrdering<T>(this);

  /**
   * Returns an ordering that breaks the tie of the receiver by using [other].
   */
  Ordering<T> operator & (Ordering<T> other) => new _CompoundOrdering<T>([this, other]);

  /**
   * Returns a lexicographical ordering.
   */
  Ordering<T> lexicographical() => new _LexicographicalOrdering<T>(this);

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
  Ordering<T> map(T function(argument)) => new _FunctionOrdering<T>(this, function);

  /**
   * Searches the sorted [list] for the specified [value] using binary search.
   *
   * The method returns the index of the element, or a negative value if the key
   * was not found. The result is undefined if the list is not sorted.
   */
  int binarySearch(List<T> list, T value, {low, high}) {
    if (low == null) low = 0;
    if (high == null) high = list.length - 1;
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
    list.sort(comparator);
  }

  /**
   * Returns a sorted copy of provided [iterable].
   */
  List<T> sorted(Iterable<T> iterable) {
    var list = new List.from(iterable, growable: false);
    sort(list);
    return list;
  }

  /**
   * Tests if the specified [Iterable] is in increasing order.
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
   * Returns the maximum of the provided iterable.
   */
  T max(Iterable<T> iterable, { T orElse() }) {
    var iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var max = iterator.current;
      while (iterator.moveNext()) {
        if (compare(max, iterator.current) < 0) {
          max = iterator.current;
        }
      }
      return max;
    }
    if (orElse == null) {
      throw new StateError('Unable to find maximum in $iterable.');
    }
    return orElse();
  }


  /**
   * Returns the minimum of the provided iterable.
   */
  T min(Iterable<T> iterable, { T orElse() }) {
    var iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var min = iterator.current;
      while (iterator.moveNext()) {
        if (compare(min, iterator.current) > 0) {
          min = iterator.current;
        }
      }
      return min;
    }
    if (orElse == null) {
      throw new StateError('Unable to find minimum in $iterable.');
    }
    return orElse();
  }

}

class _NaturalOrdering<T> extends Ordering<T> {
  int compare(a, b) => a.compareTo(b);
  String toString() => 'new Ordering.natural()';
}

class _ComparatorOrdering<T> extends Ordering<T> {
  final Comparator<T> _comparator;
  _ComparatorOrdering(this._comparator);
  int compare(T a, T b) => _comparator(a, b);
  Comparator<T> get comparator => _comparator;
  String toString() => 'new Ordering.from($_comparator)';
}

class _ExplicitOrdering<T> extends Ordering<T> {
  final Map<T, int> _ranking;
  _ExplicitOrdering(this._ranking);
  int compare(T a, T b) => _rank(a) - _rank(b);
  int _rank(T element) {
    int rank = _ranking[element];
    if (rank == null) {
      throw new StateError('Unable to compare $element with $this');
    }
    return rank;
  }
  String toString() => 'new Ordering.explicit(${_ranking.keys})';
}

class _ReverseOrdering<T> extends Ordering<T> {
  final Ordering<T> _other;
  _ReverseOrdering(this._other);
  int compare(T a, T b) => _other.compare(b, a);
  Ordering<T> operator ~ () => _other;
  String toString() => '~$_other';
}

class _CompoundOrdering<T> extends Ordering<T> {
  final List<Ordering<T>> _orderings;
  _CompoundOrdering(this._orderings);
  int compare(T a, T b) {
    for (var ordering in _orderings) {
      var result = ordering.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }
  Ordering<T> operator & (Ordering<T> other) {
    var orderings = new List.from(_orderings);
    orderings.add(other);
    return new _CompoundOrdering(new List.from(orderings, growable: false));
  }
  String toString() => _orderings.join(' & ');
}

class _LexicographicalOrdering<T> extends Ordering<T> {
  final Ordering<T> _ordering;
  _LexicographicalOrdering(this._ordering);
  int compare(List<T> a, List<T> b) {
    var length = a.length < b.length ? a.length : b.length;
    for (var i = 0; i < length; i++) {
      var result = _ordering.compare(a[i], b[i]);
      if (result != 0) {
        return result;
      }
    }
    return a.length - b.length;
  }
  String toString() => '$_ordering.lexicographical()';
}

class _NullsFirstOrdering<T> extends Ordering<T> {
  final Ordering<T> _ordering;
  _NullsFirstOrdering(this._ordering);
  int compare(T a, T b) {
    if (identical(a, b)) return 0;
    if (identical(a, null)) return -1;
    if (identical(b, null)) return 1;
    return _ordering.compare(a, b);
  }
  String toString() => '$_ordering.nullsFirst()';
}

class _NullsLastOrdering<T> extends Ordering<T> {
  final Ordering<T> _ordering;
  _NullsLastOrdering(this._ordering);
  int compare(T a, T b) {
    if (identical(a, b)) return 0;
    if (identical(a, null)) return 1;
    if (identical(b, null)) return -1;
    return _ordering.compare(a, b);
  }
  String toString() => '$_ordering.nullsLast()';
}

class _FunctionOrdering<T> extends Ordering<T> {
  final Ordering<T> _ordering;
  final Function _function;
  _FunctionOrdering(this._ordering, this._function);
  int compare(T a, T b) => _ordering.compare(_function(a), _function(b));
  String toString() => '$_ordering.map($_function)';
}