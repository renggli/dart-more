import 'dart:collection' show IterableBase;
import 'dart:math' show min;

import '../iterable/repeat.dart';

/// A generalized [Set] (or Bag) in which members are allowed to appear  more
/// than once.
class Multiset<E> extends IterableBase<E> {
  /// Creates an empty [Multiset].
  factory Multiset() => Multiset<E>._({}, 0);

  /// Creates an empty identity [Multiset].
  factory Multiset.identity() => Multiset<E>._(Map<E, int>.identity(), 0);

  /// Creates a [Multiset] that contains all elements of [other].
  factory Multiset.of(Iterable<E> other) {
    if (other is Multiset<E>) {
      return Multiset<E>._(Map.of(other._container), other._length);
    } else if (other is Set<E>) {
      return Multiset<E>._(
          Map.fromIterables(other, repeat(1, count: other.length)),
          other.length);
    } else {
      return Multiset<E>()..addAll(other);
    }
  }

  /// Creates a [Multiset] that contains all elements of [other].
  factory Multiset.from(Iterable<E> other) => Multiset.of(other);

  /// Creates a [Multiset] where the elements and their occurrence count is
  /// computed from an [iterable].
  ///
  /// The [key] function specifies the actual elements added to the collection.
  /// The default implementation is the identity function. Repetitions are
  /// possible and merge into the previously added elements.
  ///
  /// The [count] function specifies the number of elements added to the
  /// collection. The default function returns the constant 1.
  factory Multiset.fromIterable/*<E>*/(
    Iterable/*<E>*/ iterable, {
    // ignore: use_function_type_syntax_for_parameters
    E key(/*E*/ element)?,
    // ignore: use_function_type_syntax_for_parameters
    int count(/*E*/ element)?,
  }) {
    final result = Multiset<E>();
    key ??= (element) => element as E;
    count ??= (element) => 1;
    for (final element in iterable) {
      result.add(key(element), count(element));
    }
    return result;
  }

  /// Internal constructor.
  Multiset._(this._container, this._length);

  /// Internal backing container of the set.
  final Map<E, int> _container;

  /// Internal cache of the size of the size.
  int _length;

  /// Adds [element] to the receiver [occurrences] number of times.
  ///
  /// Throws an [ArgumentError] if [occurrences] is negative.
  void add(E element, [int occurrences = 1]) {
    if (occurrences < 0) {
      throw ArgumentError('Negative number of occurrences: $occurrences');
    } else if (occurrences > 0) {
      _container[element] = this[element] + occurrences;
      _length += occurrences;
    }
  }

  /// Adds all of [elements] to the receiver.
  void addAll(Iterable<E> elements) {
    elements.forEach(add);
  }

  /// Removes [element] from the receiver [occurrences] number of times.
  ///
  /// Throws an [ArgumentError] if [occurrences] is negative.
  void remove(Object? element, [int occurrences = 1]) {
    if (occurrences < 0) {
      throw ArgumentError('Negative number of occurrences: $occurrences');
    }
    if (element is E && occurrences > 0) {
      final current = this[element];
      if (current <= occurrences) {
        _container.remove(element);
        _length -= current;
      } else {
        _container[element] = current - occurrences;
        _length -= occurrences;
      }
    }
  }

  /// Removes each element of [elements] from the receiver.
  void removeAll(Iterable elements) {
    elements.forEach(remove);
  }

  /// Removes all elements from the receiver.
  void clear() {
    _container.clear();
    _length = 0;
  }

  /// Gets the number of occurrences of an [element].
  int operator [](Object? element) => _container[element] ?? 0;

  /// Sets the number of [occurrences] of an [element].
  ///
  /// Throws an [ArgumentError] if [occurrences] is negative.
  void operator []=(E element, int occurrences) {
    if (occurrences < 0) {
      throw ArgumentError('Negative number of occurrences: $occurrences');
    } else {
      final current = this[element];
      if (occurrences > 0) {
        _container[element] = occurrences;
        _length += occurrences - current;
      } else {
        _container.remove(element);
        _length -= current;
      }
    }
  }

  /// Returns `true` if [element] is in the receiver.
  @override
  bool contains(Object? element) => _container.containsKey(element);

  /// Returns `true` if all elements of [other] are contained in the receiver.
  bool containsAll(Iterable other) {
    if (other.isEmpty) {
      return true;
    } else if (other.length == 1) {
      return contains(other.first);
    } else if (other is Multiset) {
      for (final element in other.distinct) {
        if (this[element] < other[element]) {
          return false;
        }
      }
      return true;
    } else {
      return containsAll(Multiset.of(other));
    }
  }

  /// Returns a new [Multiset] with the elements that are in the receiver as
  /// well as those in [other].
  Multiset<E> intersection(Iterable other) {
    if (other is Multiset) {
      final result = Multiset<E>();
      for (final element in distinct) {
        result.add(element, min(this[element], other[element]));
      }
      return result;
    } else {
      return intersection(Multiset.of(other));
    }
  }

  /// Returns a new [Multiset] with all the elements of the receiver and those
  /// in [other].
  Multiset<E> union(Iterable<E> other) => Multiset<E>.of(this)..addAll(other);

  /// Returns a new [Multiset] with all the elements of the receiver that are
  /// not in [other].
  Multiset<E> difference(Iterable other) =>
      Multiset<E>.of(this)..removeAll(other);

  /// Iterator over the repeated elements of the receiver.
  @override
  Iterator<E> get iterator => _container.entries
      .expand((entry) => repeat(entry.key, count: entry.value))
      .iterator;

  /// Returns a view on the distinct elements of the receiver.
  Iterable<E> get distinct => _container.keys;

  /// Returns a view on the counts of the distinct elements of the receiver.
  Iterable<int> get counts => _container.values;

  /// Returns the total number of elements in the receiver.
  @override
  int get length => _length;
}

extension MultisetExtension<T> on Iterable<T> {
  Multiset<T> toMultiset() => Multiset.of(this);
}
