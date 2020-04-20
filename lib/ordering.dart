/// Provides a first-class model of comparators, their composition and
/// operations on iterables.
library more.ordering;

import 'package:meta/meta.dart' show immutable;

import 'src/ordering/comparator.dart';
import 'src/ordering/compound.dart';
import 'src/ordering/explicit.dart';
import 'src/ordering/function.dart';
import 'src/ordering/lexicographical.dart';
import 'src/ordering/natural.dart';
import 'src/ordering/nulls_first.dart';
import 'src/ordering/nulls_last.dart';
import 'src/ordering/reversed.dart';

/// An ordering implements a [Comparator] function that can be modified
/// using a fluent interface.
///
/// The [Ordering] defines a total order on objects of type [T]. For example,
/// the natural order of two [String] instances can be determined using:
///
///     final natural = Ordering.natural<String>();
///     natural.compare('a', 'b');  // -1
///
/// However, the low-level [compare] function rarely needs to be used
/// directly. [Ordering] implements various fluent helpers that create new
/// orderings
///
///     natural.reverse();  // a reverse ordering
///     natural.nullsFirst();  // orders null values before other values
///     natural.compound(other);  // breaks ties of natural with other order
///
/// and that allow the user to perform common tasks on an ordering:
///
///     natural.min('a', 'b');  // 'a'
///     natural.maxOf(['a', 'b', 'c']);  // 'c'
///     natural.sorted(['dog', 'cat', 'ape']);  // ['ape', 'cat', 'dog']
///     natural.isOrdered(['ape', 'cat', 'dog']);  // true
///
@immutable
abstract class Ordering<T> {
  /// Returns a natural ordering of objects.
  static Ordering<T> natural<T extends Comparable<T>>() => NaturalOrdering<T>();

  /// Returns an ordering based on a [comparator] function.
  factory Ordering.of(Comparator<T> comparator) =>
      ComparatorOrdering<T>(comparator);

  /// Returns an ordering based on a [comparator] function.
  factory Ordering.from(Comparator<T> comparator) =>
      ComparatorOrdering<T>(comparator);

  /// Returns an explicit ordering based on an [iterable] of elements.
  factory Ordering.explicit(Iterable<T> iterable) =>
      ExplicitOrdering<T>(iterable);

  /// Internal default constructor for subclasses.
  const Ordering();

  /// Compares two objects [a] and [b] with each other and returns
  ///
  /// * a negative integer if [a] is smaller than [b],
  /// * zero if [a] is equal to [b], and
  /// * a positive integer if [a] is greater than [b].
  int compare(T a, T b);

  /// Returns the reversed ordering.
  Ordering<T> get reversed => ReversedOrdering<T>(this);

  /// Returns an ordering that orders `null` values before non-null values.
  Ordering<T> get nullsFirst => NullsFirstOrdering<T>(this);

  /// Returns an ordering that orders `null` values after non-null values.
  Ordering<T> get nullsLast => NullsLastOrdering<T>(this);

  /// Returns an ordering that breaks the tie of the receiver by using [other].
  Ordering<T> compound(Ordering<T> other) => CompoundOrdering<T>([this, other]);

  /// Returns an ordering that orders iterables lexicographically by
  /// their elements.
  Ordering<Iterable<T>> get lexicographical => LexicographicalOrdering<T>(this);

  /// Returns an ordering that uses the provided [function] to transform the
  /// result.
  Ordering<F> onResultOf<F>(T Function(F argument) function) =>
      MappedOrdering<F, T>(this, function);

  /// Searches the sorted [list] for the specified [value] using binary search.
  ///
  /// The method returns the index of the element, or a negative value if the
  /// key was not found. The result is undefined if the list is not sorted.
  int binarySearch(List<T> list, T value) {
    var min = 0;
    var max = list.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final comp = compare(list[mid], value);
      if (comp == 0) {
        return mid;
      } else if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -min - 1;
  }

  /// Sorts the provided [list] in-place.
  void sort(List<T> list) => list.sort(compare);

  /// Returns a sorted copy of the provided [iterable].
  List<T> sorted(Iterable<T> iterable) {
    final list = List.of(iterable, growable: false);
    sort(list);
    return list;
  }

  /// Tests if the specified [iterable] is in increasing order.
  bool isOrdered(Iterable<T> iterable) {
    final iterator = iterable.iterator;
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

  /// Tests if the specified [Iterable] is in strict increasing order.
  bool isStrictlyOrdered(Iterable<T> iterable) {
    final iterator = iterable.iterator;
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

  /// Returns the maximum of the two arguments [a] and [b].
  T max(T a, T b) => compare(a, b) > 0 ? a : b;

  /// Returns the maximum of the provided [iterable].
  T maxOf(Iterable<T> iterable, {T Function() orElse}) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        value = max(value, iterator.current);
      }
      return value;
    }
    if (orElse == null) {
      throw StateError('Unable to find maximum in $iterable.');
    }
    return orElse();
  }

  /// Returns the minimum of the two arguments [a] and [b].
  T min(T a, T b) => compare(a, b) < 0 ? a : b;

  /// Returns the minimum of the provided [iterable].
  T minOf(Iterable<T> iterable, {T Function() orElse}) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        value = min(value, iterator.current);
      }
      return value;
    }
    if (orElse == null) {
      throw StateError('Unable to find minimum in $iterable.');
    }
    return orElse();
  }
}
