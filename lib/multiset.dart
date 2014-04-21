/**
 * A [Set] like data structure where elements are allowed to appear more
 * than once.
 */
library multiset;

import 'dart:collection';
import 'dart:math';

/**
 * A generalized [Set] (or Bag) in which members are allowed to appear
 * more than once.
 */
class Multiset<E> extends IterableBase<E> {

  /**
   * Creates an empty [Multiset].
   */
  factory Multiset() => new Multiset<E>._(new Map<E, int>(), 0);

  /**
   * Creates an empty identity [Multiset].
   */
  factory Multiset.identity() => new Multiset<E>._(new Map<E, int>.identity(), 0);

  /**
   * Creates a [Multiset] that contains all elements of [other].
   */
  factory Multiset.from(Iterable<E> other) {
    if (other is Multiset<E>) {
      return new Multiset<E>._(new Map.from(other._container), other._length);
    } else {
      return new Multiset<E>()..addAll(other);
    }
  }

  /**
   * Creates a [Multiset] where the elements and their occurence count is
   * computed from an [iterable].
   *
   * The [key] function specifies the actual elements added to the collection.
   * The default implementation is the identity function. Repetitions are possible
   * and merge into the previously added elements.
   *
   * The [count] function specifies the number of elements added to the
   * collection. The default function returns the constant 1.
   */
  factory Multiset.fromIterable(Iterable iterable, {E key(element), int count(element)}) {
    var result = new Multiset<E>();
    if (key == null) key = (element) => element;
    if (count == null) count = (element) => 1;
    for (var element in iterable) {
      result.add(key(element), count(element));
    }
    return result;
  }

  /**
   * The backing container of the set.
   */
  final Map<E, int> _container;

  /**
   * The cached number of elements.
   */
  int _length;

  Multiset._(this._container, this._length);

  /**
   * Adds [element] to the receiver [occurrences] number of times.
   *
   * Throws an [ArgumentError] if [occurences] is negative.
   */
  void add(E element, [int occurences = 1]) {
    if (occurences < 0) {
      throw new ArgumentError('Negative number of occurences: $occurences');
    } else if (occurences > 0) {
      _container[element] = this[element] + occurences;
      _length += occurences;
    }
  }

  /**
   * Adds all of [elements] to the receiver.
   */
  void addAll(Iterable<E> elements) {
    elements.forEach(add);
  }

  /**
   * Removes [element] from the receiver [occurrences] number of times.
   *
   * Throws an [ArgumentError] if [occurences] is negative.
   */
  void remove(Object element, [int occurences = 1]) {
    if (occurences < 0) {
      throw new ArgumentError('Negative number of occurences: $occurences');
    } else if (occurences > 0) {
      var current = this[element];
      if (current <= occurences) {
        _container.remove(element);
        _length -= current;
      } else {
        _container[element] = current - occurences;
        _length -= occurences;
      }
    }
  }

  /**
   * Removes each element of [elements] from the receiver.
   */
  void removeAll(Iterable<Object> elements) {
    elements.forEach(remove);
  }

  /**
   * Removes all elements from the receiver.
   */
  void clear() {
    _container.clear();
    _length = 0;
  }

  /**
   * Gets the number of occurences of an [element].
   */
  int operator [](Object element) {
    return _container.containsKey(element) ? _container[element] : 0;
  }

  /**
   * Sets the number of [occurences] of an [element].
   *
   * Throws an [ArgumentError] if [occurences] is negative.
   */
  void operator []=(E element, int occurences) {
    if (occurences < 0) {
      throw new ArgumentError('Negative number of occurences: $occurences');
    } else {
      var current = this[element];
      if (occurences > 0) {
        _container[element] = occurences;
        _length += occurences - current;
      } else {
        _container.remove(element);
        _length -= current;
      }
    }
  }

  /**
   * Returns `true` if [element] is in the receiver.
   */
  @override
  bool contains(Object element) => _container.containsKey(element);

  /**
   * Returns `true` if all elements of [other] are contained in the receiver.
   */
  bool containsAll(Iterable<Object> other) {
    if (other.isEmpty) {
      return true;
    } else if (other.length == 1) {
      return contains(other.first);
    } else if (other is Multiset) {
      var multiset = other as Multiset;
      for (var element in multiset.distinct) {
        if (this[element] < multiset[element]) {
          return false;
        }
      }
      return true;
    } else {
      return containsAll(new Multiset.from(other));
    }
  }

  /**
   * Returns a new [Multiset] with the elements that are in the receiver as well
   * as those in [other].
   */
  Multiset<E> intersection(Iterable<Object> other) {
    if (other is Multiset) {
      var result = new Multiset<E>();
      var multiset = other as Multiset;
      for (var element in distinct) {
        result.add(element, min(this[element], multiset[element]));
      }
      return result;
    } else {
      return intersection(new Multiset.from(other));
    }
  }

  /**
   * Returns a new [Multiset] with all the elements of the receiver and those
   * in [other].
   */
  Multiset<E> union(Iterable<E> other) {
    return new Multiset<E>.from(this)..addAll(other);
  }

  /**
   * Returns a new [Multiset] with all the elements of the receiver that are
   * not in [other].
   */
  Multiset<E> difference(Iterable<Object> other) {
    return new Multiset<E>.from(this)..removeAll(other);
  }

  /**
   * Iterator over the repeated elements of the reciever.
   */
  @override
  Iterator<E> get iterator => new _MultisetIterator<E>(_container, distinct.iterator);

  /**
   * Returns a view on the distinct elements of the receiver.
   */
  Iterable<E> get distinct => _container.keys;

  /**
   * Returns the total number of elements in the receiver.
   */
  @override
  int get length => _length;

}

class _MultisetIterator<E> extends Iterator<E> {

  final Map<E, int> _container;
  final Iterator<E> _elements;

  int _remaining = 0;

  _MultisetIterator(this._container, this._elements);

  @override
  E get current => _elements.current;

  @override
  bool moveNext() {
    if (_remaining > 0) {
      _remaining--;
      return true;
    } else {
      if (!_elements.moveNext()) {
        return false;
      }
      _remaining = _container[_elements.current] - 1;
      return true;
    }
  }

}
